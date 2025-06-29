CREATE OR ALTER PROCEDURE [DW].[Initial_MaintenanceEvent_TransactionalFact]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentDate DATE;


    DECLARE date_cursor CURSOR FOR
        SELECT DISTINCT MaintenanceDate FROM [SA].[MaintenanceEvent] ORDER BY MaintenanceDate;

    OPEN date_cursor;
    FETCH NEXT FROM date_cursor INTO @CurrentDate;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @LogID BIGINT;
        DECLARE @StartTime DATETIME2(3) = SYSUTCDATETIME();
        DECLARE @RowCount INT;

        INSERT INTO DW.ETL_Log (
            ProcedureName, TargetTable, ChangeDescription, ActionTime, Status
        ) VALUES (
            'Initial_MaintenanceEvent_TransactionalFact',
            'MaintenanceEvent_TransactionalFact',
            'Procedure started for date: ' + CONVERT(varchar, @CurrentDate, 101),
            @StartTime,
            'Running'
        );
        SET @LogID = SCOPE_IDENTITY();

        BEGIN TRY
            TRUNCATE TABLE DW.Temp_MaintenanceEvent_Batch;

            INSERT INTO DW.Temp_MaintenanceEvent_Batch (
                MaintenanceEventID, AircraftID, MaintenanceTypeID, LocationID, TechnicianID, MaintenanceDate,
                DowntimeHours, LaborHours, LaborCost, TotalPartsCost, TotalMaintenanceCost, DistinctIssuesSolved
            )
            SELECT
                MaintenanceEventID, AircraftID, MaintenanceTypeID, LocationID, TechnicianID, MaintenanceDate,
                DowntimeHours, LaborHours, LaborCost, TotalPartsCost, TotalMaintenanceCost, DistinctIssuesSolved
            FROM [SA].[MaintenanceEvent]
            WHERE MaintenanceDate = @CurrentDate;

            IF @@ROWCOUNT = 0
            BEGIN

                UPDATE DW.ETL_Log
                SET ChangeDescription = 'No maintenance events found for date: ' + CONVERT(varchar, @CurrentDate, 101),
                    RowsAffected = 0,
                    DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()),
                    Status = 'Success'
                WHERE LogID = @LogID;

                FETCH NEXT FROM date_cursor INTO @CurrentDate;
                CONTINUE;
            END

            INSERT INTO [DW].[MaintenanceEvent_TransactionalFact] (
                AircraftID,
                MaintenanceTypeID,
                LocationKey,
                TechnicianID,
                MaintenanceDateKey,
                DowntimeHours,
                LaborHours,
                LaborCost,
                TotalPartsCost,
                TotalMaintenanceCost,
                DistinctIssuesSolved
            )
            SELECT
                t.AircraftID,
                t.MaintenanceTypeID,
                dl.LocationKey,
                t.TechnicianID,
                dt.DateTimeKey,
                t.DowntimeHours,
                t.LaborHours,
                t.LaborCost,
                t.TotalPartsCost,
                t.TotalMaintenanceCost,
                t.DistinctIssuesSolved
            FROM [DW].[Temp_MaintenanceEvent_Batch] t
            INNER JOIN [DW].[DimMaintenanceLocation] dl
                ON dl.LocationID = t.LocationID
                AND t.MaintenanceDate >= dl.EffectiveFrom
                AND (t.MaintenanceDate < dl.EffectiveTo OR dl.EffectiveTo IS NULL)
            INNER JOIN [DW].[DimDateTime] dt
                ON CAST(dt.DateTimeKey AS DATE) = t.MaintenanceDate;

            SET @RowCount = @@ROWCOUNT;

            TRUNCATE TABLE DW.Temp_MaintenanceEvent_Batch;

            UPDATE DW.ETL_Log
            SET ChangeDescription = 'Load complete for date: ' + CONVERT(varchar, @CurrentDate, 101),
                RowsAffected = @RowCount,
                DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()),
                Status = 'Success'
            WHERE LogID = @LogID;

        END TRY
        BEGIN CATCH
            DECLARE @ErrMsg NVARCHAR(MAX) = ERROR_MESSAGE();
            UPDATE DW.ETL_Log
            SET ChangeDescription = 'Load failed for date: ' + CONVERT(varchar, @CurrentDate, 101),
                DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()),
                Status = 'Error',
                Message = @ErrMsg
            WHERE LogID = @LogID;
            THROW;
        END CATCH

        FETCH NEXT FROM date_cursor INTO @CurrentDate;
    END

    CLOSE date_cursor;
    DEALLOCATE date_cursor;

    RAISERROR('Initial MaintenanceEvent_TransactionalFact loading process has completed.', 0, 1) WITH NOWAIT;
    SET NOCOUNT OFF;
END
GO
