CREATE TABLE [SA].[ETL_Log] (
    [LogID]             BIGINT            IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [ProcedureName]     NVARCHAR(255)     NOT NULL,
    [SourceTable]       NVARCHAR(255)     NOT NULL,
    [TargetTable]       NVARCHAR(255)     NOT NULL,
    [ChangeDescription] NVARCHAR(MAX)     NULL,
    [RowsAffected]      INT               NULL,
    [ActionTime]        DATETIME2(3)      NOT NULL DEFAULT SYSUTCDATETIME(),
    [DurationSec]       DECIMAL(9,3)      NULL,
    [Status]            NVARCHAR(50)      NULL,
    [Message]           NVARCHAR(MAX)     NULL
);
GO