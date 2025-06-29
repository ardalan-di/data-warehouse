CREATE OR ALTER PROCEDURE [DW].[ALL_LOAD]
AS
BEGIN
SET NOCOUNT ON;


    EXEC [DW].[ETL_Account_Dim];
    EXEC [DW].[ETL_Aircraft_Dim];
    EXEC [DW].[ETL_AirlineAirportService_Dim];
    EXEC [DW].[ETL_Airline_Dim];
    EXEC [DW].[ETL_Airport_Dim];
    EXEC [DW].[ETL_Crew_Dim];
    EXEC [DW].[ETL_Flight_Dim];
    EXEC [DW].[ETL_LoyaltyTier_Dim];
    EXEC [DW].[ETL_LoyaltyTransactionType_Dim];
    EXEC [DW].[ETL_Payment_Dim];
    EXEC [DW].[ETL_Person_Dim];
    EXEC [DW].[ETL_PointConversionRate_Dim];
    EXEC [DW].[ETL_ServiceOffering_Dim];
    EXEC [DW].[ETL_TravelClass_Dim];








    EXEC [DW].[Load_LoyaltyPoint_TransactionalFact];
    EXEC [DW].[Load_CrewAssignmentEvent_Factless];
    EXEC [DW].[Load_PersonPointTransactions_MonthlyFact];
    EXEC [DW].[Load_PersonPointTransactions_ACCFact];

    EXEC [DW].[Load_FlightOperation_Factless];
    EXEC [DW].[Load_PassengerActivity_ACCFact];
    EXEC [DW].[Load_PassengerTicket_TransactionalFact];
    EXEC [DW].[Load_PassengerActivity_YearlyFact];

    EXEC [DW].[Load_FlightPerformance_TransactionalFact];
    EXEC [DW].[Load_FlightPerformance_DailyFact];
    EXEC [DW].[Load_FlightPerformance_ACCFact];
    EXEC [DW].[Load_AirlineAndAirport_Factless];

END
GO