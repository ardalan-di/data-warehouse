CREATE TABLE [DW].[DimServiceOffering] (
  [ServiceOfferingID] INT PRIMARY KEY,
  [OfferingName] NVARCHAR(100),
  [Description] NVARCHAR(300),
  [TravelClassName] NVARCHAR(50),
  [TotalCost] DECIMAL(18,2),
  [ItemsSummary] NVARCHAR(400)
);
GO

CREATE NONCLUSTERED INDEX IX_DimServiceOffering_OfferingName
ON [DW].[DimServiceOffering] (OfferingName);
GO

CREATE NONCLUSTERED INDEX IX_DimServiceOffering_TravelClassName
ON [DW].[DimServiceOffering] (TravelClassName);
GO
