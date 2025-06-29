CREATE SCHEMA [SA]
GO


CREATE TABLE [SA].[Account] (
  [AccountID] integer PRIMARY KEY,
  [PassengerID] integer NOT NULL,
  [RegistrationDate] datetime,
  [LoyaltyTierID] integer NOT NULL,
  [StagingLoadTimestampUTC] datetime,
  [StagingLastUpdateTimestampUTC] datetime,
  [SourceSystem] nvarchar(200)
)
GO


CREATE TABLE [SA].[AccountTierHistory] (
  [HistoryID] integer PRIMARY KEY,
  [AccountID] integer NOT NULL,
  [LoyaltyTierID] integer NOT NULL,
  [EffectiveFrom] datetime NOT NULL,
  [EffectiveTo] datetime,
  [CurrentFlag] bit DEFAULT (1),
  [StagingLoadTimestampUTC] datetime,
  [StagingLastUpdateTimestampUTC] datetime,
  [SourceSystem] nvarchar(200)
)
GO


CREATE TABLE [SA].[Aircraft] (
  [AircraftID] integer PRIMARY KEY,
  [Model] nvarchar(50),
  [Type] nvarchar(50),
  [ManufacturerDate] date,
  [Capacity] integer,
  [Price] decimal(18,2),
  [AirlineID] integer NOT NULL,
  [StagingLoadTimestampUTC] datetime,
  [StagingLastUpdateTimestampUTC] datetime,
  [SourceSystem] nvarchar(200)
)
GO


CREATE TABLE [SA].[Airline] (
  [AirlineID] integer PRIMARY KEY,
  [Name] nvarchar(100),
  [Country] nvarchar(50),
  [FoundedDate] date,
  [HeadquartersNumber] nvarchar(50),
  [FleetSize] integer,
  [Website] nvarchar(200),
  [Current_IATA_Code] nvarchar(3) NULL,
  [StagingLoadTimestampUTC] datetime,
  [StagingLastUpdateTimestampUTC] datetime,
  [SourceSystem] nvarchar(200)
)
GO


CREATE TABLE [SA].[AirlineAirportService] (
  [ServiceTypeCode] nvarchar(50) NOT NULL,
  [FlightTypeCode] nvarchar(50) NOT NULL,
  [ServiceTypeName] nvarchar(100) NOT NULL,
  [FlightTypeName] nvarchar(100) NOT NULL,
  [ContractStartDate] date NOT NULL,
  [ContractEndDate] date,
  [LandingFeeRate] decimal(18,4),
  [PassengerServiceRate] decimal(18,4),
  [StagingLoadTimestampUTC] datetime,
  [StagingLastUpdateTimestampUTC] datetime,
  [SourceSystem] nvarchar(200),
  CONSTRAINT [PK_SA_AirlineAirportService] PRIMARY KEY ([ServiceTypeCode], [FlightTypeCode])
)
GO


CREATE TABLE [SA].[Airport] (
  [AirportID] integer PRIMARY KEY,
  [City] nvarchar(50),
  [Country] nvarchar(50),
  [IATACode] nvarchar(3),
  [ElevationMeter] integer,
  [TimeZone] nvarchar(50),
  [NumberOfTerminals] integer,
  [AnnualPassengerTraffic] bigint,
  [Latitude] decimal(9,6),
  [Longitude] decimal(9,6),
  [ManagerName] nvarchar(100),
  [StagingLoadTimestampUTC] datetime,
  [StagingLastUpdateTimestampUTC] datetime,
  [SourceSystem] nvarchar(200)
)
GO


CREATE TABLE [SA].[CrewAssignment] (
  [CrewAssignmentID] integer PRIMARY KEY,
  [FlightDetailID] integer NOT NULL,
  [CrewMemberID] integer NOT NULL,
  [StagingLoadTimestampUTC] datetime,
  [StagingLastUpdateTimestampUTC] datetime,
  [SourceSystem] nvarchar(200)
)
GO


CREATE TABLE [SA].[CrewMember] (
  [CrewMemberID] integer PRIMARY KEY,
  [PersonID] integer NOT NULL,
  [Role] nvarchar(50),
  [StagingLoadTimestampUTC] datetime,
  [StagingLastUpdateTimestampUTC] datetime,
  [SourceSystem] nvarchar(200)
)
GO


CREATE TABLE [SA].[FlightDetail] (
  [FlightDetailID] integer PRIMARY KEY,
  [DepartureAirportID] integer NOT NULL,
  [DestinationAirportID] integer NOT NULL,
  [DistanceKM] integer NOT NULL,
  [DepartureDateTime] datetime NOT NULL,
  [ArrivalDateTime] datetime NOT NULL,
  [AircraftID] integer,
  [FlightCapacity] integer NOT NULL,
  [TotalCost] decimal(18,2),
  [StagingLoadTimestampUTC] datetime,
  [StagingLastUpdateTimestampUTC] datetime,
  [SourceSystem] nvarchar(200)
)
GO


CREATE TABLE [SA].[FlightOperation] (
  [FlightOperationID] integer PRIMARY KEY,
  [FlightDetailID] integer NOT NULL,
  [ActualDepartureDateTime] datetime,
  [ActualArrivalDateTime] datetime,
  [DelayMinutes] integer DEFAULT (0),
  [CancelFlag] bit DEFAULT (0),
  [LoadFactor] float,
  [DelaySeverityScore] float,
  [StagingLoadTimestampUTC] datetime,
  [StagingLastUpdateTimestampUTC] datetime,
  [SourceSystem] nvarchar(200)
)
GO


CREATE TABLE [SA].[Item] (
  [ItemID] INT PRIMARY KEY,
  [ItemName] NVARCHAR(100),
  [Description] NVARCHAR(300),
  [BasePrice] DECIMAL(18,2),
  [IsLoyaltyRedeemable] BIT DEFAULT 0,
  [StagingLoadTimestampUTC] DATETIME,
  [StagingLastUpdateTimestampUTC] DATETIME,
  [SourceSystem] NVARCHAR(200)
)
GO


CREATE TABLE [SA].[LoyaltyTier] (
  [LoyaltyTierID] integer PRIMARY KEY,
  [Name] nvarchar(50) NOT NULL,
  [MinPoints] integer NOT NULL,
  [Benefits] nvarchar(200),
  [StagingLoadTimestampUTC] datetime,
  [StagingLastUpdateTimestampUTC] datetime,
  [SourceSystem] nvarchar(200)
)
GO


CREATE TABLE [SA].[LoyaltyTransactionType] (
  [LoyaltyTransactionTypeID] INT PRIMARY KEY,
  [TypeName] NVARCHAR(50),
  [StagingLoadTimestampUTC] DATETIME,
  [StagingLastUpdateTimestampUTC] DATETIME,
  [SourceSystem] NVARCHAR(200)
)
GO


CREATE TABLE [SA].[MaintenanceLocation] (
  [LocationID] nvarchar(100) PRIMARY KEY,
  [Name] nvarchar(100),
  [City] nvarchar(50),
  [Country] nvarchar(50),
  [InhouseFlag] bit,
  [StagingLoadTimestampUTC] datetime,
  [StagingLastUpdateTimestampUTC] datetime,
  [SourceSystem] nvarchar(200)
)
GO


CREATE TABLE [SA].[MaintenanceType] (
  [MaintenanceTypeID] integer PRIMARY KEY,
  [Name] nvarchar(100),
  [Category] nvarchar(50),
  [Description] nvarchar(500),
  [StagingLoadTimestampUTC] datetime,
  [StagingLastUpdateTimestampUTC] datetime,
  [SourceSystem] nvarchar(200)
)
GO


CREATE TABLE [SA].[Part] (
  [PartID] integer PRIMARY KEY,
  [Name] nvarchar(100),
  [PartNumber] nvarchar(50),
  [Manufacturer] nvarchar(100),
  [WarrantyPeriodMonths] int,
  [Category] nvarchar(50),
  [StagingLoadTimestampUTC] datetime,
  [StagingLastUpdateTimestampUTC] datetime,
  [SourceSystem] nvarchar(200)
)
GO


CREATE TABLE [SA].[Passenger] (
  [PassengerID] integer PRIMARY KEY,
  [PersonID] integer NOT NULL,
  [PassportNumber] nvarchar(50) UNIQUE,
  [StagingLoadTimestampUTC] datetime,
  [StagingLastUpdateTimestampUTC] datetime,
  [SourceSystem] nvarchar(200)
)
GO


CREATE TABLE [SA].[Payment] (
  [PaymentID] integer PRIMARY KEY,
  [ReservationID] integer NOT NULL,
  [BuyerID] integer NOT NULL,
  [Status] nvarchar(20) DEFAULT 'Pending',
  [RealPrice] decimal(18,2),
  [TicketPrice] decimal(18,2) NOT NULL,
  [Discount] decimal(18,2) DEFAULT (0),
  [Tax] decimal(18,2) DEFAULT (10),
  [Method] nvarchar(50),
  [PaymentDateTime] datetime,
  [StagingLoadTimestampUTC] datetime,
  [StagingLastUpdateTimestampUTC] datetime,
  [SourceSystem] nvarchar(200)
)
GO


CREATE TABLE [SA].[Person] (
  [PersonID] integer PRIMARY KEY,
  [NatCode] nvarchar(20) NOT NULL,
  [Name] nvarchar(100) NOT NULL,
  [Phone] nvarchar(20),
  [Email] nvarchar(100) UNIQUE,
  [Address] nvarchar(200),
  [City] nvarchar(50),
  [Country] nvarchar(50),
  [DateOfBirth] date,
  [Gender] nvarchar(10),
  [PostalCode] nvarchar(20),
  [StagingLoadTimestampUTC] datetime,
  [StagingLastUpdateTimestampUTC] datetime,
  [SourceSystem] nvarchar(200)
)
GO


CREATE TABLE [SA].[PointConversionRate] (
  [PointConversionRateID] INT PRIMARY KEY,
  [ConversionRate] DECIMAL(18,6) NOT NULL,
  [CurrencyCode] NVARCHAR(10) DEFAULT 'USD',
  [StagingLoadTimestampUTC] DATETIME,
  [StagingLastUpdateTimestampUTC] DATETIME,
  [SourceSystem] NVARCHAR(200)
)
GO


CREATE TABLE [SA].[Points] (
  [PointsID] integer PRIMARY KEY,
  [AccountID] integer NOT NULL,
  [PointsBalance] decimal(18,2) DEFAULT (0),
  [EffectiveDate] datetime NOT NULL,
  [StagingLoadTimestampUTC] datetime,
  [StagingLastUpdateTimestampUTC] datetime,
  [SourceSystem] nvarchar(200)
)
GO


CREATE TABLE [SA].[PointsTransaction] (
  [PointsTransactionID] INT PRIMARY KEY,
  [AccountID] INT NOT NULL,
  [TransactionDate] DATETIME NOT NULL,
  [LoyaltyTransactionTypeID] INT NOT NULL,
  [PointsChange] DECIMAL(18,2) NOT NULL,
  [BalanceAfterTransaction] DECIMAL(18,2) NOT NULL,
  [CurrencyValue] DECIMAL(18,2),
  [ConversionRate] DECIMAL(18,6),
  [PointConversionRateID] INT,
  [Description] NVARCHAR(200),
  [ServiceOfferingID] INT,
  [FlightDetailID] INT,
  [StagingLoadTimestampUTC] DATETIME,
  [StagingLastUpdateTimestampUTC] DATETIME,
  [SourceSystem] NVARCHAR(200)
)
GO


CREATE TABLE [SA].[Reservation] (
  [ReservationID] integer PRIMARY KEY,
  [PassengerID] integer NOT NULL,
  [FlightDetailID] integer NOT NULL,
  [ReservationDate] datetime,
  [SeatDetailID] integer,
  [Status] nvarchar(20) DEFAULT 'Booked',
  [StagingLoadTimestampUTC] datetime,
  [StagingLastUpdateTimestampUTC] datetime,
  [SourceSystem] nvarchar(200)
)
GO


CREATE TABLE [SA].[SeatDetail] (
  [SeatDetailID] integer PRIMARY KEY,
  [AircraftID] integer NOT NULL,
  [SeatNo] integer NOT NULL,
  [SeatType] nvarchar(20),
  [TravelClassID] integer,
  [ReservationID] integer,
  [StagingLoadTimestampUTC] datetime,
  [StagingLastUpdateTimestampUTC] datetime,
  [SourceSystem] nvarchar(200)
)
GO


CREATE TABLE [SA].[ServiceOffering] (
  [ServiceOfferingID] INT PRIMARY KEY,
  [TravelClassID] INT,
  [OfferingName] NVARCHAR(100),
  [Description] NVARCHAR(300),
  [TotalCost] DECIMAL(18,2),
  [StagingLoadTimestampUTC] DATETIME,
  [StagingLastUpdateTimestampUTC] DATETIME,
  [SourceSystem] NVARCHAR(200)
)

GO


CREATE TABLE [SA].[ServiceOfferingItem] (
  [ServiceOfferingID] INT NOT NULL,
  [ItemID] INT NOT NULL,
  [Quantity] INT,
  [StagingLoadTimestampUTC] DATETIME,
  [StagingLastUpdateTimestampUTC] DATETIME,
  [SourceSystem] NVARCHAR(200),
  CONSTRAINT [PK_SA_ServiceOfferingItem] PRIMARY KEY ([ServiceOfferingID], [ItemID])
)

GO


CREATE TABLE [SA].[Technician] (
  [TechnicianID] INT PRIMARY KEY,
  [PersonID] INT,
  [Specialty] NVARCHAR(100),
  [StagingLoadTimestampUTC] DATETIME,
  [StagingLastUpdateTimestampUTC] DATETIME,
  [SourceSystem] NVARCHAR(200)
)
GO


CREATE TABLE [SA].[TravelClass] (
  [TravelClassID] INT PRIMARY KEY,
  [ClassName] NVARCHAR(50),
  [Capacity] INT,
  [BaseCost] DECIMAL(18,2),
  [StagingLoadTimestampUTC] DATETIME,
  [StagingLastUpdateTimestampUTC] DATETIME,
  [SourceSystem] NVARCHAR(200)
)

GO


CREATE TABLE [SA].[MaintenanceEvent] (
  [MaintenanceEventID] INT PRIMARY KEY,
  [AircraftID] INT NOT NULL,
  [MaintenanceTypeID] INT NOT NULL,
  [LocationID] NVARCHAR(100) NOT NULL,
  [TechnicianID] INT NOT NULL,
  [MaintenanceDate] DATE NOT NULL,
  [DowntimeHours] FLOAT,
  [LaborHours] FLOAT,
  [LaborCost] DECIMAL(18,2),
  [TotalPartsCost] DECIMAL(18,2),
  [TotalMaintenanceCost] DECIMAL(18,2),
  [DistinctIssuesSolved] INT,
  [Description] NVARCHAR(500),
  [StagingLoadTimestampUTC] DATETIME,
  [StagingLastUpdateTimestampUTC] DATETIME,
  [SourceSystem] NVARCHAR(200)
)
GO



CREATE TABLE [SA].[PartReplacement] (
  [PartReplacementID] INT PRIMARY KEY,
  [AircraftID] INT NOT NULL,
  [PartID] INT NOT NULL,
  [LocationID] NVARCHAR(100) NOT NULL,
  [ReplacementDate] DATE NOT NULL,
  [Quantity] INT NOT NULL,
  [PartCost] DECIMAL(18,2),
  [TotalPartCost] DECIMAL(18,2),
  [StagingLoadTimestampUTC] DATETIME,
  [StagingLastUpdateTimestampUTC] DATETIME,
  [SourceSystem] NVARCHAR(200)
)
GO
