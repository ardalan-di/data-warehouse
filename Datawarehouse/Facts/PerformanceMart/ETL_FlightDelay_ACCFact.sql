CREATE OR ALTER PROCEDURE [DW].[Load_FlightDelay_ACCFact]
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @LogID BIGINT;
	DECLARE @StartTime DATETIME2(3) = SYSUTCDATETIME();
	DECLARE @RowCount INT;

	INSERT INTO DW.ETL_Log (ProcedureName, TargetTable, ChangeDescription, ActionTime, Status)
	VALUES ('Load_FlightDelay_ACCFact', 'FlightDelay_ACCFact', 'Procedure started for incremental merge', @StartTime, 'Running');

	SET @LogID = SCOPE_IDENTITY();

	BEGIN TRY

		MERGE [DW].[FlightDelay_ACCFact] AS Target
		USING (

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
		) AS Source
		ON (Target.AirlineID = Source.AirlineID AND Target.DepartureAirportID = Source.DepartureAirportID AND Target.ArrivalAirportID = Source.DestinationAirportID)

		WHEN MATCHED THEN
			UPDATE SET
				Target.TotalFlightsNumber = Source.TotalFlightsNumber,
				Target.TotalDelayedFlightsNumber = Source.TotalDelayedFlightsNumber,
				Target.TotalCancelledFlightsNumber = Source.TotalCancelledFlightsNumber,
				Target.TotalAvgDepartureDelayMinutes = Source.TotalAvgDepartureDelayMinutes,
				Target.TotalAvgArrivalDelayMinutes = Source.TotalAvgDepartureDelayMinutes,
				Target.TotalMaxDelayMinutes = Source.TotalMaxDelayMinutes,
				Target.TotalDelayRate = CASE WHEN Source.TotalFlightsNumber > 0 THEN CAST(Source.TotalDelayedFlightsNumber AS FLOAT) / Source.TotalFlightsNumber ELSE 0 END,
				Target.TotalOnTimePercentage = CASE WHEN Source.TotalFlightsNumber > 0 THEN CAST(Source.TotalFlightsNumber - Source.TotalDelayedFlightsNumber - Source.TotalCancelledFlightsNumber AS FLOAT) / Source.TotalFlightsNumber * 100.0 ELSE 0 END

		WHEN NOT MATCHED BY TARGET THEN
			INSERT (
				AirlineID, DepartureAirportID, ArrivalAirportID, TotalFlightsNumber, TotalDelayedFlightsNumber,
				TotalCancelledFlightsNumber, TotalAvgDepartureDelayMinutes, TotalAvgArrivalDelayMinutes,
				TotalMaxDelayMinutes, TotalDelayRate, TotalOnTimePercentage
			)
			VALUES (
				Source.AirlineID, Source.DepartureAirportID, Source.DestinationAirportID, Source.TotalFlightsNumber, Source.TotalDelayedFlightsNumber,
				Source.TotalCancelledFlightsNumber, Source.TotalAvgDepartureDelayMinutes, Source.TotalAvgDepartureDelayMinutes,
				Source.TotalMaxDelayMinutes,
				CASE WHEN Source.TotalFlightsNumber > 0 THEN CAST(Source.TotalDelayedFlightsNumber AS FLOAT) / Source.TotalFlightsNumber ELSE 0 END,
				CASE WHEN Source.TotalFlightsNumber > 0 THEN CAST(Source.TotalFlightsNumber - Source.TotalDelayedFlightsNumber - Source.TotalCancelledFlightsNumber AS FLOAT) / Source.TotalFlightsNumber * 100.0 ELSE 0 END
			);

		SET @RowCount = @@ROWCOUNT;
		UPDATE DW.ETL_Log SET ChangeDescription = 'Incremental merge complete', RowsAffected = @RowCount, DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()), Status = 'Success' WHERE LogID = @LogID;

	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg NVARCHAR(MAX) = ERROR_MESSAGE();
		UPDATE DW.ETL_Log SET ChangeDescription = 'Incremental merge failed', DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()), Status = 'Error', Message = @ErrMsg WHERE LogID = @LogID;
		THROW;
	END CATCH

	RAISERROR('Load_FlightDelay_ACCFact loading process has completed.', 0, 1) WITH NOWAIT;
	SET NOCOUNT OFF;
END
GO
