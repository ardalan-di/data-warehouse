CREATE TABLE [DW].[FlightDelay_DailyFact] (
    [DateID]         DATE    NOT NULL,
    [AirlineID]              INT    NOT NULL,
    [DepartureAirportID]     INT    NOT NULL,
    [ArrivalAirportID]       INT    NOT NULL,

    [DailyFlightsNumber]            INT    NULL,
    [DailyDelayedFlightsNumber]          INT    NULL,
    [DailyCancelledFlightsNumber]        INT    NULL,

    [DailyAvgDepartureDelayMinutes] FLOAT  NULL,
    [DailyAvgArrivalDelayMinutes]   FLOAT  NULL,
    [DailyMaxDelayMinutes]         INT    NULL,

    [DailyDelayRate]               FLOAT  NULL,
    [DailyOnTimePercentage]        FLOAT  NULL
);
GO

CREATE NONCLUSTERED INDEX IX_FlightDelay_DailyFact_DateID
ON [DW].[FlightDelay_DailyFact] (DateID);
GO

CREATE NONCLUSTERED INDEX IX_FlightDelay_DailyFact_AirlineID
ON [DW].[FlightDelay_DailyFact] (AirlineID);
GO

CREATE NONCLUSTERED INDEX IX_FlightDelay_DailyFact_DepartureAirportID
ON [DW].[FlightDelay_DailyFact] (DepartureAirportID);
GO

CREATE NONCLUSTERED INDEX IX_FlightDelay_DailyFact_ArrivalAirportID
ON [DW].[FlightDelay_DailyFact] (ArrivalAirportID);
GO