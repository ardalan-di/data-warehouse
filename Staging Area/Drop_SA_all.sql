DROP TABLE IF EXISTS [SA].[Account];
DROP TABLE IF EXISTS [SA].[AccountTierHistory];
DROP TABLE IF EXISTS [SA].[Aircraft];
DROP TABLE IF EXISTS [SA].[Airline];
DROP TABLE IF EXISTS [SA].[AirlineAirportService];
DROP TABLE IF EXISTS [SA].[Airport];
DROP TABLE IF EXISTS [SA].[CrewAssignment];
DROP TABLE IF EXISTS [SA].[CrewMember];
DROP TABLE IF EXISTS [SA].[FlightDetail];
DROP TABLE IF EXISTS [SA].[FlightOperation];
DROP TABLE IF EXISTS [SA].[Item];
DROP TABLE IF EXISTS [SA].[LoyaltyTier];
DROP TABLE IF EXISTS [SA].[LoyaltyTransactionType];
DROP TABLE IF EXISTS [SA].[MaintenanceEvent];
DROP TABLE IF EXISTS [SA].[PartReplacement];
DROP TABLE IF EXISTS [SA].[MaintenanceLocation];
DROP TABLE IF EXISTS [SA].[MaintenanceType];
DROP TABLE IF EXISTS [SA].[Part];
DROP TABLE IF EXISTS [SA].[Payment];
DROP TABLE IF EXISTS [SA].[Passenger];
DROP TABLE IF EXISTS [SA].[Person];
DROP TABLE IF EXISTS [SA].[PointConversionRate];
DROP TABLE IF EXISTS [SA].[Points];
DROP TABLE IF EXISTS [SA].[PointsTransaction];
DROP TABLE IF EXISTS [SA].[Reservation];
DROP TABLE IF EXISTS [SA].[SeatDetail];
DROP TABLE IF EXISTS [SA].[ServiceOffering];
DROP TABLE IF EXISTS [SA].[ServiceOfferingItem];
DROP TABLE IF EXISTS [SA].[Technician];
DROP TABLE IF EXISTS [SA].[TravelClass];


DROP TABLE IF EXISTS [SA].[ETL_Log];


IF OBJECT_ID('[SA].[ETL_Account]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_Account];
IF OBJECT_ID('[SA].[ETL_AccountTierHistory]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_AccountTierHistory];
IF OBJECT_ID('[SA].[ETL_Aircraft]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_Aircraft];
IF OBJECT_ID('[SA].[ETL_Airline]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_Airline];
IF OBJECT_ID('[SA].[ETL_AirlineAirportService]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_AirlineAirportService];
IF OBJECT_ID('[SA].[ETL_Airport]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_Airport];
IF OBJECT_ID('[SA].[ETL_CrewAssignment]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_CrewAssignment];
IF OBJECT_ID('[SA].[ETL_CrewMember]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_CrewMember];
IF OBJECT_ID('[SA].[ETL_FlightDetail]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_FlightDetail];
IF OBJECT_ID('[SA].[ETL_FlightOperation]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_FlightOperation];
IF OBJECT_ID('[SA].[ETL_Item]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_Item];
IF OBJECT_ID('[SA].[ETL_LoyaltyTier]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_LoyaltyTier];
IF OBJECT_ID('[SA].[ETL_LoyaltyTransactionType]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_LoyaltyTransactionType];
IF OBJECT_ID('[SA].[ETL_MaintenanceEvent]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_MaintenanceEvent];
IF OBJECT_ID('[SA].[ETL_MaintenanceType]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_MaintenanceType];
IF OBJECT_ID('[SA].[ETL_MaintenanceLocation]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_MaintenanceLocation];
IF OBJECT_ID('[SA].[ETL_PartReplacement]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_PartReplacement];
IF OBJECT_ID('[SA].[ETL_Main_ETL]', 'P') IS NOT NULL DROP PROCEDURE [SA].[Main_ETL];
IF OBJECT_ID('[SA].[ETL_Part]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_Part];
IF OBJECT_ID('[SA].[ETL_Passenger]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_Passenger];
IF OBJECT_ID('[SA].[ETL_Payment]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_Payment];
IF OBJECT_ID('[SA].[ETL_Person]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_Person];
IF OBJECT_ID('[SA].[ETL_PointConversionRate]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_PointConversionRate];
IF OBJECT_ID('[SA].[ETL_Points]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_Points];
IF OBJECT_ID('[SA].[ETL_PointsTransaction]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_PointsTransaction];
IF OBJECT_ID('[SA].[ETL_Reservation]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_Reservation];
IF OBJECT_ID('[SA].[ETL_SeatDetail]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_SeatDetail];
IF OBJECT_ID('[SA].[ETL_ServiceOffering]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_ServiceOffering];
IF OBJECT_ID('[SA].[ETL_ServiceOfferingItem]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_ServiceOfferingItem];
IF OBJECT_ID('[SA].[ETL_Technician]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_Technician];
IF OBJECT_ID('[SA].[ETL_TravelClass]', 'P') IS NOT NULL DROP PROCEDURE [SA].[ETL_TravelClass];


IF OBJECT_ID('[SA].[Main_ETL]', 'P') IS NOT NULL DROP PROCEDURE [SA].[Main_ETL];

DROP SCHEMA IF EXISTS [SA];
GO