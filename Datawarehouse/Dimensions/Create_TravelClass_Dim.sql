CREATE TABLE [DW].[DimTravelClass] (
    [TravelClassKey] INT PRIMARY KEY,
    [ClassName]      NVARCHAR(50) NOT NULL,
    [Capacity]       INT NULL
);
GO

CREATE NONCLUSTERED INDEX IX_DimTravelClass_ClassName
ON [DW].[DimTravelClass] (ClassName);
GO
