CREATE OR ALTER PROCEDURE [SA].[Main_ETL]
AS
BEGIN
    SET NOCOUNT ON;


    DECLARE @procs TABLE (ProcName NVARCHAR(128));
    INSERT INTO @procs (ProcName) VALUES
        (N'ETL_Account'),
        (N'ETL_AccountTierHistory'),
        (N'ETL_Aircraft'),
        (N'ETL_Airline'),
        (N'ETL_Airport'),
        (N'ETL_CrewAssignment'),
        (N'ETL_CrewMember'),
        (N'ETL_FlightDetail'),
        (N'ETL_FlightOperation'),
        (N'ETL_Item'),
        (N'ETL_LoyaltyTier'),
        (N'ETL_LoyaltyTransactionType'),
        (N'ETL_MaintenanceEvent'),
        (N'ETL_MaintenanceLocation'),
        (N'ETL_MaintenanceType'),
        (N'ETL_Part'),
        (N'ETL_PartReplacement'),
        (N'ETL_Passenger'),
        (N'ETL_Payment'),
        (N'ETL_Person'),
        (N'ETL_PointConversionRate'),
        (N'ETL_Points'),
        (N'ETL_PointsTransaction'),
        (N'ETL_Reservation'),
        (N'ETL_SeatDetail'),
        (N'ETL_ServiceOffering'),
        (N'ETL_ServiceOfferingItem'),
        (N'ETL_Technician'),
        (N'ETL_TravelClass'),
        (N'ETL_AirlineAirportService');

    DECLARE @ProcName NVARCHAR(128), @sql NVARCHAR(300);

    DECLARE proc_cursor CURSOR FOR SELECT ProcName FROM @procs;
    OPEN proc_cursor;
    FETCH NEXT FROM proc_cursor INTO @ProcName;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF OBJECT_ID(N'SA.' + @ProcName, 'P') IS NOT NULL
        BEGIN
            SET @sql = N'EXEC [SA].[' + @ProcName + N']';
            EXEC sp_executesql @sql;
        END
        FETCH NEXT FROM proc_cursor INTO @ProcName;
    END
    CLOSE proc_cursor;
    DEALLOCATE proc_cursor;
END
GO

EXEC [SA].[Main_ETL];
