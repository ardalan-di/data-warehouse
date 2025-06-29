CREATE TABLE [DW].[PassengerActivity_ACCFact] (
    [PersonKey]              INT PRIMARY KEY,
    [TotalTicketValue]       INT NULL,
    [TotalAmountPaid]        DECIMAL(18, 2) NULL,
    [TotalMilesFlown]        DECIMAL(18, 2) NULL,
    [TotalDiscountAmount]    DECIMAL(18, 2) NULL,
    [AverageTicketPrice]     DECIMAL(18, 2) NULL,
    [TotalDistinctAirlinesUsed]   INT NULL,
    [TotalDistinctRoutesFlown]    INT NULL,
    [TotalFlights]           INT NULL,
    [MaxFlightDistance]      DECIMAL(18, 2) NULL,
    [MinFlightDistance]      DECIMAL(18, 2) NULL
);
GO
