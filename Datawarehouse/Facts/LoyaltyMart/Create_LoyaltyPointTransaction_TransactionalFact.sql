CREATE TABLE [DW].[LoyaltyPointTransaction_TransactionalFact] (

    [TransactionDateKey] datetime NOT NULL,
    [PersonKey] int NOT NULL,
    [AccountKey] int NOT NULL,
    [LoyaltyTierKey] int NOT NULL,
    [TransactionTypeKey] int NOT NULL,
    [ConversionRateKey] int NULL,
    [FlightKey] int NULL,
    [ServiceOfferingKey] int NULL,


    [PointsEarned] decimal(18,2) NULL,
    [PointsRedeemed] decimal(18,2) NULL,
    [CurrencyValue] decimal(18,2) NULL,
    [ConversionRateSnapshot] decimal(18,6) NULL,
    [BalanceAfterTransaction] decimal(18,2) NULL,
)
GO

CREATE NONCLUSTERED INDEX IX_LoyaltyPointTransaction_TransactionalFact_TransactionDateKey
ON [DW].[LoyaltyPointTransaction_TransactionalFact] (TransactionDateKey);
GO

CREATE NONCLUSTERED INDEX IX_LoyaltyPointTransaction_TransactionalFact_AccountKey
ON [DW].[LoyaltyPointTransaction_TransactionalFact] (AccountKey);
GO

CREATE NONCLUSTERED INDEX IX_LoyaltyPointTransaction_TransactionalFact_LoyaltyTierKey
ON [DW].[LoyaltyPointTransaction_TransactionalFact] (LoyaltyTierKey);
GO

CREATE NONCLUSTERED INDEX IX_LoyaltyPointTransaction_TransactionalFact_FlightKey
ON [DW].[LoyaltyPointTransaction_TransactionalFact] (FlightKey);
GO


CREATE NONCLUSTERED INDEX IX_LoyaltyPointTransaction_TransactionalFact_PersonKey
ON [DW].[LoyaltyPointTransaction_TransactionalFact] (PersonKey);
GO

CREATE NONCLUSTERED INDEX IX_LoyaltyPointTransaction_TransactionalFact_ServiceOfferingKey
ON [DW].[LoyaltyPointTransaction_TransactionalFact] (ServiceOfferingKey);
GO

CREATE NONCLUSTERED INDEX IX_LoyaltyPointTransaction_TransactionalFact_ConversionRateKey
ON [DW].[LoyaltyPointTransaction_TransactionalFact] (ConversionRateKey);
GO

CREATE NONCLUSTERED INDEX IX_LoyaltyPointTransaction_TransactionalFact_TransactionTypeKey
ON [DW].[LoyaltyPointTransaction_TransactionalFact] (TransactionTypeKey);
GO
