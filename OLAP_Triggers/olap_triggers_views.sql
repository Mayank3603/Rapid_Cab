-- Trigger 1: Customer wallet updation
DELIMITER $$
CREATE TRIGGER customer_wallet_updation
BEFORE UPDATE ON customer
FOR EACH ROW
BEGIN
    IF NEW.type = 'elite' AND OLD.type = 'normal' THEN
        SET NEW.wallet = OLD.wallet - 5000;
    END IF;
END$$
DELIMITER ;

-- Explanation: An amount of rupees 5000 is subtracted from the customer wallet if he buys the elite customer plan.

-- Trigger 2: Check gender
DELIMITER //
CREATE TRIGGER check_gender
BEFORE INSERT ON driver
FOR EACH ROW
BEGIN
    IF NEW.Gender IS NULL THEN
        SET NEW.Gender = 'U';
    END IF;
END //
DELIMITER ;

-- Explanation: When a driver entry is inserted in the database with Gender value NULL, the above trigger will set the value of the corresponding gender as 'U' for unknown.

-- Trigger 3: Vehicle insertion
DELIMITER $$
CREATE TRIGGER vehicle_insertion
AFTER INSERT ON driver
FOR EACH ROW
BEGIN
    DECLARE mystring VARCHAR(12);
    SELECT CONCAT("HR", FLOOR(RAND() * 100), "BF", FLOOR(RAND() * 10000)) INTO mystring;
    INSERT INTO vehicle(Driver_ID, Number_Plate, Seats_accommodation, Fuel, Color, Maintenance_state)
    VALUES(NEW.Driver_ID, mystring, 6, "EV", "White", "G");
END $$
DELIMITER $$

-- Explanation: The above trigger will insert an entry in the vehicle table for a corresponding insertion of a driver entry in the driver table.

-- OLAP Query 1
WITH table1 (amnt, t_id, pickup_time, date) AS (
    SELECT p.Amount, p.T_ID, r.Pickup_Time, r.Date 
    FROM payment p
    JOIN ride_request r ON p.Customer_ID = r.Customer_ID
)
SELECT
    pickup_time,
    date,
    SUM(amnt) AS total_amount
FROM table1
GROUP BY date, pickup_time WITH ROLLUP;

-- OLAP Query 2
WITH table2 (no_seats, fuel_type, color, amount) AS (
    SELECT v.Seats_accommodation, v.Fuel, v.Color, p.Amount
    FROM vehicle v 
    JOIN trip t ON v.Driver_ID = t.Driver_ID
    JOIN payment p ON p.T_ID = t.T_ID
)
SELECT no_seats, fuel_type, color, SUM(amount) 
FROM table2
GROUP BY no_seats, fuel_type, color WITH ROLLUP;

-- OLAP Query 3
SELECT t.T_ID, c.Customer_ID, AVG(p.Amount) AS AvgAmount, AVG(t.time_taken) AS AvgTime, AVG(Credit_Score) AS AvgCreditScore
FROM customer AS c
JOIN payment AS p ON c.Customer_ID = p.Customer_ID
JOIN trip AS t ON p.T_ID = t.T_ID
GROUP BY CUBE(t.T_ID, c.Customer_ID)
ORDER BY t.T_ID, c.Customer_ID;

-- Slicing
WITH table3 (no_seats, fuel_type, color, amount, distance) AS (
    SELECT v.Seats_accommodation, v.Fuel, v.Color, p.Amount, ABS(t.Pickup_x - t.Destination_x) + ABS(t.Pickup_y - t.Destination_y) AS distance
    FROM vehicle v
    JOIN trip t ON v.Driver_ID = t.Driver_ID
    JOIN payment p ON p.T_ID = t.T_ID
)
SELECT no_seats, SUM(amount) 
FROM table3
WHERE fuel_type = "Petrol" AND color = "Black" AND distance > 100 
GROUP BY no_seats;

-- Pivot
SELECT fuel,
    SUM(CASE WHEN fuel = 'Diesel' THEN 1 ELSE 0 END) AS Diesel_vehicle,
    SUM(CASE WHEN fuel = 'CNG' THEN 1 ELSE 0 END) AS CNG_vehicle,
    SUM(CASE WHEN fuel = 'EV' THEN 1 ELSE 0 END) AS EV_vehicle,
    SUM(CASE WHEN fuel = 'Petrol' THEN 1 ELSE 0 END) AS Petrol_vehicle
FROM vehicle
GROUP BY fuel;

-- Embedded Query
-- Explanation: This block simulates embedded SQL queries. Replace the placeholders and execute individually as per requirement.
-- 1. Select payment details for all trips with available drivers
SELECT * 
FROM payment p 
JOIN Trip t ON p.T_ID = t.T_ID 
JOIN Driver d ON t.Driver_ID = d.Driver_ID 
WHERE d.Driver_Status = 'A';

-- 2. Select all vehicle details that belong to Haryana and order by fuel type
SELECT * 
FROM rapid_cab_new.vehicle 
WHERE Number_Plate LIKE 'HR%' 
ORDER BY FIELD(Fuel, 'Diesel', 'EV', 'Petrol', 'CNG');

-- 3. Select customer IDs with total amount spent by each customer
SELECT Customer_ID, SUM(Amount) AS total_amount 
FROM payment 
GROUP BY Customer_ID;

-- 4. Select driver details with vehicle maintenance state = 'B'
SELECT d.Name, v.Number_Plate, v.Fuel 
FROM Driver d 
INNER JOIN Vehicle v ON d.Driver_ID = v.Driver_ID 
WHERE v.Maintenance_state = 'B';
