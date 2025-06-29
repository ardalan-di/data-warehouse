
CREATE OR ALTER PROCEDURE [DW].[ETL_AirlineAirportService_Dim]
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE
    @StartTime       DATETIME2(3) = SYSUTCDATETIME(),
    @LastRunTime     DATETIME2(3),
    @RowsInserted    INT,
    @RowsUpdated     INT,
    @LogID           BIGINT;

  INSERT INTO [DW].[ETL_Log] (ProcedureName, TargetTable, Status)
  VALUES ('ETL_AirlineAirportService_Dim','DimAirlineAirportService','Started');
  SET @LogID = SCOPE_IDENTITY();

  BEGIN TRY
    SELECT @LastRunTime = COALESCE(MAX(ActionTime),'1900-01-01')
    FROM [DW].[ETL_Log]
    WHERE ProcedureName = 'ETL_AirlineAirportService_Dim' AND Status = 'Success';

    TRUNCATE TABLE [DW].[Temp_AirlineAirportService_table];

    INSERT INTO [DW].[Temp_AirlineAirportService_table] (
      ServiceTypeCode,
      FlightTypeCode,
      ServiceTypeName,
      FlightTypeName,
      ContractStartDate,
      ContractEndDate,
      LandingFeeRate,
      PassengerServiceRate
    )
    SELECT
      s.ServiceTypeCode,
      s.FlightTypeCode,
      s.ServiceTypeName,
      s.FlightTypeName,
      s.ContractStartDate,
      s.ContractEndDate,
      s.LandingFeeRate,
      s.PassengerServiceRate
    FROM [SA].[AirlineAirportService] AS s
    WHERE s.StagingLastUpdateTimestampUTC > @LastRunTime;
    SET @RowsInserted = @@ROWCOUNT;

    UPDATE d
    SET
      d.ServiceTypeName       = t.ServiceTypeName,
      d.FlightTypeName        = t.FlightTypeName,
      d.ContractStartDate     = t.ContractStartDate,
      d.ContractEndDate       = t.ContractEndDate,
      d.LandingFeeRate        = t.LandingFeeRate,
      d.PassengerServiceRate  = t.PassengerServiceRate
    FROM [DW].[DimAirlineAirportService] AS d
    JOIN [DW].[Temp_AirlineAirportService_table] AS t
      ON d.ServiceTypeCode = t.ServiceTypeCode
     AND d.FlightTypeCode = t.FlightTypeCode
    WHERE EXISTS (
      SELECT
        t.ServiceTypeName,
        t.FlightTypeName,
        t.ContractStartDate,
        t.ContractEndDate,
        t.LandingFeeRate,
        t.PassengerServiceRate
      EXCEPT
      SELECT
        d.ServiceTypeName,
        d.FlightTypeName,
        d.ContractStartDate,
        d.ContractEndDate,
        d.LandingFeeRate,
        d.PassengerServiceRate
    );
    SET @RowsUpdated = @@ROWCOUNT;

    UPDATE [DW].[ETL_Log]
    SET ChangeDescription = CONCAT('Inc load complete: inserted=',@RowsInserted,', updated=',@RowsUpdated),
        RowsAffected      = @RowsInserted + @RowsUpdated,
        DurationSec       = DATEDIFF(SECOND,@StartTime,SYSUTCDATETIME()),
        Status            = 'Success'
    WHERE LogID = @LogID;

  END TRY
  BEGIN CATCH
    UPDATE [DW].[ETL_Log]
    SET ChangeDescription = 'Inc load failed',
        DurationSec       = DATEDIFF(SECOND,@StartTime,SYSUTCDATETIME()),
        Status            = 'Error',
        Message           = ERROR_MESSAGE()
    WHERE LogID = @LogID;
    THROW;
  END CATCH
END;
GO