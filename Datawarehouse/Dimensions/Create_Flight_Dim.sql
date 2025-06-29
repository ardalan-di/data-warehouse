CREATE TABLE [DW].[DimFlight] (
  [FlightDetailID]      INT PRIMARY KEY,
  [DepartureAirportName] NVARCHAR(100),
  [DestinationAirportName] NVARCHAR(100),
  [DepartureDateTime]   DATETIME,
  [ArrivalDateTime]     DATETIME,
  [FlightDurationMinutes] INT,
  [AircraftName]        NVARCHAR(100),
  [FlightCapacity]      INT,
  [TotalCost]           DECIMAL(18,2)
);
GO

CREATE NONCLUSTERED INDEX IX_DimFlight_Route
ON [DW].[DimFlight] (DepartureAirportName, DestinationAirportName);
GO

CREATE NONCLUSTERED INDEX IX_DimFlight_AircraftName
ON [DW].[DimFlight] (AircraftName);
GO

CREATE NONCLUSTERED INDEX IX_DimFlight_DepartureDateTime
ON [DW].[DimFlight] (DepartureDateTime);
GO