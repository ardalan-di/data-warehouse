CREATE TABLE [DW].[MaintenanceEvent_TransactionalFact] (

    [AircraftID]                INT NOT NULL,
    [MaintenanceTypeID]         integer NOT NULL,
    [LocationKey]    INT NOT NULL,
    [TechnicianID]              integer NOT NULL,
    [MaintenanceDateKey]        datetime NOT NULL,


    [DowntimeHours]             FLOAT NULL,
    [LaborHours]                FLOAT NULL,
    [LaborCost]                 DECIMAL(18,2) NULL,
    [TotalPartsCost]            DECIMAL(18,2) NULL,
    [TotalMaintenanceCost]      DECIMAL(18,2) NULL,
    [DistinctIssuesSolved]      INT NULL
);
GO
