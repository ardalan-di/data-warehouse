
IF OBJECT_ID('[DW].[Temp_Airport_table]', 'U') IS NULL
BEGIN
  CREATE TABLE [DW].[Temp_Airport_table] (
    [AirportID] INT PRIMARY KEY,
    [City] NVARCHAR(50),
    [Country] NVARCHAR(50),
    [IATACode] NVARCHAR(3),
    [ElevationMeter] INT,
    [TimeZone] NVARCHAR(50),
    [NumberOfTerminals] INT,
    [AnnualPassengerTraffic] BIGINT,
    [Latitude] DECIMAL(9,6),
    [Longitude] DECIMAL(9,6)
  );
END;
GO

CREATE OR ALTER PROCEDURE [DW].[ETL_Airport_Dim]
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE
    @StartTime     DATETIME2(3) = SYSUTCDATETIME(),
    @LastRunTime   DATETIME2(3),
    @RowsUpdated   INT = 0,
    @RowsInserted  INT = 0,
    @LogID         BIGINT;

  INSERT INTO DW.ETL_Log (
    ProcedureName, TargetTable, ChangeDescription, ActionTime, Status
  ) VALUES (
    'ETL_Airport_Dim',
    'DimAirport',
    'Procedure started - awaiting completion',
    @StartTime,
    'Fatal'
  );
  SET @LogID = SCOPE_IDENTITY();

  BEGIN TRY
    SELECT @LastRunTime = COALESCE(MAX(ActionTime), '1900-01-01')
    FROM DW.ETL_Log
    WHERE ProcedureName = 'ETL_Airport_Dim'
      AND Status = 'Success';

    TRUNCATE TABLE DW.Temp_Airport_table;

    INSERT INTO DW.Temp_Airport_table (
      AirportID,
      City,
      Country,
      IATACode,
      ElevationMeter,
      TimeZone,
      NumberOfTerminals,
      AnnualPassengerTraffic,
      Latitude,
      Longitude
    )
    SELECT
      a.AirportID,
      a.City,
      a.Country,
      a.IATACode,
      a.ElevationMeter,
      a.TimeZone,
      a.NumberOfTerminals,
      a.AnnualPassengerTraffic,
      a.Latitude,
      a.Longitude
    FROM SA.Airport AS a
    WHERE a.StagingLastUpdateTimestampUTC > @LastRunTime;

    UPDATE d
    SET
      d.City = t.City,
      d.Country = t.Country,
      d.IATACode = t.IATACode,
      d.ElevationMeter = t.ElevationMeter,
      d.TimeZone = t.TimeZone,
      d.NumberOfTerminals = t.NumberOfTerminals,
      d.AnnualPassengerTraffic = t.AnnualPassengerTraffic,
      d.Latitude = t.Latitude,
      d.Longitude = t.Longitude
    FROM DW.DimAirport AS d
    INNER JOIN DW.Temp_Airport_table AS t
      ON d.AirportID = t.AirportID
    WHERE
      (
        ISNULL(d.City, '')                  <> ISNULL(t.City, '') OR
        ISNULL(d.Country, '')               <> ISNULL(t.Country, '') OR
        ISNULL(d.IATACode, '')              <> ISNULL(t.IATACode, '') OR
        ISNULL(d.ElevationMeter, 0)         <> ISNULL(t.ElevationMeter, 0) OR
        ISNULL(d.TimeZone, '')              <> ISNULL(t.TimeZone, '') OR
        ISNULL(d.NumberOfTerminals, 0)      <> ISNULL(t.NumberOfTerminals, 0) OR
        ISNULL(d.AnnualPassengerTraffic, 0) <> ISNULL(t.AnnualPassengerTraffic, 0) OR
        ISNULL(d.Latitude, 0)               <> ISNULL(t.Latitude, 0) OR
        ISNULL(d.Longitude, 0)              <> ISNULL(t.Longitude, 0)
      );
    SET @RowsUpdated = @@ROWCOUNT;

    INSERT INTO DW.DimAirport (
      AirportID,
      City,
      Country,
      IATACode,
      ElevationMeter,
      TimeZone,
      NumberOfTerminals,
      AnnualPassengerTraffic,
      Latitude,
      Longitude
    )
    SELECT
      t.AirportID,
      t.City,
      t.Country,
      t.IATACode,
      t.ElevationMeter,
      t.TimeZone,
      t.NumberOfTerminals,
      t.AnnualPassengerTraffic,
      t.Latitude,
      t.Longitude
    FROM DW.Temp_Airport_table AS t
    WHERE NOT EXISTS (
      SELECT 1 FROM DW.DimAirport AS d WHERE d.AirportID = t.AirportID
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
    UPDATE DW.ETL_Log
    SET
      ChangeDescription = 'Incremental load failed',
      DurationSec       = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()),
      Status            = 'Error',
      Message           = ERROR_MESSAGE()
    WHERE LogID = @LogID;
    THROW;
  END CATCH
END;
GO
