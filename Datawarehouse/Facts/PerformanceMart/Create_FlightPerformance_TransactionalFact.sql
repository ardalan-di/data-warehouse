CREATE TABLE [DW].[FlightPerformance_TransactionalFact] (
    [ScheduledDepartureId] DATETIME NULL,
    [ScheduledArrivalId]   DATETIME NULL,

    [ActualDepartureId]    DATETIME NULL,
    [ActualArrivalId]      DATETIME NULL,

    [DepartureAirportId]   INT NULL,
    [ArrivalAirportId]     INT NULL,

    [AircraftId]           INT NULL,
    [AirlineId]            INT NULL,

    [DepartureDelayMinutes] INT NULL,
    [ArrivalDelayMinutes]  INT NULL,

    [FlightDurationActual]   INT NULL,
    [FlightDurationScheduled] INT NULL,

    [LoadFactor]            FLOAT NULL,
    [DelaySeverityScore]    FLOAT NULL
);
GO

CREATE NONCLUSTERED INDEX IX_FlightPerformance_TransactionalFact_ScheduledDepartureId
ON [DW].[FlightPerformance_TransactionalFact] (ScheduledDepartureId);
GO

CREATE NONCLUSTERED INDEX IX_FlightPerformance_TransactionalFact_ScheduledArrivalId
ON [DW].[FlightPerformance_TransactionalFact] (ScheduledArrivalId);
GO

CREATE NONCLUSTERED INDEX IX_FlightPerformance_TransactionalFact_ActualDepartureId
ON [DW].[FlightPerformance_TransactionalFact] (ActualDepartureId);
GO

CREATE NONCLUSTERED INDEX IX_FlightPerformance_TransactionalFact_ActualArrivalId
ON [DW].[FlightPerformance_TransactionalFact] (ActualArrivalId);
GO

CREATE NONCLUSTERED INDEX IX_FlightPerformance_TransactionalFact_AirlineId
ON [DW].[FlightPerformance_TransactionalFact] (AirlineId);
GO

CREATE NONCLUSTERED INDEX IX_FlightPerformance_TransactionalFact_AircraftId
ON [DW].[FlightPerformance_TransactionalFact] (AircraftId);
GO

CREATE NONCLUSTERED INDEX IX_FlightPerformance_TransactionalFact_Route
ON [DW].[FlightPerformance_TransactionalFact] (DepartureAirportId, ArrivalAirportId);
GO

CREATE NONCLUSTERED INDEX IX_FlightPerformance_TransactionalFact_DepartureAirportId
ON [DW].[FlightPerformance_TransactionalFact] (DepartureAirportId);
GO
