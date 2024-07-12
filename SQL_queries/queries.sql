-- 1. Selects all vehicle details that belong to Haryana and orders them by fuel type.
SELECT * FROM rapid_cab_new.vehicle 
WHERE Number_Plate LIKE 'HR%' 
ORDER BY FIELD(Fuel, 'Diesel', 'EV', 'Petrol', 'CNG');

-- 2. Adds a column called "status" in the ride_request table and sets the status to "A" for records present in the trip table.
ALTER TABLE ride_request ADD status CHAR(1) DEFAULT "U";
UPDATE ride_request SET status = "A" WHERE R_ID IN (SELECT R_ID FROM trip);
SELECT * FROM ride_request;

-- 3. Selects customer IDs with the total amount spent by each customer.
SELECT Customer_ID, SUM(Amount) AS total_amount 
FROM payment 
GROUP BY Customer_ID;

-- 4. Updates the fare price to 0 for all trips where the driver status is "B".
UPDATE Trip SET Fare_Price = 0 
WHERE Driver_ID IN (SELECT Driver_ID FROM Driver WHERE Driver_Status = 'B');

-- 5. Increases the amount of the payment by 1000 where the pickup time is after 4pm.
SET SQL_SAFE_UPDATES = 0;
UPDATE Payment p 
JOIN Ride_Request r ON p.Customer_ID = r.Customer_ID 
SET p.Amount = p.Amount + 1000 
WHERE r.Pickup_Time > '16:00:00';

-- 6. Deletes the payment and trip records of drivers whose status is "O".
DELETE p, t 
FROM Payment p 
JOIN Trip t ON p.T_ID = t.T_ID 
JOIN Driver d ON t.Driver_ID = d.Driver_ID 
WHERE d.Driver_Status = 'O';

-- 7. Selects the payment details for all trips whose drivers are available.
SELECT * 
FROM Payment p 
JOIN Trip t ON p.T_ID = t.T_ID 
JOIN Driver d ON t.Driver_ID = d.Driver_ID 
WHERE d.Driver_Status = 'A';

-- 8. Selects all the customers who have had a trip in all fuel kinds.
SELECT c.Customer_ID, c.Name, c.Email 
FROM Customer c 
WHERE NOT EXISTS (
    SELECT v.Fuel 
    FROM Vehicle v 
    WHERE NOT EXISTS (
        SELECT t.Customer_ID 
        FROM Trip t 
        WHERE t.Customer_ID = c.Customer_ID 
        AND t.Driver_ID = v.Driver_ID
    )
);

-- 9. Selects the driver and fuel details of the vehicle with fuel = "CNG".
SELECT d.Driver_ID, d.Name, v.Fuel 
FROM Driver d 
LEFT JOIN Vehicle v ON d.Driver_ID = v.Driver_ID 
WHERE v.Fuel = 'CNG' OR v.Fuel IS NULL;

-- 10. Selects the driver and fuel details of the vehicle with Maintenance_State = 'B'.
SELECT d.Name, v.Number_Plate, v.Fuel 
FROM Driver d 
INNER JOIN Vehicle v ON d.Driver_ID = v.Driver_ID 
WHERE v.Maintainance_state = 'B';

-- 11. Selects all drivers with an average rating greater than 4.
SELECT Driver_ID, Name, Avg_Rating 
FROM Driver 
WHERE Avg_Rating > 4;

-- 12. Selects all trips that took more than 30 minutes.
SELECT * 
FROM Trip 
WHERE TIME_TO_SEC(time_taken) > 1800;

-- 13. Selects the number of trips taken by each customer.
SELECT Customer_ID, COUNT(*) AS total_trips 
FROM Trip 
GROUP BY Customer_ID;

-- 14. Selects all vehicles that have more than 4 seats.
SELECT * 
FROM Vehicle 
WHERE Seats_accommodation > 4;

-- 15. Selects the highest fare price among all trips.
SELECT MAX(Fare_Price) AS highest_fare 
FROM Trip;

-- 16. Updates the driver status to 'I' for all drivers with an average rating less than 3.
UPDATE Driver 
SET Driver_Status = 'I' 
WHERE Avg_Rating < 3;

-- 17. Selects all payments made on a specific date.
SELECT * 
FROM Payment 
WHERE DATE(date) = '2024-07-13';

-- 18. Selects the total number of customers.
SELECT COUNT(*) AS total_customers 
FROM Customer;

-- 19. Selects all trips where the destination coordinates are within a specific range.
SELECT * 
FROM Trip 
WHERE Destination_x BETWEEN 10 AND 20 
AND Destination_y BETWEEN 10 AND 20;

-- 20. Deletes all customers with a credit score less than 500.
DELETE FROM Customer 
WHERE Credit_Score < 500;

-- 21. Selects the driver details of those who have completed trips for a specific customer.
SELECT DISTINCT d.Driver_ID, d.Name 
FROM Driver d 
JOIN Trip t ON d.Driver_ID = t.Driver_ID 
WHERE t.Customer_ID = 1;
