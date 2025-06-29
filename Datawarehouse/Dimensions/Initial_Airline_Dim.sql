CREATE OR ALTER PROCEDURE [DW].[Initial_Airline_Dim]
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE
    @StartTime     DATETIME2(3) = SYSUTCDATETIME(),
    @RowsInserted  INT,
    @LogID         BIGINT;

  INSERT INTO DW.ETL_Log (
    ProcedureName, TargetTable, ChangeDescription, ActionTime, Status
  ) VALUES (
    'Initial_Airline_Dim',
    'DimAirline',
    'Procedure started - awaiting completion',
    @StartTime,
    'Fatal'
  );
  SET @LogID = SCOPE_IDENTITY();

  BEGIN TRY
    TRUNCATE TABLE DW.DimAirline;

    INSERT INTO DW.DimAirline (
      AirlineID,
      Name,
      Country,
      FoundedYear,
      FleetSize,
      Website,
      Current_IATA_Code,
      Previous_IATA_Code,
      IATA_Code_Changed_Date
    )
    SELECT
      a.AirlineID,
      a.Name,
      a.Country,
      YEAR(a.FoundedDate),
      a.FleetSize,
      a.Website,
      a.Current_IATA_Code,
      NULL,
      NULL
    FROM SA.Airline AS a;

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
      ChangeDescription = 'Initial load failed',
      DurationSec       = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()),
      Status            = 'Error',
      Message           = @ErrMsg
    WHERE LogID = @LogID;
    THROW;
  END CATCH
END
GO
