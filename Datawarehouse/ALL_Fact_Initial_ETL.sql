EXEC [DW].[Initial_FlightOperation_Factless];
GO
EXEC [DW].[Initial_PassengerActivity_ACCFact];
GO
EXEC [DW].[Initial_PassengerTicket_TransactionalFact];
GO
EXEC [DW].[Initial_PassengerActivity_YearlyFact];
GO
EXEC [DW].[Initial_LoyaltyPoint_TransactionalFact];
GO
EXEC [DW].[Initial_CrewAssignmentEvent_Factless];
GO
EXEC [DW].[Initial_PersonPointTransactions_MonthlyFact];
GO
EXEC [DW].[Initial_PersonPointTransactions_ACCFact];
GO

GO
EXEC [DW].[Initial_MaintenanceEvent_TransactionalFact];
GO

GO
EXEC [DW].[Initial_FlightPerformance_TransactionalFact];
GO
EXEC [DW].[Initial_FlightDelay_DailyFact];
GO
EXEC [DW].[Initial_FlightDelay_ACCFact];
GO
EXEC [DW].[Initial_AirlineAndAirport_Factless];
GO