CREATE OR ALTER PROCEDURE [DW].[Main_Dim_Initial_ETL]
AS
BEGIN
    SET NOCOUNT ON;


    DECLARE @procs TABLE (ProcName NVARCHAR(128));
    INSERT INTO @procs (ProcName) VALUES
        (N'Initial_Date_Dim'),
        (N'Initial_DateTime_Dim'),
        (N'Initial_Account_Dim'),
        (N'Initial_Aircraft_Dim'),
        (N'Initial_Airline_Dim'),
        (N'Initial_AirlineAirportService_Dim'),
        (N'Initial_Airport_Dim'),
        (N'Initial_Crew_Dim'),
        (N'Initial_Flight_Dim'),
        (N'Initial_LoyaltyTier_Dim'),
        (N'Initial_LoyaltyTransactionType_Dim'),
        (N'Initial_Payment_Dim'),
        (N'Initial_Person_Dim'),
        (N'Initial_PointConversionRate_Dim'),
        (N'Initial_ServiceOffering_Dim'),
        (N'Initial_TravelClass_Dim');

    DECLARE @ProcName NVARCHAR(128), @sql NVARCHAR(300);

    DECLARE proc_cursor CURSOR FOR SELECT ProcName FROM @procs;
    OPEN proc_cursor;
    FETCH NEXT FROM proc_cursor INTO @ProcName;
    WHILE @@FETCH_STATUS = 0
    BEGIN

        IF OBJECT_ID(N'DW.' + @ProcName, 'P') IS NOT NULL
        BEGIN
            SET @sql = N'EXEC [DW].[' + @ProcName + N']';
            EXEC sp_executesql @sql;
        END
        ELSE
        BEGIN
            PRINT N'Skipped: [DW].[' + @ProcName + N'] does not exist.';
        END
        FETCH NEXT FROM proc_cursor INTO @ProcName;
    END
    CLOSE proc_cursor;
    DEALLOCATE proc_cursor;
END
GO


EXEC [DW].[Main_Dim_Initial_ETL];
GO