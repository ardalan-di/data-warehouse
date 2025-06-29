CREATE OR ALTER PROCEDURE [DW].[Load_PersonPointTransactions_ACCFact]
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @LogID BIGINT;
	DECLARE @StartTime DATETIME2(3) = SYSUTCDATETIME();
	DECLARE @RowCount INT;

	INSERT INTO DW.ETL_Log (ProcedureName, TargetTable, ChangeDescription, ActionTime, Status)
	VALUES ('Load_PersonPointTransactions_ACCFact', 'PersonPointTransactions_ACCFact', 'Procedure started for incremental merge', @StartTime, 'Running');

	SET @LogID = SCOPE_IDENTITY();

	BEGIN TRY

		MERGE [DW].[PersonPointTransactions_ACCFact] AS Target
		USING (

			SELECT
				current_person.PersonKey,
				lt.LoyaltyTierKey,
				agg.TotalPointsEarned,
				agg.TotalPointsRedeemed,
				agg.TotalPointsEarned - agg.TotalPointsRedeemed AS NetPointChange,
				agg.TotalPointValueUSD,
				agg.TotalNumberOfTransactions,
				agg.TotalDistinctFlightsEarnedOn
			FROM
			(
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
			) agg
			LEFT JOIN
			(
				SELECT
					historical_person.PersonID,
					fact.LoyaltyTierKey,
					ROW_NUMBER() OVER(PARTITION BY historical_person.PersonID ORDER BY fact.TransactionDateKey DESC) AS rn
				FROM
					[DW].[LoyaltyPointTransaction_TransactionalFact] fact
				INNER JOIN [DW].[DimPerson] historical_person ON fact.PersonKey = historical_person.PersonKey
			) lt ON agg.PersonID = lt.PersonID AND lt.rn = 1
			INNER JOIN
				[DW].[DimPerson] current_person ON agg.PersonID = current_person.PersonID AND current_person.EffectiveTo IS NULL
		) AS Source
		ON (Target.PersonKey = Source.PersonKey)

		WHEN MATCHED THEN
			UPDATE SET
				Target.LoyaltyTierKey = Source.LoyaltyTierKey,
				Target.TotalPointsEarned = Source.TotalPointsEarned,
				Target.TotalPointsRedeemed = Source.TotalPointsRedeemed,
				Target.NetPointChange = Source.NetPointChange,
				Target.TotalPointValueUSD = Source.TotalPointValueUSD,
				Target.TotalNumberOfTransactions = Source.TotalNumberOfTransactions,
				Target.TotalDistinctFlightsEarnedOn = Source.TotalDistinctFlightsEarnedOn

		WHEN NOT MATCHED BY TARGET THEN
			INSERT (
				PersonKey, LoyaltyTierKey, TotalPointsEarned, TotalPointsRedeemed, NetPointChange,
				TotalPointValueUSD, TotalNumberOfTransactions, TotalDistinctFlightsEarnedOn
			)
			VALUES (
				Source.PersonKey, Source.LoyaltyTierKey, Source.TotalPointsEarned, Source.TotalPointsRedeemed, Source.NetPointChange,
				Source.TotalPointValueUSD, Source.TotalNumberOfTransactions, Source.TotalDistinctFlightsEarnedOn
			);

		SET @RowCount = @@ROWCOUNT;

		UPDATE DW.ETL_Log SET ChangeDescription = 'Incremental merge complete', RowsAffected = @RowCount, DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()), Status = 'Success' WHERE LogID = @LogID;

	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg NVARCHAR(MAX) = ERROR_MESSAGE();
		UPDATE DW.ETL_Log SET ChangeDescription = 'Incremental merge failed', DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()), Status = 'Error', Message = @ErrMsg WHERE LogID = @LogID;
		THROW;
	END CATCH

	RAISERROR('PersonPointTransactions_ACCFact loading process has completed.', 0, 1) WITH NOWAIT;
	SET NOCOUNT OFF;
END
GO