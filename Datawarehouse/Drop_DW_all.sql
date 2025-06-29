


DROP TABLE IF EXISTS [DW].[LoyaltyPointTransaction_TransactionalFact];
DROP TABLE IF EXISTS [DW].[CrewAssignmentEvent_Factless];
DROP TABLE IF EXISTS [DW].[PersonPointTransactions_MonthlyFact];
DROP TABLE IF EXISTS [DW].[PersonPointTransactions_ACCFact];



DROP TABLE IF EXISTS [DW].[AircraftHealth_MonthlyFact];
DROP TABLE IF EXISTS [DW].[MaintenanceEvent_TransactionalFact];
DROP TABLE IF EXISTS [DW].[PartReplacement_TransactionalFact];


DROP TABLE IF EXISTS [DW].[FlightPerformance_TransactionalFact];
DROP TABLE IF EXISTS [DW].[FlightDelay_DailyFact];
DROP TABLE IF EXISTS [DW].[FlightDelay_ACCFact];
DROP TABLE IF EXISTS [DW].[AirlineAndAirport_Factless];


DROP TABLE IF EXISTS [DW].[FlightOperation_Factless];
DROP TABLE IF EXISTS [DW].[PassengerActivity_ACCFact];
DROP TABLE IF EXISTS [DW].[PassengerTicket_TransactionalFact];
DROP TABLE IF EXISTS [DW].[PassengerActivity_YearlyFact];


DROP TABLE IF EXISTS [DW].[DimAccount];
DROP TABLE IF EXISTS [DW].[DimAircraft];
DROP TABLE IF EXISTS [DW].[DimAirlineAirportService];
DROP TABLE IF EXISTS [DW].[DimAirline];
DROP TABLE IF EXISTS [DW].[DimAirport];
DROP TABLE IF EXISTS [DW].[DimCrew];
DROP TABLE IF EXISTS [DW].[DimDateTime];
DROP TABLE IF EXISTS [DW].[DimDate];
DROP TABLE IF EXISTS [DW].[DimFlightOperationType];
DROP TABLE IF EXISTS [DW].[DimFlight];
DROP TABLE IF EXISTS [DW].[DimLoyaltyTier];
DROP TABLE IF EXISTS [DW].[DimLoyaltyTransactionType];
DROP TABLE IF EXISTS [DW].[DimMaintenanceLocation];
DROP TABLE IF EXISTS [DW].[DimMaintenanceType];
DROP TABLE IF EXISTS [DW].[DimPart];
DROP TABLE IF EXISTS [DW].[DimPayment];
DROP TABLE IF EXISTS [DW].[DimPerson];
DROP TABLE IF EXISTS [DW].[DimPointConversionRate];
DROP TABLE IF EXISTS [DW].[DimServiceOffering];
DROP TABLE IF EXISTS [DW].[DimTechnician];
DROP TABLE IF EXISTS [DW].[DimTravelClass];


DROP TABLE IF EXISTS [DW].[Temp_Account_table];
DROP TABLE IF EXISTS [DW].[Temp_Aircraft_table];
DROP TABLE IF EXISTS [DW].[Temp_AirlineAirportService_table];
DROP TABLE IF EXISTS [DW].[Temp_Airline_table];
DROP TABLE IF EXISTS [DW].[Temp_Airport_table];
DROP TABLE IF EXISTS [DW].[Temp_Crew_table];
DROP TABLE IF EXISTS [DW].[Temp_DateTime_table];
DROP TABLE IF EXISTS [DW].[Temp_Date_table];
DROP TABLE IF EXISTS [DW].[Temp_FlightOperationType_table];
DROP TABLE IF EXISTS [DW].[Temp_Flight_table];
DROP TABLE IF EXISTS [DW].[Temp_DailyLoyaltyTransactions];
DROP TABLE IF EXISTS [DW].[Temp_EnrichedLoyaltyData];
DROP TABLE IF EXISTS [DW].[Temp_LoyaltyTier_table];
DROP TABLE IF EXISTS [DW].[Temp_LoyaltyTransactionType_table];
DROP TABLE IF EXISTS [DW].[Temp_MaintenanceLocation_table];
DROP TABLE IF EXISTS [DW].[Temp_MaintenanceType_table];
DROP TABLE IF EXISTS [DW].[Temp_Parts_table];
DROP TABLE IF EXISTS [DW].[Temp_Payment_table];
DROP TABLE IF EXISTS [DW].[Temp_Person_table];
DROP TABLE IF EXISTS [DW].[Temp_PointConversionRate_table];
DROP TABLE IF EXISTS [DW].[Temp_ServiceOffering_table];
DROP TABLE IF EXISTS [DW].[Temp_Technician_table];
DROP TABLE IF EXISTS [DW].[Temp_DailyPayments];
DROP TABLE IF EXISTS [DW].[Temp_EnrichedFlightData];
DROP TABLE IF EXISTS [DW].[Temp_EnrichedPersonData];
DROP TABLE IF EXISTS [DW].[Temp_DailyFlightOperations];
DROP TABLE IF EXISTS [DW].[Temp_EnrichedFlightPerformanceData];
DROP TABLE IF EXISTS [DW].[Temp_LifetimeSourceData];
DROP TABLE IF EXISTS [DW].[Temp_TravelClass_Dim];
DROP TABLE IF EXISTS [DW].[Temp_MaintenanceEvent_Batch];



DROP TABLE IF EXISTS [DW].[ETL_Log];




IF OBJECT_ID('[DW].[Initial_Account_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_Account_Dim];
IF OBJECT_ID('[DW].[Initial_Aircraft_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_Aircraft_Dim];
IF OBJECT_ID('[DW].[Initial_AirlineAirportService_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_AirlineAirportService_Dim];
IF OBJECT_ID('[DW].[Initial_Airline_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_Airline_Dim];
IF OBJECT_ID('[DW].[Initial_Airport_DIm]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_Airport_DIm];
IF OBJECT_ID('[DW].[Initial_Crew_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_Crew_Dim];
IF OBJECT_ID('[DW].[Initial_DateTime_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_DateTime_Dim];
IF OBJECT_ID('[DW].[Initial_Date_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_Date_Dim];
IF OBJECT_ID('[DW].[Initial_FlightOperationType_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_FlightOperationType_Dim];
IF OBJECT_ID('[DW].[Initial_Flight_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_Flight_Dim];
IF OBJECT_ID('[DW].[Initial_LoyaltyTier_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_LoyaltyTier_Dim];
IF OBJECT_ID('[DW].[Initial_LoyaltyTransactionType_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_LoyaltyTransactionType_Dim];
IF OBJECT_ID('[DW].[Initial_MaintenanceLocation_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_MaintenanceLocation_Dim];
IF OBJECT_ID('[DW].[Initial_MaintenanceType_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_MaintenanceType_Dim];
IF OBJECT_ID('[DW].[Initial_Part_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_Part_Dim];
IF OBJECT_ID('[DW].[Initial_Payment_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_Payment_Dim];
IF OBJECT_ID('[DW].[Initial_Person_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_Person_Dim];
IF OBJECT_ID('[DW].[Initial_PointConversionRate_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_PointConversionRate_Dim];
IF OBJECT_ID('[DW].[Initial_ServiceOffering_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_ServiceOffering_Dim];
IF OBJECT_ID('[DW].[Initial_Technician_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_Technician_Dim];
IF OBJECT_ID('[DW].[Initial_TravelClass_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_TravelClass_Dim];

IF OBJECT_ID('[DW].[ETL_Account_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[ETL_Account_Dim];
IF OBJECT_ID('[DW].[ETL_Aircraft_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[ETL_Aircraft_Dim];
IF OBJECT_ID('[DW].[ETL_AirlineAirportService_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[ETL_AirlineAirportService_Dim];
IF OBJECT_ID('[DW].[ETL_Airline_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[ETL_Airline_Dim];
IF OBJECT_ID('[DW].[ETL_Airport_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[ETL_Airport_Dim];
IF OBJECT_ID('[DW].[ETL_Crew_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[ETL_Crew_Dim];
IF OBJECT_ID('[DW].[ETL_DateTime_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[ETL_DateTime_Dim];
IF OBJECT_ID('[DW].[ETL_Date_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[ETL_Date_Dim];
IF OBJECT_ID('[DW].[ETL_FlightOperationType_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[ETL_FlightOperationType_Dim];
IF OBJECT_ID('[DW].[ETL_Flight_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[ETL_Flight_Dim];
IF OBJECT_ID('[DW].[ETL_LoyaltyTier_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[ETL_LoyaltyTier_Dim];
IF OBJECT_ID('[DW].[ETL_LoyaltyTransactionType_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[ETL_LoyaltyTransactionType_Dim];
IF OBJECT_ID('[DW].[ETL_MaintenanceLocation_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[ETL_MaintenanceLocation_Dim];
IF OBJECT_ID('[DW].[ETL_MaintenanceType_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[ETL_MaintenanceType_Dim];
IF OBJECT_ID('[DW].[ETL_Part_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[ETL_Part_Dim];
IF OBJECT_ID('[DW].[ETL_Payment_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[ETL_Payment_Dim];
IF OBJECT_ID('[DW].[ETL_Person_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[ETL_Person_Dim];
IF OBJECT_ID('[DW].[ETL_PointConversionRate_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[ETL_PointConversionRate_Dim];
IF OBJECT_ID('[DW].[ETL_ServiceOffering_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[ETL_ServiceOffering_Dim];
IF OBJECT_ID('[DW].[ETL_Technician_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[ETL_Technician_Dim];
IF OBJECT_ID('[DW].[ETL_TravelClass_Dim]', 'P') IS NOT NULL DROP PROCEDURE [DW].[ETL_TravelClass_Dim];


IF OBJECT_ID('[DW].[Main_Dim_Initial_ETL]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Main_Dim_Initial_ETL];





IF OBJECT_ID('[DW].[Load_LoyaltyPoint_TransactionalFact]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Load_LoyaltyPoint_TransactionalFact];
IF OBJECT_ID('[DW].[Initial_LoyaltyPoint_TransactionalFact]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_LoyaltyPoint_TransactionalFact];

IF OBJECT_ID('[DW].[Load_CrewAssignmentEvent_Factless]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Load_CrewAssignmentEvent_Factless];
IF OBJECT_ID('[DW].[Initial_CrewAssignmentEvent_Factless]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_CrewAssignmentEvent_Factless];

IF OBJECT_ID('[DW].[Load_PersonPointTransactions_MonthlyFact]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Load_PersonPointTransactions_MonthlyFact];
IF OBJECT_ID('[DW].[Initial_PersonPointTransactions_MonthlyFact]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_PersonPointTransactions_MonthlyFact];

IF OBJECT_ID('[DW].[Load_PersonPointTransactions_ACCFact]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Load_PersonPointTransactions_ACCFact];
IF OBJECT_ID('[DW].[Initial_PersonPointTransactions_ACCFact]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_PersonPointTransactions_ACCFact];




IF OBJECT_ID('[DW].[Load_FlightOperation_Factless]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Load_FlightOperation_Factless];
IF OBJECT_ID('[DW].[Initial_FlightOperation_Factless]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_FlightOperation_Factless];

IF OBJECT_ID('[DW].[Load_PassengerActivity_ACCFact]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Load_PassengerActivity_ACCFact];
IF OBJECT_ID('[DW].[Initial_PassengerActivity_ACCFact]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_PassengerActivity_ACCFact];

IF OBJECT_ID('[DW].[Load_PassengerTicket_TransactionalFact]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Load_PassengerTicket_TransactionalFact];
IF OBJECT_ID('[DW].[Initial_PassengerTicket_TransactionalFact]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_PassengerTicket_TransactionalFact];

IF OBJECT_ID('[DW].[Load_PassengerActivity_YearlyFact]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Load_PassengerActivity_YearlyFact];
IF OBJECT_ID('[DW].[Initial_PassengerActivity_YearlyFact]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_PassengerActivity_YearlyFact];


IF OBJECT_ID('[DW].[Load_FlightPerformance_TransactionalFact]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Load_FlightPerformance_TransactionalFact];
IF OBJECT_ID('[DW].[Initial_FlightPerformance_TransactionalFact]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_FlightPerformance_TransactionalFact];

IF OBJECT_ID('[DW].[Load_FlightDelay_DailyFact]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Load_FlightDelay_DailyFact];
IF OBJECT_ID('[DW].[Initial_FlightDelay_DailyFact]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_FlightDelay_DailyFact];

IF OBJECT_ID('[DW].[Load_FlightDelay_ACCFact]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Load_FlightDelay_ACCFact];
IF OBJECT_ID('[DW].[Initial_FlightDelay_ACCFact]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_FlightDelay_ACCFact];

IF OBJECT_ID('[DW].[Load_AirlineAndAirport_Factless]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Load_AirlineAndAirport_Factless];
IF OBJECT_ID('[DW].[Initial_AirlineAndAirport_Factless]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_AirlineAndAirport_Factless];





IF OBJECT_ID('[DW].[Initial_MaintenanceEvent_TransactionalFact]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Initial_MaintenanceEvent_TransactionalFact];





IF OBJECT_ID('[DW].[Main_Fact_Initial_ETL]', 'P') IS NOT NULL DROP PROCEDURE [DW].[Main_Fact_Initial_ETL];



IF OBJECT_ID('[DW].[ALL_Initial_ETL]', 'P') IS NOT NULL DROP PROCEDURE [DW].[ALL_Initial_ETL];


DROP SCHEMA IF EXISTS [DW];
