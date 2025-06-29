CREATE OR ALTER PROCEDURE [DW].[Initial_DateTime_Dim]
AS
BEGIN

	TRUNCATE TABLE [DW].[DimDateTime];

    WITH TimeCTE AS (
        SELECT CAST('00:00' AS TIME) AS TimeValue
        UNION ALL
        SELECT DATEADD(minute, 1, TimeValue)
        FROM TimeCTE
        WHERE TimeValue < CAST('23:59' AS TIME)
    )
    SELECT
        TimeValue,
        DATEPART(hour, TimeValue) AS HourValue,
        DATEPART(minute, TimeValue) AS MinuteValue
    INTO #TimeDimension
    FROM TimeCTE
    OPTION (MAXRECURSION 0);

    DECLARE @CurrentMonthStart DATE;
    DECLARE @EndDate DATE;

    SELECT
        @CurrentMonthStart = MIN(FullDateAlternateKey),
        @EndDate = MAX(FullDateAlternateKey)
    FROM
        [DW].[DimDate]


    WHILE @CurrentMonthStart <= @EndDate
    BEGIN

        DECLARE @CurrentMonthEnd DATE = EOMONTH(@CurrentMonthStart);
		PRINT 'Processing month starting: ' + CONVERT(varchar, @CurrentMonthStart, 120);

        INSERT INTO [DW].[DimDateTime] (
            [DateTimeKey],
            [FullDateAlternateKey], [PersianFullDateAlternateKey], [DayNumberOfWeek], [PersianDayNumberOfWeek],
            [EnglishDayNameOfWeek], [PersianDayNameOfWeek], [DayNumberOfMonth], [PersianDayNumberOfMonth],
            [DayNumberOfYear], [PersianDayNumberOfYear], [WeekNumberOfYear], [PersianWeekNumberOfYear],
            [EnglishMonthName], [PersianMonthName], [MonthNumberOfYear], [PersianMonthNumberOfYear],
            [CalendarQuarter], [PersianCalendarQuarter], [CalendarYear], [PersianCalendarYear],
            [CalendarSemester], [PersianCalendarSemester],
            [Time], [Hour], [Minute]
        )
        SELECT
            CAST(d.[FullDateAlternateKey] AS DATETIME) + CAST(t.TimeValue AS DATETIME),

            d.[FullDateAlternateKey], d.[PersianFullDateAlternateKey], d.[DayNumberOfWeek], d.[PersianDayNumberOfWeek],
            d.[EnglishDayNameOfWeek], d.[PersianDayNameOfWeek], d.[DayNumberOfMonth], d.[PersianDayNumberOfMonth],
            d.[DayNumberOfYear], d.[PersianDayNumberOfYear], d.[WeekNumberOfYear], d.[PersianWeekNumberOfYear],
            d.[EnglishMonthName], d.[PersianMonthName], d.[MonthNumberOfYear], d.[PersianMonthNumberOfYear],
            d.[CalendarQuarter], d.[PersianCalendarQuarter], d.[CalendarYear], d.[PersianCalendarYear],
            d.[CalendarSemester], d.[PersianCalendarSemester],

            t.TimeValue,
            t.HourValue,
            t.MinuteValue
        FROM
            [DW].[DimDate] d
        CROSS JOIN
            #TimeDimension t
        WHERE

            d.FullDateAlternateKey >= @CurrentMonthStart AND d.FullDateAlternateKey <= @CurrentMonthEnd;

        SET @CurrentMonthStart = DATEADD(month, 1, @CurrentMonthStart);
    END

    DROP TABLE #TimeDimension;
END;
GO
