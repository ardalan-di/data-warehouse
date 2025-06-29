CREATE OR ALTER PROCEDURE [DW].[Initial_CrewAssignmentEvent_Factless]
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @LogID BIGINT;
	DECLARE @StartTime DATETIME2(3) = SYSUTCDATETIME();
	DECLARE @RowCount INT;

	INSERT INTO DW.ETL_Log (ProcedureName, TargetTable, ChangeDescription, ActionTime, Status)
	VALUES ('Initial_CrewAssignmentEvent_Factless', 'CrewAssignmentEvent_Factless', 'Procedure started for initial full load', @StartTime, 'Running');

	SET @LogID = SCOPE_IDENTITY();

	BEGIN TRY
		INSERT INTO [DW].[CrewAssignmentEvent_Factless] (
			FlightID,
			SourceAirportID,
			DestinationAirportID,
			AircraftID,
			AirlineID,
			CrewID
		)
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
			[SA].[Aircraft] ac ON fd.AircraftID = ac.AircraftID;


		SET @RowCount = @@ROWCOUNT;

		UPDATE DW.ETL_Log SET ChangeDescription = 'Initial full load complete', RowsAffected = @RowCount, DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()), Status = 'Success' WHERE LogID = @LogID;

	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg NVARCHAR(MAX) = ERROR_MESSAGE();
		UPDATE DW.ETL_Log SET ChangeDescription = 'Initial full load failed', DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()), Status = 'Error', Message = @ErrMsg WHERE LogID = @LogID;
		THROW;
	END CATCH

	RAISERROR('Initial CrewAssignmentEvent_Factless loading process has completed.', 0, 1) WITH NOWAIT;
	SET NOCOUNT OFF;
END
GO
