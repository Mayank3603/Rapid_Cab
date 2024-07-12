-- Ride Cancellation:
-- Description: If a ride is canceled, there is a penalty of 1 percent of the trip cost
-- which is added to the driver wallet from the customer wallet. The trip with the
-- corresponding R_ID is deleted.
START TRANSACTION;
SET @customer = NULL;
SET @driver = NULL;
SET @amount = NULL;
SET @trip = NULL;

-- Retrieve customer and driver IDs associated with the ride request
SELECT @customer := Customer_ID, @driver := Driver_ID FROM ride_request WHERE R_ID = 70011;

-- Retrieve trip ID and fare price associated with the ride request
SELECT @trip := T_ID, @amount := Fare_Price FROM trip WHERE R_ID = 70011;

-- Delete the trip and ride request
DELETE FROM trip WHERE R_ID = 70011;
DELETE FROM ride_request WHERE R_ID = 70011;

-- Update customer and driver wallets with penalty
UPDATE customer SET wallet = wallet - @amount / 100 WHERE Customer_ID = @customer;
UPDATE driver SET wallet = wallet + @amount / 100 WHERE Driver_ID = @driver;

COMMIT;

-- Adding a new vehicle to a driver whose previous vehicle was damaged:
-- Description: If a vehicle is damaged, a new vehicle is assigned to the driver.
START TRANSACTION;
SET @driv = NULL;
SET @mystring = CONCAT("HR", FLOOR(RAND() * 100), "BF", FLOOR(RAND() * 10000));

-- Retrieve driver ID associated with the damaged vehicle
SELECT @driv := Driver_ID FROM vehicle WHERE Number_Plate = "MH92IB9846";

-- Delete the damaged vehicle
DELETE FROM vehicle WHERE Number_Plate = "MH92IB9846";

-- Insert new vehicle for the driver
INSERT INTO vehicle (Driver_ID, Number_Plate, Seats_accommodation, Fuel, Color, Maintenance_state)
VALUES (@driv, @mystring, 6, "EV", "White", "G");

COMMIT;

-- Ride accepted:
-- Description: If a ride request is accepted by a driver, the corresponding trip is deleted along with the
-- ride request. The customer and driver wallets are updated as per the fare price of the
-- corresponding trip.
START TRANSACTION;
SET @customer = NULL;
SET @driver = NULL;
SET @amount = NULL;
SET @ride = NULL;

-- Retrieve customer and driver IDs associated with the trip
SELECT @customer := Customer_ID, @driver := Driver_ID FROM trip WHERE R_ID = 30011;

-- Retrieve ride request ID and fare price associated with the trip
SELECT @ride := R_ID, @amount := Fare_Price FROM trip WHERE T_ID = 30011;

-- Update the ride request status and delete the trip, ride request, and payment records
UPDATE ride_request SET status = 'A' WHERE R_ID = @ride;
DELETE FROM trip WHERE T_ID = 30011;
DELETE FROM ride_request WHERE R_ID = @ride;
DELETE FROM payment WHERE T_ID = 30011;

-- Update customer and driver wallets with fare price
UPDATE customer SET wallet = wallet + @amount WHERE Customer_ID = @customer;
UPDATE driver SET wallet = wallet + @amount WHERE Driver_ID = @driver;

COMMIT;

-- Updation of Customer status:
-- Description: If the status of the customer is updated, a fixed amount is deducted
-- from the customer wallet.
START TRANSACTION;

-- Update customer type and deduct amount from wallet
UPDATE customer SET type = "prime" WHERE Customer_ID = "50045";
UPDATE customer SET wallet = wallet - 4000 WHERE Customer_ID = "50045";

COMMIT;
