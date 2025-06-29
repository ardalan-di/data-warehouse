CREATE OR ALTER PROCEDURE [SA].[ETL_Part]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @StartTime    DATETIME2(3) = SYSUTCDATETIME(),
        @RowsAffected INT,
        @LogID        BIGINT;

    INSERT INTO [SA].[ETL_Log] (
        ProcedureName,
        SourceTable,
        TargetTable,
        ChangeDescription,
        ActionTime,
        Status
    ) VALUES (
        'ETL_Part',
        'Source.Part',
        'SA.Part',
        'Procedure started - awaiting completion',
        @StartTime,
        'Fatal'
    );
    SET @LogID = SCOPE_IDENTITY();

    BEGIN TRY
        MERGE [SA].[Part] AS TARGET
        USING [Source].[Part] AS SOURCE
          ON TARGET.PartID = SOURCE.PartID

        WHEN MATCHED AND EXISTS (
            SELECT
                SOURCE.Name,
                SOURCE.PartNumber,
                SOURCE.Manufacturer,
                SOURCE.WarrantyPeriodMonths,
                SOURCE.Category
            EXCEPT
            SELECT
                TARGET.Name,
                TARGET.PartNumber,
                TARGET.Manufacturer,
                TARGET.WarrantyPeriodMonths,
                TARGET.Category
        ) THEN
            UPDATE SET
                TARGET.Name                       = NULLIF(TRIM(SOURCE.Name), ''),
                TARGET.PartNumber                 = NULLIF(TRIM(SOURCE.PartNumber), ''),
                TARGET.Manufacturer               = NULLIF(TRIM(SOURCE.Manufacturer), ''),
                TARGET.WarrantyPeriodMonths       = SOURCE.WarrantyPeriodMonths,
                TARGET.Category                   = NULLIF(TRIM(SOURCE.Category), ''),
                TARGET.StagingLastUpdateTimestampUTC = GETUTCDATE(),
                TARGET.SourceSystem               = 'OperationalDB'

        WHEN NOT MATCHED BY TARGET THEN
            INSERT (
                PartID,
                Name,
                PartNumber,
                Manufacturer,
                WarrantyPeriodMonths,
                Category,
                StagingLoadTimestampUTC,
                SourceSystem
            ) VALUES (
                SOURCE.PartID,
                NULLIF(TRIM(SOURCE.Name), ''),
                NULLIF(TRIM(SOURCE.PartNumber), ''),
                NULLIF(TRIM(SOURCE.Manufacturer), ''),
                SOURCE.WarrantyPeriodMonths,
                NULLIF(TRIM(SOURCE.Category), ''),
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
