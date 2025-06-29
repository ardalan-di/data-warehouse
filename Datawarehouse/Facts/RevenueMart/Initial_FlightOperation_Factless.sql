CREATE OR ALTER PROCEDURE [DW].[Initial_FlightOperation_Factless]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @LogID BIGINT;
    DECLARE @StartTime DATETIME2(3) = SYSUTCDATETIME();
    DECLARE @RowCount INT;

    INSERT INTO DW.ETL_Log (ProcedureName, TargetTable, ChangeDescription, ActionTime, Status)
    VALUES ('Initial_FlightOperation_Factless', 'FlightOperation_Factless', 'Procedure started for initial full load', @StartTime, 'Running');

    SET @LogID = SCOPE_IDENTITY();

    BEGIN TRY
        INSERT INTO [DW].[FlightOperation_Factless] (
            FlightKey,
            SourceAirportKey,
            DestinationAirportKey,
            AirlineKey,
            AircraftKey,
            OperationTypeKey
        )
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
            [SA].[Aircraft] ac ON fd.AircraftID = ac.AircraftID;

        SET @RowCount = @@ROWCOUNT;

        UPDATE DW.ETL_Log SET ChangeDescription = 'Initial full load complete', RowsAffected = @RowCount, DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()), Status = 'Success' WHERE LogID = @LogID;

    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(MAX) = ERROR_MESSAGE();
        UPDATE DW.ETL_Log SET ChangeDescription = 'Initial full load failed', DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()), Status = 'Error', Message = @ErrMsg WHERE LogID = @LogID;
        THROW;
    END CATCH

    RAISERROR('Initial FlightOperation_Factless loading process has completed.', 0, 1) WITH NOWAIT;
    SET NOCOUNT OFF;
END
GO
