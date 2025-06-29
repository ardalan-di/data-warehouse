CREATE OR ALTER PROCEDURE [DW].[Load_PassengerActivity_YearlyFact]
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @StartDate date;
	DECLARE @EndDate date;

	SELECT
		@EndDate = MAX(FlightDateKey)
	FROM
		[DW].[PassengerTicket_TransactionalFact];

    SELECT
        @StartDate = MAX(CAST(YearID AS DATE))
    FROM
        [DW].[PassengerActivity_YearlyFact]

	IF @StartDate IS NULL
	BEGIN
		RAISERROR('No data found in PassengerTicket_TransactionalFact to process.', 0, 1) WITH NOWAIT;
		RETURN;
	END

    IF @StartDate >= @EndDate
	BEGIN
		RAISERROR('The PassengerActivity_YearlyFact table is up to date!', 0, 1) WITH NOWAIT;
		RETURN;
	END

	DECLARE @CurrentYear INT = YEAR(@StartDate);
	DECLARE @EndYear INT = YEAR(@EndDate);

	WHILE @CurrentYear <= @EndYear
	BEGIN
		DECLARE @LogID BIGINT;
		DECLARE @StartTime DATETIME2(3) = SYSUTCDATETIME();
		DECLARE @RowCount INT;

		INSERT INTO DW.ETL_Log (ProcedureName, TargetTable, ChangeDescription, ActionTime, Status)
		VALUES ('Load_PassengerActivity_YearlyFact', 'PassengerActivity_YearlyFact', 'Procedure started for year: ' + CAST(@CurrentYear AS VARCHAR), @StartTime, 'Running');

		SET @LogID = SCOPE_IDENTITY();

		BEGIN TRY
			WITH YearlyAggregates AS (
				SELECT
					fptt.TicketHolderPersonKey,
					SUM(fptt.TicketPrice) AS TotalAmountPaid,
					SUM(fptt.kilometersFlown) AS TotalKilometersFlown,
					SUM(fptt.DiscountAmount) AS TotalDiscountAmount,
					AVG(fptt.TicketPrice) AS AverageTicketPrice,
					COUNT(DISTINCT fptt.AirlineKey) AS DistinctAirlinesUsed,
					COUNT(DISTINCT CONCAT(fptt.SourceAirportKey, '-', fptt.DestinationAirportKey)) AS DistinctRoutesFlown,
					COUNT(DISTINCT fptt.FlightKey) AS TotalFlights,
					MAX(fptt.kilometersFlown) AS MaxFlightDistanceKM,
					MIN(fptt.kilometersFlown) AS MinFlightDistanceKM
				FROM
					[DW].[PassengerTicket_TransactionalFact] fptt
				INNER JOIN
					[DW].[DimPayment] dp ON fptt.PaymentKey = dp.PaymentKey
				WHERE
					YEAR(fptt.FlightDateKey) = @CurrentYear
					AND dp.PaymentStatus = 'Completed'
				GROUP BY
					fptt.TicketHolderPersonKey
			)
			INSERT INTO [DW].[PassengerActivity_YearlyFact] (
				YearID,
				PersonKey,
				YearlyTicketValue,
				YearlyMilesFlown,
				YearlyDiscountAmount,
				YearlyAverageTicketPrice,
				YearlyDistinctAirlinesUsed,
				YearlyDistinctRoutesFlown,
				YearlyFlights,
				YearlyMaxFlightDistance,
				YearlyMinFlightDistance
			)
			SELECT
				DATEFROMPARTS(@CurrentYear, 1, 1),
				current_person.PersonKey,
				agg.TotalAmountPaid,
				agg.TotalKilometersFlown,
				agg.TotalDiscountAmount,
				agg.AverageTicketPrice,
				agg.DistinctAirlinesUsed,
				agg.DistinctRoutesFlown,
				agg.TotalFlights,
				agg.MaxFlightDistanceKM,
				agg.MinFlightDistanceKM
			FROM
				YearlyAggregates agg
			INNER JOIN [DW].[DimPerson] historical_person ON agg.TicketHolderPersonKey = historical_person.PersonKey
			INNER JOIN [DW].[DimPerson] current_person ON historical_person.PersonID = current_person.PersonID AND current_person.PassportNumberIsCurrent = 1;

			SET @RowCount = @@ROWCOUNT;

			UPDATE DW.ETL_Log SET ChangeDescription = 'Load complete for year: ' + CAST(@CurrentYear AS VARCHAR), RowsAffected = @RowCount, DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()), Status = 'Success' WHERE LogID = @LogID;

		END TRY
		BEGIN CATCH
			DECLARE @ErrMsg NVARCHAR(MAX) = ERROR_MESSAGE();
			UPDATE DW.ETL_Log SET ChangeDescription = 'Load failed for year: ' + CAST(@CurrentYear AS VARCHAR), DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()), Status = 'Error', Message = @ErrMsg WHERE LogID = @LogID;
			THROW;
		END CATCH


		SET @CurrentYear = @CurrentYear + 1;

	END;

	RAISERROR('PassengerActivity_YearlyFact loading process has completed.', 0, 1) WITH NOWAIT;
	SET NOCOUNT OFF;
END
GO