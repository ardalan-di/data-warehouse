CREATE OR ALTER PROCEDURE [DW].[Load_PassengerTicket_TransactionalFact]
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @StartDate date;
	DECLARE @EndDate date;

    SELECT
        @EndDate = MAX(CAST(PaymentDateTime AS DATE))
    FROM
        [SA].[Payment]

    SELECT
        @StartDate = MAX(CAST(PaymentDateKey AS DATE))
    FROM
        [DW].[PassengerTicket_TransactionalFact]

	IF @StartDate IS NULL
	BEGIN
		RAISERROR('No completed payments found. Exiting procedure.', 0, 1) WITH NOWAIT;
		RETURN;
	END

	IF @StartDate >= @EndDate
	BEGIN
		RAISERROR('The PassengerTicket_TransactionalFact table is up to date!', 0, 1) WITH NOWAIT;
		RETURN;
	END

	DECLARE @CurrentDate date = @StartDate;

	WHILE @CurrentDate <= @EndDate
	BEGIN
		DECLARE @LogID BIGINT;
		DECLARE @StartTime DATETIME2(3) = SYSUTCDATETIME();
		DECLARE @RowCount INT;

		INSERT INTO DW.ETL_Log (ProcedureName, TargetTable, ChangeDescription, ActionTime, Status)
		VALUES ('Load_PassengerTicket_TransactionalFact', 'PassengerTicket_TransactionalFact', 'Procedure started for date: ' + CONVERT(varchar, @CurrentDate, 101), @StartTime, 'Running');

		SET @LogID = SCOPE_IDENTITY();

BEGIN TRY
			INSERT INTO [DW].[Temp_DailyPayments] (PaymentID, ReservationID, BuyerID, RealPrice, TicketPrice, Discount, Tax, PaymentDateTime, TicketHolderPassengerID, FlightDetailID, SeatDetailID)
			SELECT p.PaymentID, r.ReservationID, p.BuyerID, p.RealPrice, p.TicketPrice, p.Discount, p.Tax, p.PaymentDateTime, r.PassengerID, r.FlightDetailID, r.SeatDetailID
			FROM [SA].[Payment] p
			INNER JOIN [SA].[Reservation] r ON p.ReservationID = r.ReservationID
			WHERE CAST(p.PaymentDateTime AS DATE) = @CurrentDate;

			IF @@ROWCOUNT = 0
			BEGIN
				UPDATE DW.ETL_Log SET ChangeDescription = 'No payment data found for date: ' + CONVERT(varchar, @CurrentDate, 101), RowsAffected = 0, DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()), Status = 'Success' WHERE LogID = @LogID;
				SET @CurrentDate = DATEADD(day, 1, @CurrentDate);
				CONTINUE;
			END

			INSERT INTO [DW].[Temp_EnrichedFlightData] (PaymentID, FlightDateKey, FlightKey, AircraftKey, AirlineKey, SourceAirportKey, DestinationAirportKey, FlightClassPrice, FlightCost, KilometersFlown, TravelClassKey)
			SELECT dp.PaymentID, fd.DepartureDateTime, fd.FlightDetailID, ac.AircraftID, ac.AirlineID, fd.DepartureAirportID, fd.DestinationAirportID, tc.BaseCost,
			CASE WHEN ISNULL(fd.FlightCapacity, 0) > 0 THEN ISNULL(fd.TotalCost, 0) / fd.FlightCapacity ELSE 0 END,
			fd.DistanceKM,
                      tc.TravelClassID
			FROM [DW].[Temp_DailyPayments] dp
			INNER JOIN [SA].[FlightDetail] fd ON dp.FlightDetailID = fd.FlightDetailID
			INNER JOIN [SA].[Aircraft] ac ON fd.AircraftID = ac.AircraftID
			INNER JOIN [SA].[SeatDetail] sd ON dp.SeatDetailID = sd.SeatDetailID
			INNER JOIN [SA].[TravelClass] tc ON sd.TravelClassID = tc.TravelClassID;

			INSERT INTO [DW].[Temp_EnrichedPersonData] (PaymentID, BuyerPersonKey, TicketHolderPersonKey)
			SELECT
				dp.PaymentID,
				BuyerDim.PersonKey,
				TicketHolderDim.PersonKey
			FROM
				[DW].[Temp_DailyPayments] dp
			INNER JOIN [SA].[Passenger] BuyerPassenger ON dp.BuyerID = BuyerPassenger.PassengerID
			INNER JOIN [DW].[DimPerson] BuyerDim ON BuyerPassenger.PersonID = BuyerDim.PersonID
				AND dp.PaymentDateTime >= BuyerDim.EffectiveFrom
				AND dp.PaymentDateTime < ISNULL(BuyerDim.EffectiveTo, '9999-12-31')
			INNER JOIN [SA].[Passenger] TicketHolderPassenger ON dp.TicketHolderPassengerID = TicketHolderPassenger.PassengerID
			INNER JOIN [DW].[DimPerson] TicketHolderDim ON TicketHolderPassenger.PersonID = TicketHolderDim.PersonID
				AND dp.PaymentDateTime >= TicketHolderDim.EffectiveFrom
				AND dp.PaymentDateTime < ISNULL(TicketHolderDim.EffectiveTo, '9999-12-31');

			INSERT INTO [DW].[PassengerTicket_TransactionalFact] ([PaymentDateKey], [FlightDateKey], [BuyerPersonKey], [TicketHolderPersonKey], [PaymentKey], [FlightKey], [AircraftKey], [AirlineKey], [SourceAirportKey], [DestinationAirportKey], [TravelClassKey], [TicketRealPrice], [TaxAmount], [DiscountAmount], [TicketPrice], [FlightCost], [FlightClassPrice], [FlightRevenue], [KilometersFlown])
			SELECT
				dp.PaymentDateTime, fd.FlightDateKey, pd.BuyerPersonKey, pd.TicketHolderPersonKey,
				dp.PaymentID, fd.FlightKey, fd.AircraftKey, fd.AirlineKey, fd.SourceAirportKey,
				fd.DestinationAirportKey, fd.TravelClassKey,
				ISNULL(dp.RealPrice, 0),
				ISNULL(dp.TicketPrice, 0) * (ISNULL(dp.Tax, 0) / 100.0),
				ISNULL(dp.Discount, 0),
				ISNULL(dp.TicketPrice, 0),
				ISNULL(fd.FlightCost, 0),
				ISNULL(fd.FlightClassPrice, 0),
				ISNULL(dp.TicketPrice, 0) - ISNULL(fd.FlightCost, 0),
				ISNULL(fd.KilometersFlown, 0)
			FROM
				[DW].[Temp_DailyPayments] dp
			INNER JOIN
				[DW].[Temp_EnrichedFlightData] fd ON dp.PaymentID = fd.PaymentID
			INNER JOIN
				[DW].[Temp_EnrichedPersonData] pd ON dp.PaymentID = pd.PaymentID;

			SET @RowCount = @@ROWCOUNT;

			TRUNCATE TABLE [DW].[Temp_DailyPayments];
			TRUNCATE TABLE [DW].[Temp_EnrichedFlightData];
			TRUNCATE TABLE [DW].[Temp_EnrichedPersonData];

			UPDATE DW.ETL_Log SET ChangeDescription = 'Load complete for date: ' + CONVERT(varchar, @CurrentDate, 101), RowsAffected = @RowCount, DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()), Status = 'Success' WHERE LogID = @LogID;

		END TRY
		BEGIN CATCH
			DECLARE @ErrMsg NVARCHAR(MAX) = ERROR_MESSAGE();
			UPDATE DW.ETL_Log SET ChangeDescription = 'Load failed for date: ' + CONVERT(varchar, @CurrentDate, 101), DurationSec = DATEDIFF(SECOND, @StartTime, SYSUTCDATETIME()), Status = 'Error', Message = @ErrMsg WHERE LogID = @LogID;
			THROW;
		END CATCH

		SET @CurrentDate = DATEADD(day, 1, @CurrentDate);
	END;

	RAISERROR('PassengerTicket_TransactionalFact table loading process has completed.', 0, 1) WITH NOWAIT;
	SET NOCOUNT OFF;
END
GO
