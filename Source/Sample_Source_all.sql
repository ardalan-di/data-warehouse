
INSERT INTO Source.Airline
  (AirlineID, Name, Country, FoundedDate, HeadquartersNumber, FleetSize, Website, Current_IATA_Code) VALUES
(1, 'Emirates',           'UAE',       '1985-03-25', '+97143179999', 269, 'www.emirates.com',       'EK'),
(2, 'Lufthansa',          'Germany',   '1953-01-06', '+496922960',   316, 'www.lufthansa.com',      'LH'),
(3, 'British Airways',    'UK',        '1974-04-01', '+44344800780', 281, 'www.britishairways.com', 'BA'),
(4, 'Air France',         'France',    '1933-10-07', '+33142725656', 213, 'www.airfrance.com',      'AF'),
(5, 'Qatar Airways',      'Qatar',     '1993-11-22', '+97440222000', 234, 'www.qatarairways.com',   'QR'),
(6, 'Singapore Airlines', 'Singapore', '1947-05-01', '+6562218888',  152, 'www.singaporeair.com',   'SQ'),
(7, 'Turkish Airlines',   'Turkey',    '1933-05-20', '+902124631818',370, 'www.turkishairlines.com','TK'),
(8, 'ANA',                'Japan',     '1952-12-27', '+81367351111', 213, 'www.ana.co.jp',          'NH'),
(9, 'Delta Air Lines',    'USA',       '1924-05-30', '+18002212146', 957, 'www.delta.com',          'DL'),
(10,'Qantas',             'Australia', '1920-11-16', '+61296919691', 126, 'www.qantas.com',         'QF');



INSERT INTO Source.Airport (AirportID, City, Country, IATACode, ElevationMeter, TimeZone, NumberOfTerminals, AnnualPassengerTraffic, Latitude, Longitude, ManagerName) VALUES
(1, 'Dubai', 'UAE', 'DXB', 19, 'GMT+4', 3, 86390000, 25.252778, 55.364444, 'Paul Griffiths'),
(2, 'London', 'UK', 'LHR', 25, 'GMT+0', 5, 80500000, 51.477500, -0.461389, 'John Holland-Kaye'),
(3, 'New York', 'USA', 'JFK', 4, 'GMT-5', 6, 61900000, 40.639722, -73.778889, 'Rick Cotton'),
(4, 'Paris', 'France', 'CDG', 119, 'GMT+1', 3, 76150000, 49.009722, 2.547778, 'Augustin de Romanet'),
(5, 'Tokyo', 'Japan', 'HND', 11, 'GMT+9', 3, 87900000, 35.552258, 139.779694, 'Shinichi Inoue'),
(6, 'Singapore', 'Singapore', 'SIN', 7, 'GMT+8', 4, 62100000, 1.359167, 103.989444, 'Lee Seow Hiang'),
(7, 'Istanbul', 'Turkey', 'IST', 99, 'GMT+3', 2, 52000000, 41.275278, 28.751944, 'Kadri Samsunlu'),
(8, 'Frankfurt', 'Germany', 'FRA', 111, 'GMT+1', 2, 70560000, 50.037933, 8.562150, 'Stefan Schulte'),
(9, 'Sydney', 'Australia', 'SYD', 6, 'GMT+11', 3, 44200000, -33.939922, 151.175276, 'Geoff Culbert'),
(10, 'Doha', 'Qatar', 'DOH', 11, 'GMT+3', 1, 38000000, 25.260556, 51.613889, 'Badr Mohammed Al-Meer'),
(11, 'Amsterdam', 'Netherlands', 'AMS', -3, 'GMT+1', 1, 71530000, 52.308056, 4.764167, 'Dick Benschop'),
(12, 'Seoul', 'South Korea', 'ICN', 7, 'GMT+9', 2, 71170000, 37.460192, 126.440695, 'Son Chang-Hwan'),
(13, 'Hong Kong', 'China', 'HKG', 8, 'GMT+8', 2, 71540000, 22.308889, 113.914722, 'Fred Lam'),
(14, 'Bangkok', 'Thailand', 'BKK', 2, 'GMT+7', 3, 65000000, 13.681108, 100.747283, 'Nitinai Sirismatthakarn'),
(15, 'Rome', 'Italy', 'FCO', 15, 'GMT+1', 3, 43200000, 41.804475, 12.250797, 'Marco Troncone');


INSERT INTO Source.Person (PersonID, NatCode, Name, Phone, Email, Address, City, Country, DateOfBirth, Gender, PostalCode) VALUES
(1, 'A123456', 'John Smith', '+447700123456', 'john.smith@email.com', '123 Oxford St', 'London', 'UK', '1985-07-15', 'Male', 'W1D 1AB'),
(2, 'B789012', 'Emma Johnson', '+14165551234', 'emma.j@email.com', '456 5th Ave', 'New York', 'USA', '1990-12-22', 'Female', '10018'),
(3, 'C345678', 'Mohammed Ali', '+971501234567', 'm.ali@email.com', '789 Sheikh Zayed Rd', 'Dubai', 'UAE', '1978-03-10', 'Male', '12345'),
(4, 'D901234', 'Sophie Martin', '+33612345678', 'sophie.m@email.com', '101 Champs-Élysées', 'Paris', 'France', '1995-08-30', 'Female', '75008'),
(5, 'E567890', 'Thomas Müller', '+491701234567', 't.mueller@email.com', '202 Friedrichstr', 'Berlin', 'Germany', '1982-11-05', 'Male', '10117'),
(6, 'F112233', 'Yuki Tanaka', '+81345678901', 'y.tanaka@email.com', '303 Shinjuku', 'Tokyo', 'Japan', '1992-04-18', 'Female', '160-0022'),
(7, 'G445566', 'Liam Brown', '+61234567890', 'liam.b@email.com', '404 George St', 'Sydney', 'Australia', '1988-09-12', 'Male', '2000'),
(8, 'H778899', 'Aisha Khan', '+923001234567', 'a.khan@email.com', '505 Jinnah Ave', 'Islamabad', 'Pakistan', '1993-01-25', 'Female', '44000'),
(9, 'I001122', 'Carlos Rodriguez', '+525512345678', 'c.rod@email.com', '606 Reforma', 'Mexico City', 'Mexico', '1980-06-08', 'Male', '06500'),
(10, 'J334455', 'Anna Petrova', '+74951234567', 'a.petrova@email.com', '707 Tverskaya St', 'Moscow', 'Russia', '1991-02-14', 'Female', '125009'),
(11, 'K667788', 'David Wilson', '+447500987654', 'd.wilson@email.com', '808 Regent St', 'London', 'UK', '1987-10-03', 'Male', 'W1B 2AG'),
(12, 'L990011', 'Maria Garcia', '+34911234567', 'm.garcia@email.com', '909 Gran Vía', 'Madrid', 'Spain', '1994-07-19', 'Female', '28013'),
(13, 'M223344', 'James Lee', '+16505551234', 'j.lee@email.com', '111 Market St', 'San Francisco', 'USA', '1983-12-01', 'Male', '94105'),
(14, 'N556677', 'Fatima Zahra', '+212600123456', 'f.zahra@email.com', '222 Hassan II', 'Casablanca', 'Morocco', '1996-05-27', 'Female', '20000'),
(15, 'O889900', 'Wei Chen', '+8613912345678', 'w.chen@email.com', '333 Nanjing Rd', 'Shanghai', 'China', '1989-08-15', 'Male', '200001'),
(16, 'P112233', 'Sofia Costa', '+551112345678', 's.costa@email.com', '444 Paulista Ave', 'São Paulo', 'Brazil', '1997-03-22', 'Female', '01310'),
(17, 'Q445566', 'Oliver Taylor', '+447600112233', 'o.taylor@email.com', '555 Piccadilly', 'London', 'UK', '1984-11-11', 'Male', 'W1J 9BR'),
(18, 'R778899', 'Chloe Dubois', '+33123456789', 'c.dubois@email.com', '666 Rue de Rivoli', 'Paris', 'France', '1990-04-05', 'Female', '75001'),
(19, 'S001122', 'Benjamin Kim', '+82212345678', 'b.kim@email.com', '777 Gangnam-gu', 'Seoul', 'South Korea', '1986-09-17', 'Male', '06164'),
(20, 'T334455', 'Isabella Rossi', '+390612345678', 'i.rossi@email.com', '888 Via Veneto', 'Rome', 'Italy', '1993-06-30', 'Female', '00187');

INSERT INTO Source.LoyaltyTier (LoyaltyTierID, Name, MinPoints, Benefits) VALUES
(1, 'Basic', 0, 'Basic services'),
(2, 'Silver', 10000, 'Priority check-in, free seat selection'),
(3, 'Gold', 50000, 'Lounge access, extra baggage'),
(4, 'Platinum', 100000, 'First class upgrades, dedicated support');


INSERT INTO Source.LoyaltyTransactionType (LoyaltyTransactionTypeID, TypeName) VALUES
(1, 'Earn'),
(2, 'Redeem'),
(3, 'Expire'),
(4, 'Adjust'),
(5, 'Bonus');


INSERT INTO Source.PointConversionRate (PointConversionRateID, ConversionRate, CurrencyCode) VALUES
(1, 0.010000, 'USD'),
(2, 0.012500, 'CA'),
(3, 0.013000, 'UK');


INSERT INTO [Source].[PointsTransaction]
(PointsTransactionID, AccountID, TransactionDate, LoyaltyTransactionTypeID, PointsChange, BalanceAfterTransaction, CurrencyValue, ConversionRate, PointConversionRateID, Description, ServiceOfferingID, FlightDetailID)
VALUES
(1, 1, '2014-05-01', 1, 500.00, 5500.00, 5.00, 0.01, 1, 'Flight Booking', 1, 1),
(2, 2, '2014-05-02', 1, 850.00, 15850.00, 8.50, 0.01, 1, 'Flight Booking', 2, 1),
(3, 3, '2014-05-03', 1, 1200.00, 76200.00, 12.00, 0.01, 1, 'Flight Booking', 3, 2),
(4, 4, '2014-05-04', 1, 780.00, 3780.00, 7.80, 0.01, 1, 'Flight Booking', 1, 3),
(5, 5, '2014-05-05', 2, -200.00, 24800.00, -2.00, 0.01, 1, 'Seat Upgrade', 9, 4),
(6, 6, '2014-05-06', 1, 950.00, 120950.00, 9.50, 0.01, 1, 'Flight Booking', 4, 5),
(7, 7, '2014-05-07', 1, 1100.00, 9100.00, 11.00, 0.01, 1, 'Flight Booking', 5, 6),
(8, 8, '2014-05-08', 1, 2200.00, 67200.00, 22.00, 0.01, 1, 'Flight Booking', 6, 7),
(9, 9, '2014-05-09', 3, -1500.00, 33500.00, -15.00, 0.01, 1, 'Points Expiration', NULL, 8),
(10, 10, '2014-05-10', 1, 890.00, 2890.00, 8.90, 0.01, 1, 'Flight Booking', 7, 9),

(11, 11, '2014-05-11', 1, 1300.00, 111300.00, 13.00, 0.0125, 2, 'Flight Booking', 8, 10),
(12, 12, '2014-05-12', 1, 1050.00, 5050.00, 10.50, 0.0125, 2, 'Flight Booking', 9, 11),
(13, 13, '2014-05-13', 1, 1950.00, 19950.00, 19.50, 0.0125, 2, 'Flight Booking', 10, 12),
(14, 14, '2014-05-14', 2, -300.00, 6700.00, -3.00, 0.0125, 2, 'Extra Baggage', 4, 13),
(15, 15, '2014-05-15', 1, 1700.00, 86700.00, 17.00, 0.0125, 2, 'Flight Booking', 1, 14),

(16, 1, '2014-05-16', 2, -100.00, 5400.00, -1.00, 0.013, 3, 'Meal Upgrade', 2, 1),
(17, 2, '2014-05-17', 4, 50.00, 15900.00, 0.50, 0.013, 3, 'Correction', NULL, 2),
(18, 3, '2014-05-18', 2, -500.00, 75700.00, -5.00, 0.013, 3, 'Lounge Access', 6, 3),
(19, 4, '2014-05-19', 1, 200.00, 3980.00, 2.00, 0.013, 3, 'Referral Bonus', NULL, 4),
(20, 5, '2014-05-20', 3, -100.00, 24700.00, -1.00, 0.013, 3, 'Points Expiration', NULL, 5);


INSERT INTO [Source].[TravelClass] (TravelClassID, ClassName, Capacity, BaseCost) VALUES
(1, 'Economy', 300, 150.00),
(2, 'Premium Economy', 60, 400.00),
(3, 'Business', 40, 1200.00),
(4, 'First Class', 12, 4000.00);



INSERT INTO Source.Aircraft (AircraftID, Model, Type, ManufacturerDate, Capacity, Price, AirlineID) VALUES
(1, 'Boeing 777-300ER', 'Wide-body', '2015-01-15', 396, 320000000.00, 1),
(2, 'Airbus A380', 'Wide-body', '2014-03-20', 517, 445000000.00, 1),
(3, 'Boeing 747-8', 'Wide-body', '2016-05-10', 364, 379000000.00, 2),
(4, 'Airbus A350-900', 'Wide-body', '2018-07-22', 315, 317000000.00, 3),
(5, 'Boeing 787-9', 'Wide-body', '2011-02-18', 290, 281000000.00, 4),
(6, 'Airbus A320neo', 'Narrow-body', '2013-11-05', 180, 110000000.00, 5),
(7, 'Boeing 737 MAX', 'Narrow-body', '2010-04-30', 178, 121000000.00, 6),
(8, 'Embraer E195', 'Regional', '2009-08-12', 120, 52000000.00, 7),
(9, 'Airbus A330-900', 'Wide-body', '2011-09-25', 287, 296000000.00, 8),
(10, 'Boeing 777-200LR', 'Wide-body', '2015-12-03', 301, 346000000.00, 9),
(11, 'Airbus A321XLR', 'Narrow-body', '2012-01-10', 180, 135000000.00, 10),
(12, 'Boeing 787-10', 'Wide-body', '2013-06-15', 330, 338000000.00, 1);


INSERT INTO Source.Passenger (PassengerID, PersonID, PassportNumber) VALUES
(1, 1, 'P12345678'),
(2, 2, 'P87654321'),
(3, 3, 'P11223344'),
(4, 4, 'P55667788'),
(5, 5, 'P99001122'),
(6, 6, 'P33445566'),
(7, 7, 'P77889900'),
(8, 8, 'P22334455'),
(9, 9, 'P66778899'),
(10, 10, 'P00112233'),
(11, 11, 'P44556677'),
(12, 12, 'P88990011'),
(13, 13, 'P23456789'),
(14, 14, 'P98765432'),
(15, 15, 'P55544433');



INSERT INTO Source.Account (AccountID, PassengerID, RegistrationDate, LoyaltyTierID) VALUES
(1, 1, '2013-01-15', 1),
(2, 2, '2011-05-20', 2),
(3, 3, '2010-03-10', 3),
(4, 4, '2018-07-22', 1),
(5, 5, '2012-02-18', 2),
(6, 6, '2013-11-05', 4),
(7, 7, '2011-04-30', 1),
(8, 8, '2010-08-12', 3),
(9, 9, '2009-09-25', 2),
(10, 10, '2015-12-03', 1),
(11, 11, '2014-01-10', 4),
(12, 12, '2013-06-15', 1),
(13, 13, '2011-11-11', 2),
(14, 14, '2012-07-19', 1),
(15, 15, '2010-05-27', 3);


INSERT INTO Source.Points (PointsID, AccountID, PointsBalance, EffectiveDate) VALUES
(1, 1, 5000.00, '2014-01-01'),
(2, 2, 15000.00, '2014-01-01'),
(3, 3, 75000.00, '2014-01-01'),
(4, 4, 3000.00, '2014-01-01'),
(5, 5, 25000.00, '2014-01-01'),
(6, 6, 120000.00, '2014-01-01'),
(7, 7, 8000.00, '2014-01-01'),
(8, 8, 65000.00, '2014-01-01'),
(9, 9, 35000.00, '2014-01-01'),
(10, 10, 2000.00, '2014-01-01'),
(11, 11, 110000.00, '2014-01-01'),
(12, 12, 4000.00, '2014-01-01'),
(13, 13, 18000.00, '2014-01-01'),
(14, 14, 7000.00, '2014-01-01'),
(15, 15, 85000.00, '2014-01-01');


INSERT INTO Source.ServiceOffering (ServiceOfferingID, TravelClassID, OfferingName, Description, TotalCost) VALUES
(1, 1, 'Standard Meal', 'Basic meal for Economy Class', 15.00),
(2, 2, 'Premium Meal', 'Premium meal for Premium Economy', 30.00),
(3, 3, 'Gourmet Meal', 'Gourmet meal for Business Class', 60.00),
(4, NULL, 'Extra Baggage (23kg)', 'Add-on baggage for all classes', 50.00),
(5, NULL, 'Priority Boarding', 'Skip the queue at boarding', 20.00),
(6, NULL, 'Lounge Access', 'Access to business lounges', 60.00),
(7, 4, 'Chauffeur Service', 'Limousine transfer for First Class', 100.00),
(8, 1, 'Seat Selection', 'Preferred seat booking', 10.00),
(9, 2, 'Advanced Seat Selection', 'Advanced seat for Premium Economy', 25.00),
(10, 3, 'Flat Bed Setup', 'Business Class flat bed', 0.00);


INSERT INTO Source.Item (ItemID, ItemName, Description, BasePrice, IsLoyaltyRedeemable) VALUES
(1, 'Water Bottle', '500ml bottled water', 2.00, 1),
(2, 'Snack Pack', 'Assorted snacks', 5.00, 1),
(3, 'Headphones', 'Noise-cancelling headphones', 15.00, 0),
(4, 'Blanket', 'Soft travel blanket', 10.00, 1),
(5, 'Travel Pillow', 'Memory foam pillow', 12.00, 1),
(6, 'Magazine', 'Travel magazine', 4.00, 0),
(7, 'Wi-Fi Pass', 'In-flight internet', 20.00, 1),
(8, 'Meal Upgrade', 'Premium meal upgrade', 25.00, 1),
(9, 'Gift Voucher', 'Onboard gift voucher', 50.00, 1),
(10, 'Kids Pack', 'Children’s entertainment kit', 8.00, 1);

INSERT INTO Source.ServiceOfferingItem (ServiceOfferingID, ItemID, Quantity) VALUES
(1, 1, 1),
(1, 2, 1),
(2, 1, 1),
(2, 8, 1),
(3, 1, 1),
(3, 3, 1),
(4, 4, 2),
(5, 5, 1),
(6, 6, 1),
(7, 7, 1);


INSERT INTO Source.FlightDetail (FlightDetailID, DepartureAirportID, DestinationAirportID, DistanceKM, DepartureDateTime, ArrivalDateTime, AircraftID, FlightCapacity, TotalCost) VALUES
(1, 1, 2, 200, '2014-06-01 08:00:00', '2014-06-01 12:00:00', 1, 396, 50000.00),
(2, 2, 3, 300, '2014-06-01 14:00:00', '2014-06-01 18:30:00', 3, 364, 45000.00),
(3, 3, 4, 400, '2014-06-02 09:00:00', '2014-06-02 15:00:00', 5, 290, 48000.00),
(4, 4, 5, 500, '2014-06-02 11:00:00', '2014-06-02 20:00:00', 7, 178, 42000.00),
(5, 5, 1, 300, '2014-06-03 10:00:00', '2014-06-03 16:00:00', 9, 287, 46000.00),
(6, 6, 7, 700, '2014-06-03 13:00:00', '2014-06-03 17:30:00', 11, 180, 38000.00),
(7, 7, 8, 1000, '2014-06-04 07:00:00', '2014-06-04 10:00:00', 2, 517, 52000.00),
(8, 8, 9, 900, '2014-06-04 15:00:00', '2014-06-04 22:00:00', 4, 315, 55000.00),
(9, 9, 10, 800, '2014-06-05 12:00:00', '2014-06-05 18:00:00', 6, 180, 40000.00),
(10, 10, 6, 500, '2014-06-05 16:00:00', '2014-06-06 06:00:00', 8, 120, 35000.00),
(11, 11, 12, 400, '2014-06-06 09:30:00', '2014-06-06 13:00:00', 10, 301, 44000.00),
(12, 12, 13, 200, '2014-06-06 14:00:00', '2014-06-06 18:45:00', 12, 330, 47000.00),
(13, 13, 14, 300, '2014-06-07 08:45:00', '2014-06-07 12:15:00', 1, 396, 41000.00),
(14, 14, 15, 400, '2014-06-07 11:30:00', '2014-06-07 16:00:00', 3, 364, 43000.00),
(15, 15, 11, 500, '2014-06-08 10:15:00', '2014-06-08 14:30:00', 5, 290, 39000.00);


INSERT INTO Source.SeatDetail (SeatDetailID, AircraftID, SeatNo, SeatType, TravelClassID, ReservationID) VALUES
(1, 1, 1, 'Window', 1, NULL),
(2, 1, 2, 'Aisle', 1, NULL),
(3, 1, 3, 'Window', 2, NULL),
(4, 1, 4, 'Aisle', 2, NULL),
(5, 1, 5, 'Window', 3, NULL),
(6, 1, 6, 'Aisle', 3, NULL),
(7, 1, 7, 'Suite', 4, NULL),
(8, 2, 1, 'Window', 1, NULL),
(9, 2, 2, 'Aisle', 1, NULL),
(10, 2, 3, 'Window', 2, NULL),
(11, 3, 1, 'Aisle', 1, NULL),
(12, 3, 2, 'Window', 1, NULL),
(13, 4, 1, 'Aisle', 1, NULL),
(14, 5, 1, 'Window', 1, NULL),
(15, 6, 1, 'Aisle', 1, NULL),
(16, 7, 1, 'Window', 1, NULL),
(17, 8, 1, 'Aisle', 1, NULL),
(18, 9, 1, 'Window', 1, NULL),
(19, 10, 1, 'Aisle', 1, NULL),
(20, 11, 1, 'Window', 1, NULL);


INSERT INTO Source.Reservation (ReservationID, PassengerID, FlightDetailID, ReservationDate, SeatDetailID, Status) VALUES
(1, 1, 1, '2014-05-01', 1, 'Booked'),
(2, 2, 1, '2014-05-02', 2, 'Booked'),
(3, 3, 2, '2014-05-03', 11, 'Booked'),
(4, 4, 3, '2014-05-04', 13, 'Booked'),
(5, 5, 4, '2014-05-05', 14, 'Cancelled'),
(6, 6, 5, '2014-05-06', 15, 'Booked'),
(7, 7, 6, '2014-05-07', 16, 'Booked'),
(8, 8, 7, '2014-05-08', 17, 'Booked'),
(9, 9, 8, '2014-05-09', 18, 'Cancelled'),
(10, 10, 9, '2014-05-10', 19, 'Booked'),
(11, 11, 10, '2014-05-11', 20, 'Booked'),
(12, 12, 11, '2014-05-12', 3, 'Booked'),
(13, 13, 12, '2014-05-13', 4, 'Booked'),
(14, 14, 13, '2014-05-14', 5, 'Booked'),
(15, 15, 14, '2014-05-15', 6, 'Booked');


INSERT INTO Source.Payment (PaymentID, ReservationID, BuyerID, Status, TicketPrice, RealPrice, Discount, Tax, Method, PaymentDateTime) VALUES
(1, 1, 2, 'Completed', 450.00, 500.00, 50.00, 10 ,'Credit Card', '2014-05-01 10:30:00'),
(2, 2, 3, 'Completed', 850.00, 850.00, 0.00, 10 ,'PayPal', '2014-05-02 11:15:00'),
(3, 3, 4, 'Completed', 1200.00, 1200.00, 0.00, 10 ,'Credit Card', '2014-05-03 14:20:00'),
(4, 4, 2, 'Completed', 780.00, 800.00, 20.00, 10 ,'Debit Card', '2014-05-04 09:45:00'),
(5, 5, 4, 'Refunded', 620.00, 650.00, 30.00, 10 ,'Credit Card', '2014-05-05 16:30:00'),
(6, 6, 1, 'Completed', 950.00, 1000.00, 50.00, 10 ,'PayPal', '2014-05-06 12:10:00'),
(7, 7, 1, 'Completed', 1100.00, 1100.00, 0.00, 10 ,'Credit Card', '2014-05-07 13:25:00'),
(8, 8, 5, 'Completed', 2200.00, 2200.00, 0.00, 10 ,'Bank Transfer', '2014-05-08 15:40:00'),
(9, 9, 7, 'Cancelled', 1500.00, 1500.00, 0.00, 10 ,'Credit Card', '2014-05-09 10:00:00'),
(10, 10, 8,'Completed', 890.00, 900.00, 10.00, 10 ,'Debit Card', '2014-05-10 11:55:00'),
(11, 11, 9,'Completed', 1300.00, 1300.00, 0.00, 10 ,'Credit Card', '2014-05-11 17:20:00'),
(12, 12, 10,'Completed', 1050.00, 1100.00, 50.00, 10 ,'PayPal', '2014-05-12 14:35:00'),
(13, 13, 13,'Completed', 1950.00, 2000.00, 50.00, 10 ,'Credit Card', '2014-05-13 09:10:00'),
(14, 14, 14,'Pending', 800.00, 800.00, 0.00, 10 ,'PayPal', '2014-05-13 09:15:00'),
(15, 15, 15,'Completed', 1700.00, 1700.00, 0.00, 10 ,'Credit Card', '2014-05-15 16:45:00');

INSERT INTO Source.AccountTierHistory (HistoryID, AccountID, LoyaltyTierID, EffectiveFrom, EffectiveTo, CurrentFlag) VALUES
(1, 1, 1, '2013-01-15', '2010-12-31', 0),
(2, 1, 2, '2012-01-01', '2012-12-31', 0),
(3, 1, 1, '2014-01-01', NULL, 1),
(4, 2, 1, '2011-05-20', '2013-04-30', 0),
(5, 2, 2, '2013-05-01', NULL, 1),
(6, 3, 2, '2010-03-10', '2010-12-31', 0),
(7, 3, 3, '2012-01-01', NULL, 1),
(8, 4, 1, '2012-07-22', NULL, 1),
(9, 5, 1, '2012-02-18', '2012-11-30', 0),
(10, 5, 2, '2012-12-01', NULL, 1),
(11, 6, 4, '2013-11-05', NULL, 1),
(12, 7, 1, '2011-04-30', NULL, 1),
(13, 8, 2, '2010-08-12', '2012-07-31', 0),
(14, 8, 3, '2012-08-01', NULL, 1),
(15, 9, 2, '2009-09-25', NULL, 1);

INSERT INTO Source.CrewMember (CrewMemberID, PersonID, Role) VALUES
(1, 16, 'Pilot'),
(2, 17, 'Co-Pilot'),
(3, 18, 'Senior Flight Attendant'),
(4, 19, 'Flight Attendant'),
(5, 20, 'Flight Attendant'),
(6, 11, 'Pilot'),
(7, 12, 'Co-Pilot'),
(8, 13, 'Flight Attendant'),
(9, 14, 'Flight Attendant'),
(10, 15, 'Senior Flight Attendant');


INSERT INTO Source.CrewAssignment (CrewAssignmentID, FlightDetailID, CrewMemberID) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 1, 3),
(4, 2, 4),
(5, 2, 5),
(6, 3, 6),
(7, 3, 7),
(8, 4, 8),
(9, 5, 9),
(10, 6, 10),
(11, 7, 1),
(12, 8, 2),
(13, 9, 3),
(14, 10, 4),
(15, 11, 5);


INSERT INTO Source.FlightOperation (FlightOperationID, FlightDetailID, ActualDepartureDateTime, ActualArrivalDateTime, DelayMinutes, CancelFlag) VALUES
(1, 1, '2014-06-01 08:15:00', '2014-06-01 12:10:00', 15, 0),
(2, 2, '2014-06-01 14:00:00', '2014-06-01 18:20:00', 0, 0),
(3, 3, '2014-06-02 09:30:00', '2014-06-02 15:45:00', 30, 0),
(4, 4, '2014-06-02 11:00:00', '2014-06-02 20:00:00', 0, 0),
(5, 5, '2014-06-03 10:00:00', '2014-06-03 15:45:00', 0, 0),
(6, 6, '2014-06-03 13:20:00', '2014-06-03 17:50:00', 20, 0),
(7, 7, '2014-06-04 07:00:00', '2014-06-04 09:45:00', 0, 0),
(8, 8, '2014-06-04 15:00:00', '2014-06-04 22:30:00', 30, 0),
(9, 9, '2014-06-05 12:00:00', '2014-06-05 18:15:00', 15, 0),
(10, 10, '2014-06-05 16:05:00', '2014-06-06 06:20:00', 5, 0),
(11, 11, '2014-06-06 09:30:00', '2014-06-06 13:00:00', 0, 0),
(12, 12, '2014-06-06 14:30:00', '2014-06-06 19:20:00', 30, 0),
(13, 13, '2014-06-07 08:45:00', '2014-06-07 12:00:00', 0, 0),
(14, 14, '2014-06-07 11:30:00', '2014-06-07 16:45:00', 45, 0),
(15, 15, '2014-06-08 10:15:00', '2014-06-08 14:30:00', 0, 0);



INSERT INTO [Source].[MaintenanceType] (MaintenanceTypeID, Name, Category, Description) VALUES
(1, 'Engine Check', 'Routine', 'Regular engine maintenance and safety check'),
(2, 'Landing Gear Inspection', 'Safety', 'Full check of landing gear systems'),
(3, 'Cabin Systems Update', 'Update', 'Modernization of passenger cabin electronics'),
(4, 'Avionics Overhaul', 'Major', 'Complete overhaul of avionics systems'),
(5, 'Fuel System Inspection', 'Routine', 'Inspection for leaks or issues in fuel system');


INSERT INTO [Source].[Technician] (TechnicianID, PersonID, Specialty) VALUES
(1,  1,  'A - Full-time'),
(2,  2,  'B - Contract'),
(3,  3,  'C - Full-time'),
(4,  4,  'A - Part-time'),
(5,  5,  'B - Full-time'),
(6,  6,  'C - Contract');


INSERT INTO [Source].[MaintenanceEvent] (MaintenanceEventID, AircraftID, MaintenanceTypeID, LocationID, TechnicianID, MaintenanceDate, DowntimeHours, LaborHours, LaborCost, TotalPartsCost, TotalMaintenanceCost, DistinctIssuesSolved, Description) VALUES
(1, 1, 1, 'DXB-MX', 1, '2009-05-15', 6.5, 6.0, 1200.00, 3200.00, 4400.00, 2, 'Engine Check and minor leak fix'),
(2, 2, 2, 'LHR-MX', 2, '2009-10-03', 4.0, 3.5, 750.00, 1100.00, 1850.00, 1, 'Landing gear inspection'),
(3, 3, 3, 'JFK-MX', 3, '2010-02-20', 8.0, 8.0, 2200.00, 500.00, 2700.00, 3, 'Cabin systems update, seat electronics fixed'),
(4, 4, 4, 'CDG-MX', 4, '2010-07-05', 10.0, 9.5, 3300.00, 2000.00, 5300.00, 2, 'Avionics overhaul and nav system update'),
(5, 5, 5, 'HND-MX', 5, '2010-12-16', 5.0, 4.5, 900.00, 650.00, 1550.00, 1, 'Fuel system inspection'),
(6, 6, 1, 'DXB-MX', 1, '2011-03-21', 6.0, 5.7, 1190.00, 3100.00, 4290.00, 2, 'Engine oil change and valve check'),
(7, 7, 2, 'LHR-MX', 2, '2011-08-04', 3.5, 3.0, 670.00, 880.00, 1550.00, 1, 'Landing gear system review'),
(8, 8, 3, 'JFK-MX', 3, '2011-12-19', 7.5, 7.0, 1980.00, 540.00, 2520.00, 2, 'Cabin lighting and ventilation system update'),
(9, 9, 4, 'CDG-MX', 4, '2012-02-15', 9.5, 9.0, 3010.00, 1700.00, 4710.00, 2, 'Avionics software and wiring overhaul'),
(10, 10, 5, 'HND-MX', 5, '2012-05-01', 4.8, 4.5, 840.00, 580.00, 1420.00, 1, 'Routine fuel system check'),
(11, 11, 1, 'DXB-MX', 1, '2012-08-16', 5.7, 5.3, 1150.00, 2950.00, 4100.00, 1, 'Engine vibration issue inspection'),
(12, 12, 2, 'LHR-MX', 2, '2012-11-29', 3.8, 3.5, 720.00, 950.00, 1670.00, 1, 'Landing gear sensor alignment'),
(13, 1, 3, 'JFK-MX', 3, '2013-02-18', 8.3, 8.0, 2140.00, 470.00, 2610.00, 2, 'Cabin media and audio upgrade'),
(14, 2, 4, 'CDG-MX', 4, '2013-04-27', 10.2, 9.8, 3400.00, 2150.00, 5550.00, 3, 'Avionics control panel full overhaul'),
(15, 3, 5, 'HND-MX', 5, '2013-07-14', 4.2, 4.0, 910.00, 590.00, 1500.00, 1, 'Fuel pump replacement and test'),
(16, 4, 1, 'DXB-MX', 1, '2013-10-25', 6.2, 5.8, 1220.00, 3260.00, 4480.00, 2, 'Engine compressor blade check'),
(17, 5, 2, 'LHR-MX', 2, '2014-01-11', 3.2, 3.0, 690.00, 800.00, 1490.00, 1, 'Landing gear brake disc review'),
(18, 6, 3, 'JFK-MX', 3, '2014-03-07', 7.0, 6.5, 1850.00, 510.00, 2360.00, 1, 'Cabin cooling system update'),
(19, 7, 4, 'CDG-MX', 4, '2014-05-19', 9.7, 9.1, 3180.00, 1880.00, 5060.00, 2, 'Avionics antenna system overhaul'),
(20, 8, 5, 'HND-MX', 5, '2014-07-30', 4.6, 4.3, 860.00, 610.00, 1470.00, 1, 'Fuel valve and pipeline check');


INSERT INTO [Source].[PartReplacement] (PartReplacementID, AircraftID, PartID, LocationID, ReplacementDate, Quantity, PartCost, TotalPartCost) VALUES
(1, 1, 1, 'DXB-MX', '2010-05-15', 1, 2500.00, 2500.00),
(2, 2, 2, 'LHR-MX', '2010-10-03', 1, 650.00, 650.00),
(3, 3, 3, 'JFK-MX', '2010-02-20', 2, 450.00, 900.00),
(4, 4, 4, 'CDG-MX', '2010-07-05', 3, 70.00, 210.00),
(5, 5, 5, 'HND-MX', '2010-12-16', 1, 330.00, 330.00),
(6, 6, 1, 'DXB-MX', '2011-03-21', 1, 2450.00, 2450.00),
(7, 7, 2, 'LHR-MX', '2011-08-04', 1, 640.00, 640.00),
(8, 8, 3, 'JFK-MX', '2011-12-19', 1, 480.00, 480.00),
(9, 9, 4, 'CDG-MX', '2012-02-15', 2, 75.00, 150.00),
(10, 10, 5, 'HND-MX', '2012-05-01', 1, 340.00, 340.00),
(11, 11, 1, 'DXB-MX', '2012-08-16', 1, 2530.00, 2530.00),
(12, 12, 2, 'LHR-MX', '2012-11-29', 1, 670.00, 670.00),
(13, 1, 3, 'JFK-MX', '2013-02-18', 1, 490.00, 490.00),
(14, 2, 4, 'CDG-MX', '2013-04-27', 2, 68.00, 136.00),
(15, 3, 5, 'HND-MX', '2013-07-14', 1, 350.00, 350.00),
(16, 4, 1, 'DXB-MX', '2013-10-25', 1, 2600.00, 2600.00),
(17, 5, 2, 'LHR-MX', '2014-01-11', 1, 680.00, 680.00),
(18, 6, 3, 'JFK-MX', '2014-03-07', 2, 520.00, 1040.00),
(19, 7, 4, 'CDG-MX', '2014-05-19', 1, 90.00, 90.00),
(20, 8, 5, 'HND-MX', '2014-07-30', 1, 355.00, 355.00);


INSERT INTO [Source].[MaintenanceLocation] (LocationID, Name, City, Country, InhouseFlag) VALUES
('DXB-MX', 'Dubai Maintenance Hangar', 'Dubai', 'UAE', 1),
('LHR-MX', 'Heathrow Service Bay', 'London', 'UK', 1),
('JFK-MX', 'JFK Technical Center', 'New York', 'USA', 0),
('CDG-MX', 'Charles de Gaulle Facility', 'Paris', 'France', 1),
('HND-MX', 'Haneda Aero Services', 'Tokyo', 'Japan', 0);


INSERT INTO [Source].[Part] (PartID, Name, PartNumber, Manufacturer, WarrantyPeriodMonths, Category) VALUES
(1, 'Turbofan Engine', 'ENG-777', 'Rolls-Royce', 120, 'Engine'),
(2, 'Landing Gear Set', 'LG-320', 'Goodrich', 96, 'Landing Gear'),
(3, 'Flight Computer', 'FC-900', 'Honeywell', 60, 'Avionics'),
(4, 'Cabin Air Filter', 'CAF-101', 'Siemens', 36, 'Cabin'),
(5, 'Fuel Pump', 'FP-220', 'Parker', 48, 'Fuel System');


INSERT INTO [Source].[AirlineAirportService]
(ServiceTypeCode, FlightTypeCode, ServiceTypeName, FlightTypeName, ContractStartDate, ContractEndDate, LandingFeeRate, PassengerServiceRate)
VALUES
('BASIC', 'INTL', 'Basic Handling', 'International', '2010-01-01', NULL, 500.00, 12.00),
('VIP', 'DOM', 'VIP Lounge', 'Domestic', '2012-05-01', NULL, 800.00, 25.00),
('CARGO', 'INTL', 'Cargo Handling', 'International', '2011-03-15', '2020-12-31', 1200.00, 30.00),
('FUEL', 'DOM', 'Fuel Service', 'Domestic', '2014-06-01', NULL, 350.00, 7.50),
('MAINT', 'INTL', 'Maintenance Support', 'International', '2013-10-10', NULL, 1500.00, 50.00);
