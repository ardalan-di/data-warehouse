CREATE OR ALTER PROCEDURE [DW].[Initial_PersonPointTransactions_ACCFact]
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @LogID BIGINT;
	DECLARE @StartTime DATETIME2(3) = SYSUTCDATETIME();
	DECLARE @RowCount INT;

	INSERT INTO DW.ETL_Log (ProcedureName, TargetTable, ChangeDescription, ActionTime, Status)
	VALUES ('Initial_PersonPointTransactions_ACCFact', 'PersonPointTransactions_ACCFact', 'Procedure started for initial full load', @StartTime, 'Running');

	SET @LogID = SCOPE_IDENTITY();

	BEGIN TRY

		WITH LifetimeAggregates AS (
			SELECT
				historical_person.PersonID,
				SUM(fact.PointsEarned) AS TotalPointsEarned,
				SUM(fact.PointsRedeemed) AS TotalPointsRedeemed,
                SUM(fact.CurrencyValue) AS TotalPointValueUSD,
				COUNT(*) AS TotalNumberOfTransactions,
				COUNT(DISTINCT fact.FlightKey) AS TotalDistinctFlightsEarnedOn
			FROM
				[DW].[LoyaltyPointTransaction_TransactionalFact] fact
			INNER JOIN [DW].[DimPerson] historical_person ON fact.PersonKey = historical_person.PersonKey
			GROUP BY
				historical_person.PersonID
		),
        LatestTier AS (
            SELECT
                historical_person.PersonID,
                fact.LoyaltyTierKey,
                ROW_NUMBER() OVER(PARTITION BY historical_person.PersonID ORDER BY fact.TransactionDateKey DESC) AS rn
            FROM
                [DW].[LoyaltyPointTransaction_TransactionalFact] fact
            INNER JOIN [DW].[DimPerson] historical_person ON fact.PersonKey = historical_person.PersonKey
        )
		INSERT INTO [DW].[PersonPointTransactions_ACCFact] (
			PersonKey, LoyaltyTierKey, TotalPointsEarned, TotalPointsRedeemed, NetPointChange,
			TotalPointValueUSD, TotalNumberOfTransactions, TotalDistinctFlightsEarnedOn
		)
		SELECT
			current_person.PersonKey,
            lt.LoyaltyTierKey,
			agg.TotalPointsEarned,
			agg.TotalPointsRedeemed,
			agg.TotalPointsEarned - agg.TotalPointsRedeemed,
			agg.TotalPointValueUSD,
			agg.TotalNumberOfTransactions,
			agg.TotalDistinctFlightsEarnedOn
		FROM
			LifetimeAggregates agg
        LEFT JOIN LatestTier lt ON agg.PersonID = lt.PersonID AND lt.rn = 1
        INNER JOIN [DW].[DimPerson] current_person ON agg.PersonID = current_person.PersonID AND current_person.EffectiveTo IS NULL;

		SET @RowCount = @@ROWCOUNT;

		UPDATE DW.ETL_Log SET ChangeDescription = 'Initial full load complete', RowsAffected = @RowCount, DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()), Status = 'Success' WHERE LogID = @LogID;

	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg NVARCHAR(MAX) = ERROR_MESSAGE();
		UPDATE DW.ETL_Log SET ChangeDescription = 'Initial full load failed', DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()), Status = 'Error', Message = @ErrMsg WHERE LogID = @LogID;
		THROW;
	END CATCH

	RAISERROR('Initial PersonPointTransactions_ACCFact loading process has completed.', 0, 1) WITH NOWAIT;
	SET NOCOUNT OFF;
END
GO