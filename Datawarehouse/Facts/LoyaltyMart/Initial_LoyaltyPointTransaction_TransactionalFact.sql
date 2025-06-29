CREATE OR ALTER PROCEDURE [DW].[Initial_LoyaltyPoint_TransactionalFact]
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @StartDate date;
	DECLARE @EndDate date;

	SELECT
		@StartDate = MIN(CAST(TransactionDate AS DATE)),
		@EndDate = MAX(CAST(TransactionDate AS DATE))
	FROM
		[SA].[PointsTransaction];

	IF @StartDate IS NULL
	BEGIN
		RAISERROR('No loyalty transactions found. Exiting procedure.', 0, 1) WITH NOWAIT;
		RETURN;
	END

	DECLARE @CurrentDate date = @StartDate;

	WHILE @CurrentDate <= @EndDate
	BEGIN
		DECLARE @LogID BIGINT;
		DECLARE @StartTime DATETIME2(3) = SYSUTCDATETIME();
		DECLARE @RowCount INT;

		INSERT INTO DW.ETL_Log (ProcedureName, TargetTable, ChangeDescription, ActionTime, Status)
		VALUES ('Initial_LoyaltyPoint_TransactionalFact', 'LoyaltyPointTransaction_TransactionalFact', 'Procedure started for date: ' + CONVERT(varchar, @CurrentDate, 101), @StartTime, 'Running');

		SET @LogID = SCOPE_IDENTITY();

		BEGIN TRY
			DELETE FROM [DW].[LoyaltyPointTransaction_TransactionalFact]
			WHERE CAST([TransactionDateKey] AS DATE) = @CurrentDate;

			INSERT INTO [DW].[Temp_DailyLoyaltyTransactions]
			SELECT
                PointsTransactionID, AccountID, TransactionDate, LoyaltyTransactionTypeID,
                PointsChange, BalanceAfterTransaction, CurrencyValue, ConversionRate,
                PointConversionRateID, ServiceOfferingID, FlightDetailID
			FROM [SA].[PointsTransaction]
			WHERE CAST(TransactionDate AS DATE) = @CurrentDate;

			IF @@ROWCOUNT = 0
			BEGIN
				UPDATE DW.ETL_Log SET ChangeDescription = 'No loyalty transactions found for date: ' + CONVERT(varchar, @CurrentDate, 101), RowsAffected = 0, DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()), Status = 'Success' WHERE LogID = @LogID;
				SET @CurrentDate = DATEADD(day, 1, @CurrentDate);
				CONTINUE;
			END

			INSERT INTO [DW].[Temp_EnrichedLoyaltyData] (
                TransactionDateKey, PersonKey, AccountKey, LoyaltyTierKey, TransactionTypeKey,
                ConversionRateKey, FlightKey, ServiceOfferingKey, PointsChange, CurrencyValue,
                ConversionRateSnapshot, BalanceAfterTransaction
            )
			SELECT

				pt.TransactionDate,
				ISNULL(dp.PersonKey, -1),
				pt.AccountID,
				ISNULL(dlt.LoyaltyTierKey, -1),
				pt.LoyaltyTransactionTypeID,
				ISNULL(dcr.ConversionRateKey, -1),
				pt.FlightDetailID,
				ISNULL(dso.ServiceOfferingID, -1),
                pt.PointsChange,
                pt.CurrencyValue,
                ISNULL(dcr.Rate, 0),
                pt.BalanceAfterTransaction
			FROM [DW].[Temp_DailyLoyaltyTransactions] pt
			INNER JOIN [SA].[Account] acc ON pt.AccountID = acc.AccountID
			INNER JOIN [SA].[Passenger] pass ON acc.PassengerID = pass.PassengerID
			LEFT JOIN [DW].[DimPerson] dp ON pass.PersonID = dp.PersonID
				AND pt.TransactionDate >= dp.EffectiveFrom
				AND pt.TransactionDate < ISNULL(dp.EffectiveTo, '9999-12-31')
            LEFT JOIN [SA].[AccountTierHistory] ath ON pt.AccountID = ath.AccountID
                AND pt.TransactionDate >= ath.EffectiveFrom
                AND pt.TransactionDate < ISNULL(ath.EffectiveTo, '9999-12-31')
			LEFT JOIN [DW].[DimLoyaltyTier] dlt ON ath.LoyaltyTierID = dlt.LoyaltyTierID
				AND pt.TransactionDate >= dlt.EffectiveFrom
				AND pt.TransactionDate < ISNULL(dlt.EffectiveTo, '9999-12-31')
			LEFT JOIN [DW].[DimPointConversionRate] dcr ON pt.PointConversionRateID = dcr.PointConversionRateID
				AND pt.TransactionDate >= dcr.EffectiveFrom
				AND pt.TransactionDate < ISNULL(dcr.EffectiveTo, '9999-12-31')
			LEFT JOIN [DW].[DimServiceOffering] dso ON pt.ServiceOfferingID = dso.ServiceOfferingID;

			INSERT INTO [DW].[LoyaltyPointTransaction_TransactionalFact] (
                TransactionDateKey, PersonKey, AccountKey, LoyaltyTierKey, TransactionTypeKey,
                ConversionRateKey, FlightKey, ServiceOfferingKey, PointsEarned, PointsRedeemed,
                CurrencyValue, ConversionRateSnapshot, BalanceAfterTransaction
            )
			SELECT
				ed.TransactionDateKey, ed.PersonKey, ed.AccountKey, ed.LoyaltyTierKey, ed.TransactionTypeKey,
                ed.ConversionRateKey, ed.FlightKey, ed.ServiceOfferingKey,

                CASE WHEN ed.PointsChange > 0 THEN ed.PointsChange ELSE 0 END,
                CASE WHEN ed.PointsChange < 0 THEN ABS(ed.PointsChange) ELSE 0 END,

                ed.CurrencyValue,
                ed.ConversionRateSnapshot,
                ed.BalanceAfterTransaction
			FROM [DW].[Temp_EnrichedLoyaltyData] ed;

			SET @RowCount = @@ROWCOUNT;

			TRUNCATE TABLE [DW].[Temp_DailyLoyaltyTransactions];
			TRUNCATE TABLE [DW].[Temp_EnrichedLoyaltyData];

			UPDATE DW.ETL_Log SET ChangeDescription = 'Load complete for date: ' + CONVERT(varchar, @CurrentDate, 101), RowsAffected = @RowCount, DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()), Status = 'Success' WHERE LogID = @LogID;

		END TRY
		BEGIN CATCH
			DECLARE @ErrMsg NVARCHAR(MAX) = ERROR_MESSAGE();
			UPDATE DW.ETL_Log SET ChangeDescription = 'Load failed for date: ' + CONVERT(varchar, @CurrentDate, 101), DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()), Status = 'Error', Message = @ErrMsg WHERE LogID = @LogID;
			THROW;
		END CATCH

		SET @CurrentDate = DATEADD(day, 1, @CurrentDate);
	END;

	RAISERROR('Initial_LoyaltyPoint_TransactionalFact loading process has completed.', 0, 1) WITH NOWAIT;
	SET NOCOUNT OFF;
END
GO
