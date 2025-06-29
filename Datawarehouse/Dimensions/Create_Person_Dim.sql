CREATE TABLE [DW].[DimPerson] (

  [PersonKey]                INT             IDENTITY(1,1) NOT NULL PRIMARY KEY,
  [PersonID]                 INT             NOT NULL,
  [NationalCode]             NVARCHAR(255)   NULL,
  [PassportNumber]           NVARCHAR(255)   NULL,
  [Name]                     NVARCHAR(255)   NULL,
  [Gender]                   NVARCHAR(255)   NULL,
  [DateOfBirth]              DATE            NULL,
  [City]                     NVARCHAR(255)   NULL,
  [Country]                  NVARCHAR(255)   NULL,
  [Email]                    NVARCHAR(255)   NULL,
  [Phone]                    NVARCHAR(255)   NULL,
  [Address]                  NVARCHAR(255)   NULL,
  [PostalCode]               NVARCHAR(255)   NULL,
  [EffectiveFrom]            DATETIME        NOT NULL,
  [EffectiveTo]              DATETIME        NULL,
  [PassportNumberIsCurrent]  BIT             NOT NULL
);
GO

CREATE NONCLUSTERED INDEX IX_DimPerson_BusinessKey_SCD
ON [DW].[DimPerson] (PersonID, EffectiveFrom, EffectiveTo);
GO

CREATE NONCLUSTERED INDEX IX_DimPerson_Country_City
ON [DW].[DimPerson] (Country, City);
GO

CREATE NONCLUSTERED INDEX IX_DimPerson_Name
ON [DW].[DimPerson] (Name);
GO

CREATE NONCLUSTERED INDEX IX_DimPerson_NationalCode
ON [DW].[DimPerson] (NationalCode);
GO

CREATE NONCLUSTERED INDEX IX_DimPerson_PassportNumberIsCurrent
ON [DW].[DimPerson] (PassportNumberIsCurrent)
WHERE PassportNumberIsCurrent = 1;
GO
