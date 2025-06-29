CREATE TABLE [DW].[DimAccount] (
  [AccountID] INT PRIMARY KEY,
  [PassengerName] NVARCHAR(100),
  [RegistrationDate] DATETIME,
  [LoyaltyTierName] NVARCHAR(50)
)
GO

CREATE NONCLUSTERED INDEX IX_DimAccount_LoyaltyTierName
ON [DW].[DimAccount] (LoyaltyTierName);
GO

CREATE NONCLUSTERED INDEX IX_DimAccount_PassengerName
ON [DW].[DimAccount] (PassengerName);
GO

CREATE NONCLUSTERED INDEX IX_DimAccount_RegistrationDate
ON [DW].[DimAccount] (RegistrationDate);
GO
