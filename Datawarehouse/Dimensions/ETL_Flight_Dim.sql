CREATE OR ALTER PROCEDURE [DW].[ETL_Flight_Dim]
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
    'ETL_Flight_Dim',
    'DimFlight',
    'Procedure started - awaiting completion',
    @StartTime,
    'Fatal'
  );
  SET @LogID = SCOPE_IDENTITY();

  BEGIN TRY
    SELECT
      @LastRunTime = COALESCE(MAX(ActionTime), '1900-01-01')
    FROM DW.ETL_Log
    WHERE ProcedureName = 'ETL_Flight_Dim'
      AND Status = 'Success';

    TRUNCATE TABLE [DW].[Temp_Flight_table];

    INSERT INTO [DW].[Temp_Flight_table] (
      FlightDetailID,
      DepartureAirportName,
      DestinationAirportName,
      DepartureDateTime,
      ArrivalDateTime,
      FlightDurationMinutes,
      AircraftName,
      FlightCapacity,
      TotalCost
    )
    SELECT
      f.FlightDetailID,
      dep.City + ' Airport',
      dest.City + ' Airport',
      f.DepartureDateTime,
      f.ArrivalDateTime,
      DATEDIFF(MINUTE, f.DepartureDateTime, f.ArrivalDateTime),
      a.Model,
      f.FlightCapacity,
      f.TotalCost
    FROM SA.FlightDetail AS f
    LEFT JOIN SA.Airport AS dep  ON f.DepartureAirportID = dep.AirportID
    LEFT JOIN SA.Airport AS dest ON f.DestinationAirportID = dest.AirportID
    LEFT JOIN SA.Aircraft AS a   ON f.AircraftID = a.AircraftID
    WHERE f.StagingLastUpdateTimestampUTC > @LastRunTime;

    UPDATE d
    SET
      d.DepartureAirportName    = t.DepartureAirportName,
      d.DestinationAirportName  = t.DestinationAirportName,
      d.DepartureDateTime       = t.DepartureDateTime,
      d.ArrivalDateTime         = t.ArrivalDateTime,
      d.FlightDurationMinutes   = t.FlightDurationMinutes,
      d.AircraftName            = t.AircraftName,
      d.FlightCapacity          = t.FlightCapacity,
      d.TotalCost               = t.TotalCost
    FROM DW.DimFlight AS d
    JOIN DW.Temp_Flight_table AS t
      ON d.FlightDetailID = t.FlightDetailID
    WHERE
      (
        ISNULL(d.DepartureAirportName,'')    <> ISNULL(t.DepartureAirportName,'')
        OR ISNULL(d.DestinationAirportName,'')<> ISNULL(t.DestinationAirportName,'')
        OR ISNULL(d.DepartureDateTime,'')     <> ISNULL(t.DepartureDateTime,'')
        OR ISNULL(d.ArrivalDateTime,'')       <> ISNULL(t.ArrivalDateTime,'')
        OR ISNULL(d.FlightDurationMinutes,0)  <> ISNULL(t.FlightDurationMinutes,0)
        OR ISNULL(d.AircraftName,'')          <> ISNULL(t.AircraftName,'')
        OR ISNULL(d.FlightCapacity,0)         <> ISNULL(t.FlightCapacity,0)
        OR ISNULL(d.TotalCost,0)              <> ISNULL(t.TotalCost,0)
      );
    SET @RowsUpdated = @@ROWCOUNT;

    INSERT INTO DW.DimFlight (
      FlightDetailID,
      DepartureAirportName,
      DestinationAirportName,
      DepartureDateTime,
      ArrivalDateTime,
      FlightDurationMinutes,
      AircraftName,
      FlightCapacity,
      TotalCost
    )
    SELECT
      t.FlightDetailID,
      t.DepartureAirportName,
      t.DestinationAirportName,
      t.DepartureDateTime,
      t.ArrivalDateTime,
      t.FlightDurationMinutes,
      t.AircraftName,
      t.FlightCapacity,
      t.TotalCost
    FROM DW.Temp_Flight_table AS t
    WHERE NOT EXISTS (
      SELECT 1 FROM DW.DimFlight AS d
      WHERE d.FlightDetailID = t.FlightDetailID
    );
    SET @RowsInserted = @@ROWCOUNT;

    UPDATE DW.ETL_Log
    SET
      ChangeDescription = CONCAT(
        'Incremental load complete: updated=', @RowsUpdated,
        ', inserted=', @RowsInserted
      ),
      RowsAffected = @RowsUpdated + @RowsInserted,
      DurationSec  = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()),
      Status       = 'Success'
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
