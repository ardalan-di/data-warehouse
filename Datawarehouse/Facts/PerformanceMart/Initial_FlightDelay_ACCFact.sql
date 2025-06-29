CREATE OR ALTER PROCEDURE [DW].[Initial_FlightDelay_ACCFact]
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @LogID BIGINT;
	DECLARE @StartTime DATETIME2(3) = SYSUTCDATETIME();
	DECLARE @RowCount INT;

	INSERT INTO DW.ETL_Log (ProcedureName, TargetTable, ChangeDescription, ActionTime, Status)
	VALUES ('Initial_FlightDelay_ACCFact', 'FlightDelay_ACCFact', 'Procedure started for initial full load', @StartTime, 'Running');

	SET @LogID = SCOPE_IDENTITY();

	BEGIN TRY
		WITH LifetimeAggregates AS (
			SELECT
				ac.AirlineID,
				fd.DepartureAirportID,
				fd.DestinationAirportID,
				COUNT(*) AS TotalFlightsNumber,
				SUM(CASE WHEN fo.DelayMinutes > 0 THEN 1 ELSE 0 END) AS TotalDelayedFlightsNumber,
				SUM(CASE WHEN fo.CancelFlag = 1 THEN 1 ELSE 0 END) AS TotalCancelledFlightsNumber,
				AVG(CAST(fo.DelayMinutes AS FLOAT)) AS TotalAvgDepartureDelayMinutes,
				MAX(fo.DelayMinutes) AS TotalMaxDelayMinutes
			FROM
				[SA].[FlightOperation] fo
			INNER JOIN
				[SA].[FlightDetail] fd ON fo.FlightDetailID = fd.FlightDetailID
			INNER JOIN
				[SA].[Aircraft] ac ON fd.AircraftID = ac.AircraftID
			GROUP BY
				ac.AirlineID,
				fd.DepartureAirportID,
				fd.DestinationAirportID
		)
		INSERT INTO [DW].[FlightDelay_ACCFact] (
			AirlineID, DepartureAirportID, ArrivalAirportID, TotalFlightsNumber, TotalDelayedFlightsNumber,
			TotalCancelledFlightsNumber, TotalAvgDepartureDelayMinutes, TotalAvgArrivalDelayMinutes,
			TotalMaxDelayMinutes, TotalDelayRate, TotalOnTimePercentage
		)
		SELECT
			agg.AirlineID, agg.DepartureAirportID, agg.DestinationAirportID, agg.TotalFlightsNumber, agg.TotalDelayedFlightsNumber,
			agg.TotalCancelledFlightsNumber, agg.TotalAvgDepartureDelayMinutes, agg.TotalAvgDepartureDelayMinutes,
			agg.TotalMaxDelayMinutes,
			CASE WHEN agg.TotalFlightsNumber > 0 THEN CAST(agg.TotalDelayedFlightsNumber AS FLOAT) / agg.TotalFlightsNumber ELSE 0 END,
			CASE WHEN agg.TotalFlightsNumber > 0 THEN CAST(agg.TotalFlightsNumber - agg.TotalDelayedFlightsNumber - agg.TotalCancelledFlightsNumber AS FLOAT) / agg.TotalFlightsNumber * 100.0 ELSE 0 END
		FROM
			LifetimeAggregates agg;

		SET @RowCount = @@ROWCOUNT;
		UPDATE DW.ETL_Log SET ChangeDescription = 'Initial full load complete', RowsAffected = @RowCount, DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()), Status = 'Success' WHERE LogID = @LogID;

	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg NVARCHAR(MAX) = ERROR_MESSAGE();
		UPDATE DW.ETL_Log SET ChangeDescription = 'Initial full load failed', DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()), Status = 'Error', Message = @ErrMsg WHERE LogID = @LogID;
		THROW;
	END CATCH

	RAISERROR('Initial FlightDelay_ACCFact loading process has completed.', 0, 1) WITH NOWAIT;
	SET NOCOUNT OFF;
END
GO
