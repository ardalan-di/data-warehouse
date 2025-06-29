IF OBJECT_ID('[DW].[Temp_Person_table]', 'U') IS NULL
BEGIN
	CREATE TABLE [DW].[Temp_Person_table] (
	  [PersonID]       INT           NOT NULL PRIMARY KEY,
	  [NationalCode]   NVARCHAR(255) NULL,
	  [PassportNumber] NVARCHAR(255) NULL,
	  [Name]           NVARCHAR(255) NULL,
	  [Gender]         NVARCHAR(255) NULL,
	  [DateOfBirth]    DATE          NULL,
	  [City]           NVARCHAR(255) NULL,
	  [Country]        NVARCHAR(255) NULL,
	  [Email]          NVARCHAR(255) NULL,
	  [Phone]          NVARCHAR(255) NULL,
	  [Address]        NVARCHAR(255) NULL,
	  [PostalCode]     NVARCHAR(255) NULL
	);
	END;
GO


IF OBJECT_ID('[DW].[Temp_Aircraft_table]', 'U') IS NULL
BEGIN
  CREATE TABLE [DW].[Temp_Aircraft_table] (
    [AircraftID]        INT           NOT NULL PRIMARY KEY,
    [Model]             NVARCHAR(255) NULL,
    [Type]              NVARCHAR(255) NULL,
    [ManufacturerDate]  DATE          NULL,
    [Capacity]          INT           NULL,
    [Price]             DECIMAL(18,2) NULL
  );
END;
GO


IF OBJECT_ID('[DW].[Temp_Account_table]', 'U') IS NULL
BEGIN
  CREATE TABLE [DW].[Temp_Account_table] (
    [AccountID] INT PRIMARY KEY,
    [PassengerName] NVARCHAR(100),
    [RegistrationDate] DATETIME,
    [LoyaltyTierName] NVARCHAR(50)
  );
END;
GO


IF OBJECT_ID('[DW].[Temp_Airline_table]', 'U') IS NULL
BEGIN
  CREATE TABLE [DW].[Temp_Airline_table] (
    AirlineID     INT            NOT NULL PRIMARY KEY,
    Name          NVARCHAR(255)  NULL,
    Country       NVARCHAR(255)  NULL,
    FoundedYear   INT            NULL,
    FleetSize     INT            NULL,
    Website       NVARCHAR(255)  NULL,
	  Current_IATA_Code varchar(3) NULL,
    Previous_IATA_Code varchar(3) NULL,
    IATA_Code_Changed_Date date NULL,
  );
END;
GO


IF OBJECT_ID('[DW].[Temp_Airport_table]', 'U') IS NULL
BEGIN
  CREATE TABLE [DW].[Temp_Airport_table] (
    AirportID               INT            NOT NULL PRIMARY KEY,
    Name                    NVARCHAR(255)  NULL,
    City                    NVARCHAR(255)  NULL,
    Country                 NVARCHAR(255)  NULL,
    IATACode                NVARCHAR(255)  NULL,
    ElevationMeter          INT            NULL,
    TimeZone                NVARCHAR(255)  NULL,
    NumberOfTerminals       INT            NULL,
    AnnualPassengerTraffic  BIGINT         NULL,
    Latitude                DECIMAL(18,6)  NULL,
    Longitude               DECIMAL(18,6)  NULL
  );
END;
GO


IF OBJECT_ID('[DW].[Temp_Crew_table]', 'U') IS NULL
BEGIN
  CREATE TABLE [DW].[Temp_Crew_table] (
    Crew_ID        INT             NOT NULL PRIMARY KEY,
    NAT_CODE       NVARCHAR(255)   NULL,
    Name           NVARCHAR(255)   NULL,
    Phone          NVARCHAR(255)   NULL,
    Email          NVARCHAR(255)   NULL,
    Address        NVARCHAR(255)   NULL,
    City           NVARCHAR(255)   NULL,
    Country        NVARCHAR(255)   NULL,
    Date_Of_Birth  DATE            NULL,
    Gender         NVARCHAR(255)   NULL,
    Postal_Code    NVARCHAR(255)   NULL,
    Role           NVARCHAR(255)   NULL
  );
END;
GO


IF OBJECT_ID('[DW].[Temp_LoyaltyTier_table]', 'U') IS NULL
BEGIN
  CREATE TABLE [DW].[Temp_LoyaltyTier_table] (
    LoyaltyTierID   INT           NOT NULL PRIMARY KEY,
    Name            NVARCHAR(255) NULL,
    MinPoints       INT           NULL,
    Benefits        NVARCHAR(255) NULL
  );
END;
GO


IF OBJECT_ID('[DW].[Temp_LoyaltyTransactionType_table]', 'U') IS NULL
BEGIN
  CREATE TABLE [DW].[Temp_LoyaltyTransactionType_table] (
    TransactionTypeName NVARCHAR(255) NOT NULL PRIMARY KEY
  );
END;
GO


IF OBJECT_ID('[DW].[Temp_Payment_table]', 'U') IS NULL
BEGIN
  CREATE TABLE [DW].[Temp_Payment_table] (
    PaymentID        INT            NOT NULL PRIMARY KEY,
    PaymentMethod    NVARCHAR(255)  NULL,
    PaymentStatus    NVARCHAR(255)  NULL,
    PaymentTimestamp DATETIME       NULL
  );
END;
GO


IF OBJECT_ID('[DW].[Temp_Flight_table]', 'U') IS NULL
BEGIN
  CREATE TABLE [DW].[Temp_Flight_table] (
  FlightID INT NOT NULL PRIMARY KEY,
  DepartureDateTime DATETIME,
  ArrivalDateTime DATETIME,
  FlightDurationMinutes INT,
  AircraftKey INT,
  FlightCapacity INT,
  TotalCost INT
  );
END;
GO

IF OBJECT_ID('[DW].[Temp_AirlineAirportService_table]', 'U') IS NULL
BEGIN
  CREATE TABLE [DW].[Temp_AirlineAirportService_table] (
    [ServiceTypeCode] VARCHAR(50) NOT NULL,
    [FlightTypeCode] VARCHAR(50) NOT NULL,
    [ServiceTypeName] VARCHAR(100) NULL,
    [FlightTypeName] VARCHAR(100) NULL,
    [ContractStartDate] DATE NULL,
    [ContractEndDate] DATE NULL,
    [LandingFeeRate] DECIMAL(18,4) NULL,
    [PassengerServiceRate] DECIMAL(18,4) NULL
  );
END;
GO

IF OBJECT_ID('[DW].[Temp_DailyPayments]', 'U') IS NULL
BEGIN
  CREATE TABLE [DW].[Temp_DailyPayments](
    [PaymentID] [int] NOT NULL,
    [ReservationID] [int] NOT NULL,
    [BuyerID] [int] NOT NULL,
    [RealPrice] [decimal](18, 2) NULL,
    [TicketPrice] [decimal](18, 2) NOT NULL,
    [Discount] [decimal](18, 2) NULL,
    [Tax] [decimal](18, 2) NULL,
    [PaymentDateTime] [datetime] NULL,
    [TicketHolderPassengerID] [int] NOT NULL,
    [FlightDetailID] [int] NOT NULL,
    [SeatDetailID] [int] NULL
  );
END;
GO

IF OBJECT_ID('[DW].[Temp_EnrichedFlightData]', 'U') IS NULL
BEGIN
  CREATE TABLE [DW].[Temp_EnrichedFlightData](
    [PaymentID] [int] NOT NULL,
    [FlightDateKey] [datetime] NOT NULL,
    [FlightKey] [int] NOT NULL,
    [AircraftKey] [int] NULL,
    [AirlineKey] [int] NOT NULL,
    [TravelClassKey] [int] NOT NULL,
	[SourceAirportKey] [int] NOT NULL,
    [DestinationAirportKey] [int] NOT NULL,
    [FlightClassPrice] [decimal](18, 2) NULL,
    [FlightCost] [decimal](18, 2) NULL,
    [KilometersFlown] [decimal](18, 2) NULL
  );
END;
GO

IF OBJECT_ID('[DW].[Temp_EnrichedPersonData]', 'U') IS NULL
BEGIN
  CREATE TABLE [DW].[Temp_EnrichedPersonData](
    [PaymentID] [int] NOT NULL,
    [BuyerPersonKey] [int] NOT NULL,
    [TicketHolderPersonKey] [int] NOT NULL
  );
END;
GO

IF OBJECT_ID('[DW].[Temp_TravelClass_Dim]', 'U') IS NULL
BEGIN
CREATE TABLE [DW].[Temp_TravelClass_Dim] (
    [TravelClassID] INT PRIMARY KEY,
    [ClassName]      NVARCHAR(50) NOT NULL,
    [Capacity]       INT NULL
);
END;
GO

IF OBJECT_ID('[DW].[Temp_DailyFlightOperations]', 'U') IS NULL
BEGIN
  CREATE TABLE [DW].[Temp_DailyFlightOperations](
    [FlightOperationID] [int] PRIMARY KEY,
    [FlightDetailID] [int] NOT NULL,
    [ActualDepartureDateTime] [datetime] NULL,
    [ActualArrivalDateTime] [datetime] NULL,
    [DelayMinutes] [int] NULL,
    [LoadFactor] [float] NULL,
    [DelaySeverityScore] [float] NULL
  );
END;
GO

IF OBJECT_ID('[DW].[Temp_EnrichedFlightPerformanceData]', 'U') IS NULL
BEGIN
  CREATE TABLE [DW].[Temp_EnrichedFlightPerformanceData](
    [FlightOperationID] [int] PRIMARY KEY,
    [ScheduledDepartureDateTime] [datetime] NOT NULL,
    [ScheduledArrivalDateTime] [datetime] NOT NULL,
    [ActualDepartureDateTime] [datetime] NULL,
    [ActualArrivalDateTime] [datetime] NULL,
    [DepartureAirportID] [int] NOT NULL,
    [ArrivalAirportID] [int] NOT NULL,
    [AircraftID] [int] NULL,
    [AirlineID] [int] NOT NULL,
    [DelayMinutes] [int] NULL,
    [LoadFactor] [float] NULL,
    [DelaySeverityScore] [float] NULL
    );
END;
GO


IF OBJECT_ID('[DW].[Temp_ServiceOffering_table]', 'U') IS NULL
BEGIN
  CREATE TABLE [DW].[Temp_ServiceOffering_table] (
    [ServiceOfferingID]    INT             NOT NULL,
    [OfferingName]         NVARCHAR(100)   NULL,
    [Description]          NVARCHAR(300)   NULL,
    [TravelClassName]      NVARCHAR(50)    NULL,
    [TotalCost]            DECIMAL(18,2)   NULL,
    [ItemsSummary]         NVARCHAR(400)   NULL
  );
END;
GO


IF OBJECT_ID('[DW].[Temp_PointConversionRate_table]', 'U') IS NULL
BEGIN
  CREATE TABLE [DW].[Temp_PointConversionRate_table] (
      PointConversionRateID INT,
      ConversionRate DECIMAL(18,6),
      Currency NVARCHAR(255)
  );
END;
GO

IF OBJECT_ID('[DW].[Temp_DailyLoyaltyTransactions]', 'U') IS NULL
BEGIN
CREATE TABLE [DW].[Temp_DailyLoyaltyTransactions](
	[PointsTransactionID] [int] NOT NULL,
	[AccountID] [int] NOT NULL,
	[TransactionDate] [datetime] NOT NULL,
	[LoyaltyTransactionTypeID] [int] NOT NULL,
	[PointsChange] [decimal](18, 2) NOT NULL,
	[BalanceAfterTransaction] [decimal](18, 2) NOT NULL,
	[CurrencyValue] [decimal](18, 2) NULL,
	[ConversionRate] [decimal](18, 6) NULL,
	[PointConversionRateID] [int] NULL,
	[ServiceOfferingID] [int] NULL,
	[FlightDetailID] [int] NULL
);
END;
GO

IF OBJECT_ID('[DW].[Temp_EnrichedLoyaltyData]', 'U') IS NULL
BEGIN
CREATE TABLE [DW].[Temp_EnrichedLoyaltyData](

	[TransactionDateKey] [datetime] NOT NULL,
	[PersonKey] [int] NOT NULL,
	[AccountKey] [int] NOT NULL,
	[LoyaltyTierKey] [int] NOT NULL,
	[TransactionTypeKey] [int] NOT NULL,
	[ConversionRateKey] [int] NULL,
	[FlightKey] [int] NULL,
	[ServiceOfferingKey] [int] NULL,

	[PointsChange] [decimal](18, 2) NOT NULL,
	[CurrencyValue] [decimal](18, 2) NULL,
	[ConversionRateSnapshot] [decimal](18, 6) NULL,
	[BalanceAfterTransaction] [decimal](18, 2) NOT NULL
);
END;
GO

IF OBJECT_ID('[DW].[Temp_LifetimeSourceData]', 'U') IS NULL
BEGIN
CREATE TABLE [DW].[Temp_LifetimeSourceData] (
    [PersonKey]              INT PRIMARY KEY,
    [TotalTicketValue]       INT NULL,
    [TotalAmountPaid]        DECIMAL(18, 2) NULL,
    [TotalMilesFlown]        DECIMAL(18, 2) NULL,
    [TotalDiscountAmount]    DECIMAL(18, 2) NULL,
    [AverageTicketPrice]     DECIMAL(18, 2) NULL,
    [TotalDistinctAirlinesUsed] INT NULL,
    [TotalDistinctRoutesFlown]  INT NULL,
    [TotalFlights]           INT NULL,
    [MaxFlightDistance]      DECIMAL(18, 2) NULL,
    [MinFlightDistance]      DECIMAL(18, 2) NULL
);
END;
GO

IF OBJECT_ID('[DW].[Temp_MaintenanceEvent_Batch]', 'U') IS NULL
BEGIN
  CREATE TABLE [DW].[Temp_MaintenanceEvent_Batch] (
    MaintenanceEventID INT,
    AircraftID INT,
    MaintenanceTypeID INT,
    LocationID NVARCHAR(100),
    TechnicianID INT,
    MaintenanceDate DATE,
    DowntimeHours FLOAT,
    LaborHours FLOAT,
    LaborCost DECIMAL(18,2),
    TotalPartsCost DECIMAL(18,2),
    TotalMaintenanceCost DECIMAL(18,2),
    DistinctIssuesSolved INT
);
END;
GO