CREATE OR ALTER PROCEDURE [DW].[Initial_PassengerActivity_ACCFact]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @LogID BIGINT;
    DECLARE @StartTime DATETIME2(3) = SYSUTCDATETIME();
    DECLARE @RowCount INT;

    INSERT INTO DW.ETL_Log (ProcedureName, TargetTable, ChangeDescription, ActionTime, Status)
    VALUES ('Initial_PassengerActivity_ACCFact', 'PassengerActivity_ACCFact', 'Procedure started for initial full load', @StartTime, 'Running');

    SET @LogID = SCOPE_IDENTITY();

    BEGIN TRY

        TRUNCATE TABLE [DW].[Temp_LifetimeSourceData];

        WITH LifetimeSummableAggregates AS (
            SELECT
                PersonKey,
                SUM(YearlyFlights) AS TotalFlights,
                SUM(YearlyTicketValue) AS TotalAmountPaid,
                SUM(YearlyMilesFlown) AS TotalMilesFlown,
                SUM(YearlyDiscountAmount) AS TotalDiscountAmount,
                MAX(YearlyMaxFlightDistance) AS MaxFlightDistance,
                MIN(YearlyMinFlightDistance) AS MinFlightDistance
            FROM [DW].[PassengerActivity_YearlyFact]
            GROUP BY PersonKey
        ),
        LifetimeDistinctAggregates AS (
            SELECT
                current_person.PersonKey,
                COUNT(DISTINCT fptt.AirlineKey) AS DistinctAirlinesUsed,
                COUNT(DISTINCT CONCAT(fptt.SourceAirportKey, '-', fptt.DestinationAirportKey)) AS DistinctRoutesFlown
            FROM [DW].[PassengerTicket_TransactionalFact] fptt
            INNER JOIN [DW].[DimPayment] dp ON fptt.PaymentKey = dp.PaymentKey
            INNER JOIN [DW].[DimPerson] historical_person ON fptt.TicketHolderPersonKey = historical_person.PersonKey
            INNER JOIN [DW].[DimPerson] current_person ON historical_person.PersonID = current_person.PersonID AND current_person.EffectiveTo IS NULL
            WHERE dp.PaymentStatus = 'Completed'
            GROUP BY current_person.PersonKey
        )
        INSERT INTO [DW].[PassengerActivity_ACCFact] (
            PersonKey, TotalTicketValue, TotalAmountPaid, TotalMilesFlown, TotalDiscountAmount,
            AverageTicketPrice, TotalDistinctAirlinesUsed, TotalDistinctRoutesFlown,
            TotalFlights, MaxFlightDistance, MinFlightDistance
        )
        SELECT
            sa.PersonKey,
            sa.TotalFlights AS TotalTicketValue,
            sa.TotalAmountPaid,
            sa.TotalMilesFlown,
            sa.TotalDiscountAmount,
            CASE WHEN sa.TotalFlights > 0 THEN sa.TotalAmountPaid / sa.TotalFlights ELSE 0 END,
            da.DistinctAirlinesUsed,
            da.DistinctRoutesFlown,
            sa.TotalFlights,
            sa.MaxFlightDistance,
            sa.MinFlightDistance
        FROM LifetimeSummableAggregates sa
        LEFT JOIN LifetimeDistinctAggregates da ON sa.PersonKey = da.PersonKey;

        SET @RowCount = @@ROWCOUNT;
        UPDATE DW.ETL_Log
            SET ChangeDescription = 'Initial full load complete',
                RowsAffected = @RowCount,
                DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()),
                Status = 'Success'
        WHERE LogID = @LogID;

    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(MAX) = ERROR_MESSAGE();
        UPDATE DW.ETL_Log
            SET ChangeDescription = 'Initial full load failed',
                DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()),
                Status = 'Error',
                Message = @ErrMsg
        WHERE LogID = @LogID;
        THROW;
    END CATCH

    RAISERROR('Initial PassengerActivity_ACCFact loading process has completed.', 0, 1) WITH NOWAIT;
    SET NOCOUNT OFF;
END
GO
