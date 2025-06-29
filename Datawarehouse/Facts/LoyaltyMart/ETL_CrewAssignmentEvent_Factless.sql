CREATE OR ALTER PROCEDURE [DW].[Load_CrewAssignmentEvent_Factless]
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @LogID BIGINT;
	DECLARE @StartTime DATETIME2(3) = SYSUTCDATETIME();
	DECLARE @RowCount INT;

	INSERT INTO DW.ETL_Log (ProcedureName, TargetTable, ChangeDescription, ActionTime, Status)
	VALUES ('Load_CrewAssignmentEvent_Factless', 'CrewAssignmentEvent_Factless', 'Procedure started for incremental merge', @StartTime, 'Running');

	SET @LogID = SCOPE_IDENTITY();

	BEGIN TRY

		MERGE [DW].[CrewAssignmentEvent_Factless] AS Target
		USING (
			SELECT
				ca.FlightDetailID,
				fd.DepartureAirportID,
				fd.DestinationAirportID,
				ac.AircraftID,
				ac.AirlineID,
				ca.CrewMemberID
			FROM
				[SA].[CrewAssignment] ca
			INNER JOIN
				[SA].[FlightDetail] fd ON ca.FlightDetailID = fd.FlightDetailID
			INNER JOIN
				[SA].[Aircraft] ac ON fd.AircraftID = ac.AircraftID
		) AS Source
		ON (Target.FlightID = Source.FlightDetailID AND Target.CrewID = Source.CrewMemberID)

		WHEN NOT MATCHED BY TARGET THEN
			INSERT (
				FlightID,
				SourceAirportID,
				DestinationAirportID,
				AircraftID,
				AirlineID,
				CrewID
			)
			VALUES (
				Source.FlightDetailID,
				Source.DepartureAirportID,
				Source.DestinationAirportID,
				Source.AircraftID,
				Source.AirlineID,
				Source.CrewMemberID
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

	RAISERROR('Incremental CrewAssignmentEvent_Factless loading process has completed.', 0, 1) WITH NOWAIT;
	SET NOCOUNT OFF;
END
GO