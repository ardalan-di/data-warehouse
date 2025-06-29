CREATE TABLE [DW].[DimAirline] (
  [AirlineID] INT PRIMARY KEY,
  [Name] NVARCHAR(100),
  [Country] NVARCHAR(50),
  [FoundedYear] INT,
  [FleetSize] INT,
  [Website] NVARCHAR(200),
  [Current_IATA_Code] NVARCHAR(3) NULL,
  [Previous_IATA_Code] NVARCHAR(3) NULL,
  [IATA_Code_Changed_Date] DATE NULL
);
GO

CREATE NONCLUSTERED INDEX IX_DimAirline_Country
ON [DW].[DimAirline] (Country);
GO

CREATE NONCLUSTERED INDEX IX_DimAirline_Name
ON [DW].[DimAirline] (Name);
GO

CREATE NONCLUSTERED INDEX IX_DimAirline_Current_IATA_Code
ON [DW].[DimAirline] (Current_IATA_Code);
GO
