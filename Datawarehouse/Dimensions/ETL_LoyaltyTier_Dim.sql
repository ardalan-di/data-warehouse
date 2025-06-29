CREATE OR ALTER PROCEDURE [DW].[ETL_LoyaltyTier_Dim]
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE
    @StartTime    DATETIME2(3) = SYSUTCDATETIME(),
    @LastRunTime  DATETIME2(3),
    @RowsExpired  INT,
    @RowsInserted INT,
    @LogID        BIGINT;

  INSERT INTO DW.ETL_Log (
    ProcedureName, TargetTable, ChangeDescription, ActionTime, Status
  ) VALUES (
    'ETL_LoyaltyTier_Dim',
    'DimLoyaltyTier',
    'Procedure started - awaiting completion',
    @StartTime,
    'Fatal'
  );
  SET @LogID = SCOPE_IDENTITY();

  BEGIN TRY
    SELECT
      @LastRunTime = COALESCE(
        MAX(ActionTime),
        '1900-01-01'
      )
    FROM DW.ETL_Log
    WHERE ProcedureName = 'ETL_LoyaltyTier_Dim'
      AND Status = 'Success';

    TRUNCATE TABLE [DW].[Temp_LoyaltyTier_table];

    INSERT INTO [DW].[Temp_LoyaltyTier_table] (
      LoyaltyTierID,
      Name,
      MinPoints,
      Benefits
    )
    SELECT
      lt.LoyaltyTierID,
      lt.Name,
      lt.MinPoints,
      lt.Benefits
    FROM SA.LoyaltyTier AS lt
    WHERE lt.StagingLastUpdateTimestampUTC > @LastRunTime;

    UPDATE d
    SET
      d.EffectiveTo         = @StartTime,
      d.MinPointsIsCurrent  = 0
    FROM DW.DimLoyaltyTier AS d
    JOIN DW.Temp_LoyaltyTier_table AS t
      ON d.LoyaltyTierID = t.LoyaltyTierID
    WHERE d.MinPointsIsCurrent = 1
      AND ISNULL(d.MinPoints,0) <> ISNULL(t.MinPoints,0);
    SET @RowsExpired = @@ROWCOUNT;

    INSERT INTO DW.DimLoyaltyTier (
      LoyaltyTierID,
      Name,
      MinPoints,
      Benefits,
      EffectiveFrom,
      EffectiveTo,
      MinPointsIsCurrent
    )
    SELECT
      t.LoyaltyTierID,
      t.Name,
      t.MinPoints,
      t.Benefits,
      @StartTime,
      NULL,
      1
    FROM DW.Temp_LoyaltyTier_table AS t;
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