CREATE OR ALTER PROCEDURE [DW].[Initial_Flight_Dim]
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
    'Initial_Flight_Dim',
    'DimFlight',
    'Procedure started - awaiting completion',
    @StartTime,
    'Fatal'
  );
  SET @LogID = SCOPE_IDENTITY();

  BEGIN TRY
    TRUNCATE TABLE DW.DimFlight;

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
      f.FlightDetailID,
      dep.City + ' Airport' AS DepartureAirportName,
      dest.City + ' Airport' AS DestinationAirportName,
      f.DepartureDateTime,
      f.ArrivalDateTime,
      DATEDIFF(MINUTE, f.DepartureDateTime, f.ArrivalDateTime) AS FlightDurationMinutes,
      a.Model AS AircraftName,
      f.FlightCapacity,
      f.TotalCost
    FROM SA.FlightDetail AS f
    LEFT JOIN SA.Airport AS dep  ON f.DepartureAirportID = dep.AirportID
    LEFT JOIN SA.Airport AS dest ON f.DestinationAirportID = dest.AirportID
    LEFT JOIN SA.Aircraft AS a   ON f.AircraftID = a.AircraftID;

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
