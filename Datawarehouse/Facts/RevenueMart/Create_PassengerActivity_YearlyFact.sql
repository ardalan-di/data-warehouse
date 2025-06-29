CREATE TABLE [DW].[PassengerActivity_YearlyFact] (
  [YearID] date,
  [PersonKey] int,
  [YearlyTicketValue] decimal(18,2),
  [YearlyMilesFlown] decimal(18,2),
  [YearlyDiscountAmount] decimal(18,2),
  [YearlyAverageTicketPrice] decimal(18,2),
  [YearlyDistinctAirlinesUsed] int,
  [YearlyDistinctRoutesFlown] int,
  [YearlyFlights] decimal(18,2),
  [YearlyMaxFlightDistance] decimal(18,2),
  [YearlyMinFlightDistance] decimal(18,2)
)
GO

CREATE NONCLUSTERED INDEX IX_PassengerActivity_YearlyFact_PersonKey
ON [DW].[PassengerActivity_YearlyFact] (PersonKey);
GO

CREATE NONCLUSTERED INDEX IX_PassengerActivity_YearlyFact_YearID
ON [DW].[PassengerActivity_YearlyFact] (YearID);
GO