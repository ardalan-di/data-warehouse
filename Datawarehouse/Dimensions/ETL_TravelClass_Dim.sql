CREATE OR ALTER PROCEDURE [DW].[ETL_TravelClass_Dim]
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE
    @StartTime     DATETIME2(3) = SYSUTCDATETIME(),
    @LastRunTime   DATETIME2(3),
    @RowsUpdated   INT = 0,
    @RowsInserted  INT = 0,
    @LogID         BIGINT;

  INSERT INTO DW.ETL_Log (
    ProcedureName, TargetTable, ChangeDescription, ActionTime, Status
  ) VALUES (
    'ETL_TravelClass_Dim',
    'DimTravelClass',
    'Procedure started - awaiting completion',
    @StartTime,
    'Fatal'
  );
  SET @LogID = SCOPE_IDENTITY();

  BEGIN TRY
    SELECT
      @LastRunTime = COALESCE(MAX(ActionTime), '1900-01-01')
    FROM DW.ETL_Log
    WHERE ProcedureName = 'ETL_TravelClass_Dim'
      AND Status = 'Success';

    TRUNCATE TABLE DW.Temp_TravelClass_Dim;

    INSERT INTO DW.Temp_TravelClass_Dim (
      TravelClassID,
      ClassName,
      Capacity
    )
    SELECT
      tc.TravelClassID,
      tc.ClassName,
      tc.Capacity
    FROM SA.TravelClass AS tc
    WHERE tc.StagingLastUpdateTimestampUTC > @LastRunTime;

    UPDATE d
    SET
      d.ClassName = t.ClassName,
      d.Capacity  = t.Capacity
    FROM DW.DimTravelClass AS d
    JOIN DW.Temp_TravelClass_Dim AS t
      ON d.TravelClassKey = t.TravelClassID
    WHERE
      (
        ISNULL(d.ClassName, '') <> ISNULL(t.ClassName, '')
        OR ISNULL(d.Capacity, -1) <> ISNULL(t.Capacity, -1)
      );
    SET @RowsUpdated = @@ROWCOUNT;

    INSERT INTO DW.DimTravelClass (
      TravelClassKey,
      ClassName,
      Capacity
    )
    SELECT
      t.TravelClassID,
      t.ClassName,
      t.Capacity
    FROM DW.Temp_TravelClass_Dim AS t
    WHERE NOT EXISTS (
      SELECT 1 FROM DW.DimTravelClass AS d
      WHERE d.TravelClassKey = t.TravelClassID
    );
    SET @RowsInserted = @@ROWCOUNT;

    UPDATE DW.ETL_Log
    SET
      ChangeDescription = CONCAT(
        'Incremental load complete: updated=', @RowsUpdated,
        ', inserted=', @RowsInserted
      ),
      RowsAffected      = @RowsUpdated + @RowsInserted,
      DurationSec       = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()),
      Status            = 'Success'
    WHERE LogID = @LogID;

  END TRY
  BEGIN CATCH
    DECLARE @ErrMsg NVARCHAR(MAX) = ERROR_MESSAGE();
    UPDATE DW.ETL_Log
    SET
      ChangeDescription = 'Incremental load failed',
      DurationSec       = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()),
      Status            = 'Error',
      Message           = @ErrMsg
    WHERE LogID = @LogID;
    THROW;
  END CATCH
END
GO