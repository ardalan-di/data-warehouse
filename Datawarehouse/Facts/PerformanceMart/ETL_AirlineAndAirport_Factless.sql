CREATE OR ALTER PROCEDURE [DW].[Load_AirlineAndAirport_Factless]
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @LogID BIGINT;
	DECLARE @StartTime DATETIME2(3) = SYSUTCDATETIME();
	DECLARE @RowCount INT;

	INSERT INTO DW.ETL_Log (ProcedureName, TargetTable, ChangeDescription, ActionTime, Status)
	VALUES ('Load_AirlineAndAirport_Factless', 'AirlineAndAirport_Factless', 'Procedure started for incremental merge', @StartTime, 'Running');

	SET @LogID = SCOPE_IDENTITY();

	BEGIN TRY

		MERGE [DW].[AirlineAndAirport_Factless] AS Target
		USING (

			SELECT DISTINCT
				AirlineID,
				AirportID
			FROM (

				SELECT
					ac.AirlineID,
					fd.DepartureAirportID AS AirportID
				FROM
					[SA].[FlightDetail] fd
				INNER JOIN
					[SA].[Aircraft] ac ON fd.AircraftID = ac.AircraftID

				UNION

				SELECT
					ac.AirlineID,
					fd.DestinationAirportID AS AirportID
				FROM
					[SA].[FlightDetail] fd
				INNER JOIN
					[SA].[Aircraft] ac ON fd.AircraftID = ac.AircraftID
			) AllRelations
		) AS Source
		ON (Target.AirlineID = Source.AirlineID AND Target.AirportID = Source.AirportID)

		WHEN NOT MATCHED BY TARGET THEN
			INSERT (
				AirlineID,
				AirportID
			)
			VALUES (
				Source.AirlineID,
				Source.AirportID
			)
        WHEN NOT MATCHED BY SOURCE THEN
            DELETE;

		SET @RowCount = @@ROWCOUNT;

		UPDATE DW.ETL_Log SET ChangeDescription = 'Incremental merge complete', RowsAffected = @RowCount, DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()), Status = 'Success' WHERE LogID = @LogID;

	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg NVARCHAR(MAX) = ERROR_MESSAGE();
		UPDATE DW.ETL_Log SET ChangeDescription = 'Incremental merge failed', DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()), Status = 'Error', Message = @ErrMsg WHERE LogID = @LogID;
		THROW;
	END CATCH

	RAISERROR('Incremental AirlineAndAirport_Factless loading process has completed.', 0, 1) WITH NOWAIT;
	SET NOCOUNT OFF;
END
GO