CREATE TABLE [DW].[DimLoyaltyTier] (
    [LoyaltyTierKey]    INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [LoyaltyTierID]     INT NOT NULL,
    [Name]              NVARCHAR(255) NULL,
    [MinPoints]         INT            NULL,
    [Benefits]          NVARCHAR(255) NULL,
    [EffectiveFrom]     DATETIME       NOT NULL,
    [EffectiveTo]       DATETIME       NULL,
    [MinPointsIsCurrent] BIT           NOT NULL
);
GO

CREATE NONCLUSTERED INDEX IX_DimLoyaltyTier_BusinessKey_SCD
ON [DW].[DimLoyaltyTier] (LoyaltyTierID, EffectiveFrom, EffectiveTo);
GO

CREATE NONCLUSTERED INDEX IX_DimLoyaltyTier_Name
ON [DW].[DimLoyaltyTier] (Name);
GO


CREATE NONCLUSTERED INDEX IX_DimLoyaltyTier_MinPointsIsCurrent
ON [DW].[DimLoyaltyTier] (MinPointsIsCurrent)
WHERE MinPointsIsCurrent = 1;
GO