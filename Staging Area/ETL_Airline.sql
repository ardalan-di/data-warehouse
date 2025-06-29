CREATE OR ALTER PROCEDURE [SA].[ETL_Airline]
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
        'ETL_Airline',
        'Source.Airline',
        'SA.Airline',
        'Procedure started - awaiting completion',
        @StartTime,
        'Fatal'
    );
    SET @LogID = SCOPE_IDENTITY();

    BEGIN TRY
        MERGE [SA].[Airline] AS TARGET
        USING [Source].[Airline] AS SOURCE
          ON TARGET.AirlineID = SOURCE.AirlineID

        WHEN MATCHED AND EXISTS (
            SELECT
                SOURCE.Name,
                SOURCE.Country,
                SOURCE.FoundedDate,
                SOURCE.HeadquartersNumber,
                SOURCE.FleetSize,
                SOURCE.Website,
                SOURCE.Current_IATA_Code
            EXCEPT
            SELECT
                TARGET.Name,
                TARGET.Country,
                TARGET.FoundedDate,
                TARGET.HeadquartersNumber,
                TARGET.FleetSize,
                TARGET.Website,
                TARGET.Current_IATA_Code
        ) THEN
            UPDATE SET
                TARGET.Name                       = NULLIF(TRIM(SOURCE.Name), ''),
                TARGET.Country                    = NULLIF(TRIM(SOURCE.Country), ''),
                TARGET.FoundedDate                = SOURCE.FoundedDate,
                TARGET.HeadquartersNumber         = NULLIF(TRIM(SOURCE.HeadquartersNumber), ''),
                TARGET.FleetSize                  = SOURCE.FleetSize,
                TARGET.Website                    = NULLIF(TRIM(SOURCE.Website), ''),
                TARGET.Current_IATA_Code          = SOURCE.Current_IATA_Code,
                TARGET.StagingLastUpdateTimestampUTC = GETUTCDATE()

        WHEN NOT MATCHED BY TARGET THEN
            INSERT (
                AirlineID,
                Name,
                Country,
                FoundedDate,
                HeadquartersNumber,
                FleetSize,
                Website,
                Current_IATA_Code,
                StagingLoadTimestampUTC,
                SourceSystem
            ) VALUES (
                SOURCE.AirlineID,
                NULLIF(TRIM(SOURCE.Name), ''),
                NULLIF(TRIM(SOURCE.Country), ''),
                SOURCE.FoundedDate,
                NULLIF(TRIM(SOURCE.HeadquartersNumber), ''),
                SOURCE.FleetSize,
                NULLIF(TRIM(SOURCE.Website), ''),
                SOURCE.Current_IATA_Code,
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
