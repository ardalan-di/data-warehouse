CREATE OR ALTER PROCEDURE [DW].[ETL_PointConversionRate_Dim]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @StartTime     DATETIME2(3) = SYSUTCDATETIME(),
        @LastRunTime   DATETIME2(3),
        @RowsExpired   INT,
        @RowsInserted  INT,
        @LogID         BIGINT;

    INSERT INTO DW.ETL_Log (
        ProcedureName, TargetTable, ChangeDescription, ActionTime, Status
    ) VALUES (
        'ETL_PointConversionRate_Dim',
        'DimPointConversionRate',
        'Procedure started - awaiting completion',
        @StartTime,
        'Fatal'
    );
    SET @LogID = SCOPE_IDENTITY();

    BEGIN TRY
        SELECT
            @LastRunTime = COALESCE(MAX(ActionTime), '1900-01-01')
        FROM DW.ETL_Log
        WHERE ProcedureName = 'ETL_PointConversionRate_Dim'
          AND Status = 'Success';

        TRUNCATE TABLE [DW].[Temp_PointConversionRate_table];

        INSERT INTO [DW].[Temp_PointConversionRate_table] (
            PointConversionRateID, ConversionRate, Currency
        )
        SELECT
            sa.PointConversionRateID,
            sa.ConversionRate,
            sa.CurrencyCode
        FROM SA.PointConversionRate AS sa
        WHERE sa.StagingLastUpdateTimestampUTC > @LastRunTime;

        UPDATE d
        SET
            d.EffectiveTo = @StartTime,
            d.IsCurrent = 0
        FROM DW.DimPointConversionRate AS d
        JOIN DW.Temp_PointConversionRate_table AS t
            ON d.PointConversionRateID = t.PointConversionRateID
        WHERE d.IsCurrent = 1
          AND (
                ISNULL(d.Rate, 0) <> ISNULL(t.ConversionRate, 0)
                OR ISNULL(d.Currency, '') <> ISNULL(t.Currency, '')
              );

        SET @RowsExpired = @@ROWCOUNT;

        INSERT INTO DW.DimPointConversionRate (
            PointConversionRateID, Rate, Currency,
            EffectiveFrom, EffectiveTo, IsCurrent
        )
        SELECT
            t.PointConversionRateID,
            t.ConversionRate,
            t.Currency,
            @StartTime,
            NULL,
            1
        FROM DW.Temp_PointConversionRate_table AS t;

        SET @RowsInserted = @@ROWCOUNT;

        UPDATE DW.ETL_Log
        SET
            ChangeDescription = CONCAT(
                'Incremental SCD2 load complete: expired=', @RowsExpired,
                ', inserted=', @RowsInserted
            ),
            RowsAffected      = @RowsExpired + @RowsInserted,
            DurationSec       = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()),
            Status            = 'Success'
        WHERE LogID = @LogID;

    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(MAX) = ERROR_MESSAGE();
        UPDATE DW.ETL_Log
        SET
            ChangeDescription = 'Incremental SCD2 load failed',
            DurationSec       = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()),
            Status            = 'Error',
            Message           = @ErrMsg
        WHERE LogID = @LogID;
        THROW;
    END CATCH
END;
GO
