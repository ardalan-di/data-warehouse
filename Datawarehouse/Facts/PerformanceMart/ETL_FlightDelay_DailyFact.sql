CREATE OR ALTER PROCEDURE [DW].[Load_FlightDelay_DailyFact]
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @StartDate date;
	DECLARE @EndDate date;

	SELECT @EndDate = MAX(CAST(ActualDepartureDateTime AS DATE)) FROM [SA].[FlightOperation];
	SELECT @StartDate = MAX(DateID) FROM [DW].[FlightDelay_DailyFact];

    IF @StartDate IS NULL
    BEGIN
        SELECT @StartDate = MIN(CAST(ActualDepartureDateTime AS DATE)) FROM [SA].[FlightOperation];
    END
    ELSE
    BEGIN
        SET @StartDate = DATEADD(day, 1, @StartDate);
    END;

	IF @StartDate > @EndDate
	BEGIN
		RAISERROR('The FlightDelay_DailyFact table is up to date!', 0, 1) WITH NOWAIT;
		RETURN;
	END

	DECLARE @CurrentDate date = @StartDate;

	WHILE @CurrentDate <= @EndDate
	BEGIN
		DECLARE @LogID BIGINT;
		DECLARE @StartTime DATETIME2(3) = SYSUTCDATETIME();
		DECLARE @RowCount INT;

		INSERT INTO DW.ETL_Log (ProcedureName, TargetTable, ChangeDescription, ActionTime, Status)
		VALUES ('Load_FlightDelay_DailyFact', 'FlightDelay_DailyFact', 'Procedure started for date: ' + CONVERT(varchar, @CurrentDate, 101), @StartTime, 'Running');

		SET @LogID = SCOPE_IDENTITY();

		BEGIN TRY
			WITH DailyAggregates AS (
				SELECT
					ac.AirlineID, fd.DepartureAirportID, fd.DestinationAirportID,
					COUNT(*) AS DailyFlightsNumber,
					SUM(CASE WHEN fo.DelayMinutes > 0 THEN 1 ELSE 0 END) AS DailyDelayedFlightsNumber,
					SUM(CASE WHEN fo.CancelFlag = 1 THEN 1 ELSE 0 END) AS DailyCancelledFlightsNumber,
					AVG(CAST(fo.DelayMinutes AS FLOAT)) AS DailyAvgDepartureDelayMinutes,
					MAX(fo.DelayMinutes) AS DailyMaxDelayMinutes
				FROM [SA].[FlightOperation] fo
				INNER JOIN [SA].[FlightDetail] fd ON fo.FlightDetailID = fd.FlightDetailID
				INNER JOIN [SA].[Aircraft] ac ON fd.AircraftID = ac.AircraftID
				WHERE CAST(fo.ActualDepartureDateTime AS DATE) = @CurrentDate
				GROUP BY ac.AirlineID, fd.DepartureAirportID, fd.DestinationAirportID
			)
			INSERT INTO [DW].[FlightDelay_DailyFact] (
				DateID, AirlineID, DepartureAirportID, ArrivalAirportID, DailyFlightsNumber,
				DailyDelayedFlightsNumber, DailyCancelledFlightsNumber, DailyAvgDepartureDelayMinutes,
				DailyAvgArrivalDelayMinutes, DailyMaxDelayMinutes, DailyDelayRate, DailyOnTimePercentage
			)
			SELECT
				@CurrentDate, agg.AirlineID, agg.DepartureAirportID, agg.DestinationAirportID, agg.DailyFlightsNumber,
				agg.DailyDelayedFlightsNumber, agg.DailyCancelledFlightsNumber, agg.DailyAvgDepartureDelayMinutes,
				agg.DailyAvgDepartureDelayMinutes, agg.DailyMaxDelayMinutes,
				CASE WHEN agg.DailyFlightsNumber > 0 THEN CAST(agg.DailyDelayedFlightsNumber AS FLOAT) / agg.DailyFlightsNumber ELSE 0 END,
				CASE WHEN agg.DailyFlightsNumber > 0 THEN CAST(agg.DailyFlightsNumber - agg.DailyDelayedFlightsNumber - agg.DailyCancelledFlightsNumber AS FLOAT) / agg.DailyFlightsNumber * 100.0 ELSE 0 END
			FROM DailyAggregates agg;

			SET @RowCount = @@ROWCOUNT;
			UPDATE DW.ETL_Log SET ChangeDescription = 'Load complete for date: ' + CONVERT(varchar, @CurrentDate, 101), RowsAffected = @RowCount, DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()), Status = 'Success' WHERE LogID = @LogID;
		END TRY
		BEGIN CATCH
			DECLARE @ErrMsg NVARCHAR(MAX) = ERROR_MESSAGE();
			UPDATE DW.ETL_Log SET ChangeDescription = 'Load failed for date: ' + CONVERT(varchar, @CurrentDate, 101), DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()), Status = 'Error', Message = @ErrMsg WHERE LogID = @LogID;
			THROW;
		END CATCH

		SET @CurrentDate = DATEADD(day, 1, @CurrentDate);
	END;

	RAISERROR('FlightDelay_DailyFact loading process has completed.', 0, 1) WITH NOWAIT;
	SET NOCOUNT OFF;
END
GO