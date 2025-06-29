CREATE TABLE [DW].[FlightDelay_ACCFact] (
    [AirlineID]              INT    NOT NULL,
    [DepartureAirportID]     INT    NOT NULL,
    [ArrivalAirportID]       INT    NOT NULL,

    [TotalFlightsNumber]            INT    NULL,
    [TotalDelayedFlightsNumber]          INT    NULL,
    [TotalCancelledFlightsNumber]        INT    NULL,

    [TotalAvgDepartureDelayMinutes] FLOAT  NULL,
    [TotalAvgArrivalDelayMinutes]   FLOAT  NULL,
    [TotalMaxDelayMinutes]         INT    NULL,

    [TotalDelayRate]               FLOAT  NULL,
    [TotalOnTimePercentage]        FLOAT  NULL
);
GO

CREATE NONCLUSTERED INDEX IX_FlightDelay_ACCFact_AirlineID
ON [DW].[FlightDelay_ACCFact] (AirlineID);
GO

CREATE NONCLUSTERED INDEX IX_FlightDelay_ACCFact_DepartureAirportID
ON [DW].[FlightDelay_ACCFact] (DepartureAirportID);
GO

CREATE NONCLUSTERED INDEX IX_FlightDelay_ACCFact_ArrivalAirportID
ON [DW].[FlightDelay_ACCFact] (ArrivalAirportID);
GO