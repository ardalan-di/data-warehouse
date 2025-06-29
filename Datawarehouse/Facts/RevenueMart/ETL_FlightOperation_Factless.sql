CREATE OR ALTER PROCEDURE [DW].[Load_FlightOperation_Factless]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @LogID BIGINT;
	DECLARE @StartTime DATETIME2(3) = SYSUTCDATETIME();
	DECLARE @RowCount INT;

	INSERT INTO DW.ETL_Log (ProcedureName, TargetTable, ChangeDescription, ActionTime, Status)
	VALUES ('Load_FlightOperation_Factless', 'FlightOperation_Factless', 'Procedure started for incremental merge', @StartTime, 'Running');

	SET @LogID = SCOPE_IDENTITY();

	BEGIN TRY

		MERGE [DW].[FactFlightOperation_Factless] AS Target
		USING (
			SELECT
				fd.FlightDetailID AS FlightKey,
				fd.DepartureAirportID AS SourceAirportKey,
				fd.DestinationAirportID AS DestinationAirportKey,
				ac.AirlineID AS AirlineKey,
				fd.AircraftID AS AircraftKey,
				CASE
					WHEN fo.CancelFlag = 1 THEN 3
					WHEN fo.DelayMinutes > 0 THEN 2
					ELSE 1
				END AS OperationTypeKey
			FROM
				[SA].[FlightOperation] fo
			INNER JOIN
				[SA].[FlightDetail] fd ON fo.FlightDetailID = fd.FlightDetailID
			INNER JOIN
				[SA].[Aircraft] ac ON fd.AircraftID = ac.AircraftID
		) AS Source
		ON (Target.FlightKey = Source.FlightKey)

		WHEN MATCHED AND Target.OperationTypeKey <> Source.OperationTypeKey THEN
			UPDATE SET
				Target.SourceAirportKey = Source.SourceAirportKey,
				Target.DestinationAirportKey = Source.DestinationAirportKey,
				Target.AirlineKey = Source.AirlineKey,
				Target.AircraftKey = Source.AircraftKey,
				Target.OperationTypeKey = Source.OperationTypeKey

		WHEN NOT MATCHED BY TARGET THEN
			INSERT (
				FlightKey,
				SourceAirportKey,
				DestinationAirportKey,
				AirlineKey,
				AircraftKey,
				OperationTypeKey
			)
			VALUES (
				Source.FlightKey,
				Source.SourceAirportKey,
				Source.DestinationAirportKey,
				Source.AirlineKey,
				Source.AircraftKey,
				Source.OperationTypeKey
			);


		SET @RowCount = @@ROWCOUNT;

		UPDATE DW.ETL_Log SET ChangeDescription = 'Incremental merge complete', RowsAffected = @RowCount, DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()), Status = 'Success' WHERE LogID = @LogID;

	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg NVARCHAR(MAX) = ERROR_MESSAGE();
		UPDATE DW.ETL_Log SET ChangeDescription = 'Incremental merge failed', DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()), Status = 'Error', Message = @ErrMsg WHERE LogID = @LogID;
		THROW;
	END CATCH

	RAISERROR('FlightOperation_Factless loading process has completed.', 0, 1) WITH NOWAIT;
	SET NOCOUNT OFF;
END
GO