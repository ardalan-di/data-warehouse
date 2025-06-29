CREATE OR ALTER PROCEDURE [DW].[Initial_Payment_Dim]
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE
    @StartTime    DATETIME2(3) = SYSUTCDATETIME(),
    @RowsInserted INT,
    @LogID        BIGINT;

  INSERT INTO DW.ETL_Log (
    ProcedureName, TargetTable, ChangeDescription, ActionTime, Status
  ) VALUES (
    'Initial_Payment_Dim',
    'DimPayment',
    'Procedure started - awaiting completion',
    @StartTime,
    'Fatal'
  );
  SET @LogID = SCOPE_IDENTITY();

  BEGIN TRY
    INSERT INTO DW.DimPayment (
      PaymentKey, PaymentMethod, PaymentStatus, PaymentTimestamp
    )
    SELECT
      p.PaymentID,
      p.Method         AS PaymentMethod,
      p.Status         AS PaymentStatus,
      p.PaymentDateTime AS PaymentTimestamp
    FROM SA.Payment AS p
    WHERE NOT EXISTS (
      SELECT 1 FROM DW.DimPayment AS d
      WHERE d.PaymentKey = p.PaymentID
    );
    SET @RowsInserted = @@ROWCOUNT;

    UPDATE DW.ETL_Log
    SET
      ChangeDescription = 'Initial full load complete',
      RowsAffected      = @RowsInserted,
      DurationSec       = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()),
      Status            = 'Success'
    WHERE LogID = @LogID;

  END TRY
  BEGIN CATCH
    DECLARE @ErrMsg NVARCHAR(MAX) = ERROR_MESSAGE();
    UPDATE DW.ETL_Log
    SET
      ChangeDescription = 'Initial full load failed',
      DurationSec       = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()),
      Status            = 'Error',
      Message           = @ErrMsg
    WHERE LogID = @LogID;
    THROW;
  END CATCH
END;
GO