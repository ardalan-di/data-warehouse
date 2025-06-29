CREATE OR ALTER PROCEDURE [SA].[ETL_FlightOperation]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @StartTime     DATETIME2(3) = SYSUTCDATETIME(),
        @RowsAffected  INT,
        @LogID         BIGINT;


    INSERT INTO [SA].[ETL_Log] (
        ProcedureName,
        SourceTable,
        TargetTable,
        ChangeDescription,
        ActionTime,
        Status
    ) VALUES (
        'ETL_FlightOperation',
        'Source.FlightOperation',
        'SA.FlightOperation',
        'Procedure started - awaiting completion',
        @StartTime,
        'Fatal'
    );
    SET @LogID = SCOPE_IDENTITY();

    BEGIN TRY
        MERGE [SA].[FlightOperation] AS TARGET
        USING [Source].[FlightOperation] AS SOURCE
          ON TARGET.FlightOperationID = SOURCE.FlightOperationID

        WHEN MATCHED AND EXISTS (
            SELECT
                SOURCE.FlightDetailID,
                SOURCE.ActualDepartureDateTime,
                SOURCE.ActualArrivalDateTime,
                SOURCE.DelayMinutes,
                SOURCE.CancelFlag,
                SOURCE.LoadFactor,
                SOURCE.DelaySeverityScore
            EXCEPT
            SELECT
                TARGET.FlightDetailID,
                TARGET.ActualDepartureDateTime,
                TARGET.ActualArrivalDateTime,
                TARGET.DelayMinutes,
                TARGET.CancelFlag,
                TARGET.LoadFactor,
                TARGET.DelaySeverityScore
        ) THEN
            UPDATE SET
                TARGET.FlightDetailID                = SOURCE.FlightDetailID,
                TARGET.ActualDepartureDateTime       = SOURCE.ActualDepartureDateTime,
                TARGET.ActualArrivalDateTime         = SOURCE.ActualArrivalDateTime,
                TARGET.DelayMinutes                  = SOURCE.DelayMinutes,
                TARGET.CancelFlag                    = SOURCE.CancelFlag,
                TARGET.LoadFactor                    = SOURCE.LoadFactor,
                TARGET.DelaySeverityScore            = SOURCE.DelaySeverityScore,
                TARGET.StagingLastUpdateTimestampUTC = GETUTCDATE()

        WHEN NOT MATCHED BY TARGET THEN
            INSERT (
                FlightOperationID,
                FlightDetailID,
                ActualDepartureDateTime,
                ActualArrivalDateTime,
                DelayMinutes,
                CancelFlag,
                LoadFactor,
                DelaySeverityScore,
                StagingLoadTimestampUTC,
                SourceSystem
            ) VALUES (
                SOURCE.FlightOperationID,
                SOURCE.FlightDetailID,
                SOURCE.ActualDepartureDateTime,
                SOURCE.ActualArrivalDateTime,
                SOURCE.DelayMinutes,
                SOURCE.CancelFlag,
                SOURCE.LoadFactor,
                SOURCE.DelaySeverityScore,
                GETUTCDATE(),
                'OperationalDB'
            );

        SET @RowsAffected = @@ROWCOUNT;

        UPDATE [SA].[ETL_Log]
        SET
            ChangeDescription = CONCAT('Merge complete: rows affected=', @RowsAffected),
            RowsAffected      = @RowsAffected,
            DurationSec       = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()),
            Status            = 'Success'
        WHERE LogID = @LogID;

    END TRY
    BEGIN CATCH
        UPDATE [SA].[ETL_Log]
        SET
            ChangeDescription = 'Merge failed',
            DurationSec       = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()),
            Status            = 'Error',
            Message           = ERROR_MESSAGE()
        WHERE LogID = @LogID;
        THROW;
    END CATCH
END;
GO
