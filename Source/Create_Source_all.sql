CREATE SCHEMA [Source]

CREATE TABLE [Source].[Account] (
  [AccountID] integer PRIMARY KEY,
  [PassengerID] integer NOT NULL,
  [RegistrationDate] datetime,
  [LoyaltyTierID] integer NOT NULL
)
GO

CREATE TABLE [Source].[AccountTierHistory] (
  [HistoryID] integer PRIMARY KEY,
  [AccountID] integer NOT NULL,
  [LoyaltyTierID] integer NOT NULL,
  [EffectiveFrom] datetime NOT NULL,
  [EffectiveTo] datetime,
  [CurrentFlag] bit DEFAULT (1)
)
GO

CREATE TABLE [Source].[Aircraft] (
  [AircraftID] integer PRIMARY KEY,
  [Model] nvarchar(50),
  [Type] nvarchar(50),
  [ManufacturerDate] date,
  [Capacity] integer,
  [Price] decimal(18,2),
  [AirlineID] integer NOT NULL
)
GO

CREATE TABLE [Source].[Airline] (
  [AirlineID] integer PRIMARY KEY,
  [Name] nvarchar(100),
  [Country] nvarchar(50),
  [FoundedDate] date,
  [HeadquartersNumber] nvarchar(50),
  [FleetSize] integer,
  [Website] nvarchar(200),
  [Current_IATA_Code] nvarchar(3) NULL
)
GO

CREATE TABLE [Source].[AirlineAirportService] (
    [ServiceTypeCode] NVARCHAR(50) NOT NULL,
    [FlightTypeCode] NVARCHAR(50) NOT NULL,
    [ServiceTypeName] NVARCHAR(100) NOT NULL,
    [FlightTypeName] NVARCHAR(100) NOT NULL,
    [ContractStartDate] DATE NOT NULL,
    [ContractEndDate] DATE,
    [LandingFeeRate] DECIMAL(18,4),
    [PassengerServiceRate] DECIMAL(18,4),
    CONSTRAINT [PK_Source_AirlineAirportService] PRIMARY KEY ([ServiceTypeCode], [FlightTypeCode])
);
GO

CREATE TABLE [Source].[Airport] (
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
  [ManagerName] nvarchar(100)
)
GO

CREATE TABLE [Source].[CrewAssignment] (
  [CrewAssignmentID] integer PRIMARY KEY,
  [FlightDetailID] integer NOT NULL,
  [CrewMemberID] integer NOT NULL
)
GO

CREATE TABLE [Source].[CrewMember] (
  [CrewMemberID] integer PRIMARY KEY,
  [PersonID] integer NOT NULL,
  [Role] nvarchar(50)
)
GO

CREATE TABLE [Source].[FlightDetail] (
  [FlightDetailID] integer PRIMARY KEY,
  [DepartureAirportID] integer NOT NULL,
  [DestinationAirportID] integer NOT NULL,
  [DistanceKM] integer NOT NULL,
  [DepartureDateTime] datetime NOT NULL,
  [ArrivalDateTime] datetime NOT NULL,
  [AircraftID] integer,
  [FlightCapacity] integer NOT NULL,
  [TotalCost] decimal(18,2)
)
GO

CREATE TABLE [Source].[FlightOperation] (
  [FlightOperationID] integer PRIMARY KEY,
  [FlightDetailID] integer NOT NULL,
  [ActualDepartureDateTime] datetime,
  [ActualArrivalDateTime] datetime,
  [DelayMinutes] integer DEFAULT (0),
  [CancelFlag] bit DEFAULT (0),
  [LoadFactor] float,
  [DelaySeverityScore] float
)
GO

CREATE TABLE [Source].[Item] (
  [ItemID] INT PRIMARY KEY,
  [ItemName] NVARCHAR(100),
  [Description] NVARCHAR(300),
  [BasePrice] DECIMAL(18,2),
  [IsLoyaltyRedeemable] BIT DEFAULT 0
)
GO

CREATE TABLE [Source].[LoyaltyTier] (
  [LoyaltyTierID] integer PRIMARY KEY,
  [Name] nvarchar(50) NOT NULL,
  [MinPoints] integer NOT NULL,
  [Benefits] nvarchar(200)
)
GO

CREATE TABLE [Source].[LoyaltyTransactionType] (
  [LoyaltyTransactionTypeID] INT PRIMARY KEY,
  [TypeName] NVARCHAR(50)
)
GO


CREATE TABLE [Source].[MaintenanceLocation] (
  [LocationID]   nvarchar(100) PRIMARY KEY,
  [Name]          nvarchar(100),
  [City]          nvarchar(50),
  [Country]       nvarchar(50),
  [InhouseFlag]  bit
);
GO


CREATE TABLE [Source].[MaintenanceType] (
  [MaintenanceTypeID]  integer PRIMARY KEY,
  [Name]               nvarchar(100),
  [Category]           nvarchar(50),
  [Description]        nvarchar(500)
);
GO


CREATE TABLE [Source].[Part] (
  [PartID]                     integer PRIMARY KEY,
  [Name]                   nvarchar(100),
  [PartNumber]             nvarchar(50),
  [Manufacturer]           nvarchar(100),
  [WarrantyPeriodMonths] int,
  [Category]               nvarchar(50)
);
GO

CREATE TABLE [Source].[Passenger] (
  [PassengerID] integer PRIMARY KEY,
  [PersonID] integer NOT NULL,
  [PassportNumber] nvarchar(50) UNIQUE
)
GO

CREATE TABLE [Source].[Payment] (
  [PaymentID] integer PRIMARY KEY,
  [ReservationID] integer NOT NULL,
  [BuyerID] integer NOT NULL,
  [Status] nvarchar(20) DEFAULT 'Pending',
  [RealPrice] decimal(18,2),
  [TicketPrice] decimal(18,2) NOT NULL,
  [Discount] decimal(18,2) DEFAULT (0),
  [Tax] decimal(18,2) DEFAULT (10),
  [Method] nvarchar(50),
  [PaymentDateTime] datetime
)
GO

CREATE TABLE [Source].[Person] (
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
  [PostalCode] nvarchar(20)
)
GO

CREATE TABLE [Source].[PointConversionRate] (
    [PointConversionRateID] INT PRIMARY KEY,
    [ConversionRate] DECIMAL(18,6) NOT NULL,
    [CurrencyCode] NVARCHAR(10) DEFAULT 'USD'
);
GO

CREATE TABLE [Source].[Points] (
  [PointsID] integer PRIMARY KEY,
  [AccountID] integer NOT NULL,
  [PointsBalance] decimal(18,2) DEFAULT (0),
  [EffectiveDate] datetime NOT NULL
)
GO

CREATE TABLE [Source].[PointsTransaction] (
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
  [FlightDetailID] INT
)
GO

CREATE TABLE [Source].[Reservation] (
  [ReservationID] integer PRIMARY KEY,
  [PassengerID] integer NOT NULL,
  [FlightDetailID] integer NOT NULL,
  [ReservationDate] datetime,
  [SeatDetailID] integer,
  [Status] nvarchar(20) DEFAULT 'Booked'
)
GO

CREATE TABLE [Source].[SeatDetail] (
  [SeatDetailID] integer PRIMARY KEY,
  [AircraftID] integer NOT NULL,
  [SeatNo] integer NOT NULL,
  [SeatType] nvarchar(20),
  [TravelClassID] integer,
  [ReservationID] integer
)
GO

CREATE TABLE [Source].[ServiceOffering] (
  [ServiceOfferingID] INT PRIMARY KEY,
  [TravelClassID] INT,
  [OfferingName] NVARCHAR(100),
  [Description] NVARCHAR(300),
  [TotalCost] DECIMAL(18,2)
)
GO

CREATE TABLE [Source].[ServiceOfferingItem] (
  [ServiceOfferingID] INT,
  [ItemID] INT,
  [Quantity] INT,
  PRIMARY KEY ([ServiceOfferingID], [ItemID])
)
GO


CREATE TABLE [Source].[Technician] (
    [TechnicianID] INT PRIMARY KEY,
    [PersonID] INT,
    [Specialty] NVARCHAR(100),
);
GO

CREATE TABLE [Source].[TravelClass] (
  [TravelClassID] INT PRIMARY KEY,
  [ClassName] NVARCHAR(50) NOT NULL,
  [Capacity] INT,
  [BaseCost] DECIMAL(18,2)
)
GO


CREATE TABLE [Source].[MaintenanceEvent] (
  MaintenanceEventID INT PRIMARY KEY,
  AircraftID INT NOT NULL,
  MaintenanceTypeID INT NOT NULL,
  LocationID NVARCHAR(100) NOT NULL,
  TechnicianID INT NOT NULL,
  MaintenanceDate DATE NOT NULL,
  DowntimeHours FLOAT,
  LaborHours FLOAT,
  LaborCost DECIMAL(18,2),
  TotalPartsCost DECIMAL(18,2),
  TotalMaintenanceCost DECIMAL(18,2),
  DistinctIssuesSolved INT,
  Description NVARCHAR(500)
);
GO


CREATE TABLE [Source].[PartReplacement] (
  PartReplacementID INT PRIMARY KEY,
  AircraftID INT NOT NULL,
  PartID INT NOT NULL,
  LocationID NVARCHAR(100) NOT NULL,
  ReplacementDate DATE NOT NULL,
  Quantity INT NOT NULL,
  PartCost DECIMAL(18,2),
  TotalPartCost DECIMAL(18,2)
);
GO