CREATE TABLE [DW].[DimLoyaltyTransactionType] (
  LoyaltyTransactionTypeID INT PRIMARY KEY,
  TypeName NVARCHAR(250)
);
GO

CREATE NONCLUSTERED INDEX IX_DimLoyaltyTransactionType_TypeName
ON [DW].[DimLoyaltyTransactionType] (TypeName);
GO
