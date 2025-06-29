CREATE OR ALTER PROCEDURE [DW].[Initial_PersonPointTransactions_MonthlyFact]
AS
BEGIN
	SET NOCOUNT ON;


	DECLARE @StartDate date;
	DECLARE @EndDate date;

	SELECT
		@StartDate = MIN(TransactionDateKey),
		@EndDate = MAX(TransactionDateKey)
	FROM
		[DW].[LoyaltyPointTransaction_TransactionalFact];

	IF @StartDate IS NULL
	BEGIN
		RAISERROR('No data found in LoyaltyPointTransaction_TransactionalFact to process.', 0, 1) WITH NOWAIT;
		RETURN;
	END

	DECLARE @CurrentMonthStart date = DATEFROMPARTS(YEAR(@StartDate), MONTH(@StartDate), 1);
	DECLARE @EndMonthStart date = DATEFROMPARTS(YEAR(@EndDate), MONTH(@EndDate), 1);

	WHILE @CurrentMonthStart <= @EndMonthStart
	BEGIN
		DECLARE @LogID BIGINT;
		DECLARE @StartTime DATETIME2(3) = SYSUTCDATETIME();
		DECLARE @RowCount INT;
        DECLARE @CurrentMonthEnd date = EOMONTH(@CurrentMonthStart);

		INSERT INTO DW.ETL_Log (ProcedureName, TargetTable, ChangeDescription, ActionTime, Status)
		VALUES ('Initial_PersonPointTransactions_MonthlyFact', 'PersonPointTransactions_MonthlyFact', 'Procedure started for month: ' + CONVERT(varchar, @CurrentMonthStart, 101), @StartTime, 'Running');

		SET @LogID = SCOPE_IDENTITY();

		BEGIN TRY
			WITH MonthlyAggregates AS (
				SELECT
					fact.PersonKey AS HistoricalPersonKey,
					fact.LoyaltyTierKey AS HistoricalLoyaltyTierKey,
					SUM(fact.PointsEarned) AS MonthlyPointsEarned,
					SUM(fact.PointsRedeemed) AS MonthlyPointsRedeemed,
                    SUM(fact.CurrencyValue) AS MonthlyPointValueUSD,
					COUNT(*) AS MonthlyNumberOfTransactions,
					COUNT(DISTINCT fact.FlightKey) AS MonthlyDistinctFlightsEarnedOn
				FROM
					[DW].[LoyaltyPointTransaction_TransactionalFact] fact
				WHERE
					fact.TransactionDateKey >= @CurrentMonthStart AND fact.TransactionDateKey <= @CurrentMonthEnd
				GROUP BY
					fact.PersonKey,
					fact.LoyaltyTierKey
			)
			INSERT INTO [DW].[PersonPointTransactions_MonthlyFact] (
				MonthID, PersonKey, LoyaltyTierKey, MonthlyPointsEarned, MonthlyPointsRedeemed,
				NetPointChange, MonthlyPointValueUSD, MonthlyNumberOfTransactions, MonthlyDistinctFlightsEarnedOn
			)
			SELECT
				@CurrentMonthStart,
				ISNULL(person_eom.PersonKey, -1),
                ISNULL(tier_eom.LoyaltyTierKey, -1),
				agg.MonthlyPointsEarned,
				agg.MonthlyPointsRedeemed,
				agg.MonthlyPointsEarned - agg.MonthlyPointsRedeemed,
				agg.MonthlyPointValueUSD,
				agg.MonthlyNumberOfTransactions,
				agg.MonthlyDistinctFlightsEarnedOn
			FROM
				MonthlyAggregates agg
			LEFT JOIN [DW].[DimPerson] historical_person ON agg.HistoricalPersonKey = historical_person.PersonKey
			LEFT JOIN [DW].[DimPerson] person_eom ON historical_person.PersonID = person_eom.PersonID
                AND @CurrentMonthEnd >= person_eom.EffectiveFrom
				AND @CurrentMonthEnd < ISNULL(person_eom.EffectiveTo, '9999-12-31')
            LEFT JOIN [DW].[DimLoyaltyTier] historical_tier ON agg.HistoricalLoyaltyTierKey = historical_tier.LoyaltyTierKey
            LEFT JOIN [DW].[DimLoyaltyTier] tier_eom ON historical_tier.LoyaltyTierID = tier_eom.LoyaltyTierID
                AND @CurrentMonthEnd >= tier_eom.EffectiveFrom
                AND @CurrentMonthEnd < ISNULL(tier_eom.EffectiveTo, '9999-12-31');

			SET @RowCount = @@ROWCOUNT;

			UPDATE DW.ETL_Log SET ChangeDescription = 'Load complete for month: ' + CONVERT(varchar, @CurrentMonthStart, 101), RowsAffected = @RowCount, DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()), Status = 'Success' WHERE LogID = @LogID;

		END TRY
		BEGIN CATCH
			DECLARE @ErrMsg NVARCHAR(MAX) = ERROR_MESSAGE();
			UPDATE DW.ETL_Log SET ChangeDescription = 'Load failed for month: ' + CONVERT(varchar, @CurrentMonthStart, 101), DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()), Status = 'Error', Message = @ErrMsg WHERE LogID = @LogID;
			THROW;
		END CATCH

		SET @CurrentMonthStart = DATEADD(month, 1, @CurrentMonthStart);
	END;

	RAISERROR('Initial PersonPointTransactions_MonthlyFact loading process has completed.', 0, 1) WITH NOWAIT;
	SET NOCOUNT OFF;
END
GO