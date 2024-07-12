import mysql.connector as sql

def execute_query(cursor, query):
    cursor.execute(query)
    result = cursor.fetchall()
    for row in result:
        print(row)

def main():
    db = sql.connect(host="localhost", user="root", password="Mayank@02", database="Rapid_Cab_new")
    cur = db.cursor()

    embedded_queries = {
        1: {
            'desc': "Selects all vehicle details that belong to Haryana and orders them by fuel type.",
            'query': "SELECT * FROM rapid_cab_new.vehicle WHERE Number_Plate LIKE 'HR%' ORDER BY FIELD(Fuel, 'Diesel', 'EV', 'Petrol', 'CNG');"
        },
        2: {
            'desc': "Adds a column called 'status' in the ride_request table and sets the status to 'A' for records present in the trip table.",
            'query': "ALTER TABLE ride_request ADD status CHAR(1) DEFAULT 'U'; UPDATE ride_request SET status = 'A' WHERE R_ID IN (SELECT R_ID FROM trip); SELECT * FROM ride_request;"
        },
        3: {
            'desc': "Selects customer IDs with the total amount spent by each customer.",
            'query': "SELECT Customer_ID, SUM(Amount) AS total_amount FROM payment GROUP BY Customer_ID;"
        },
        4: {
            'desc': "Updates the fare price to 0 for all trips where the driver status is 'B'.",
            'query': "UPDATE Trip SET Fare_Price = 0 WHERE Driver_ID IN (SELECT Driver_ID FROM Driver WHERE Driver_Status = 'B');"
        },
        5: {
            'desc': "Increases the amount of the payment by 1000 where the pickup time is after 4pm.",
            'query': "SET SQL_SAFE_UPDATES = 0; UPDATE Payment p JOIN Ride_Request r ON p.Customer_ID = r.Customer_ID SET p.Amount = p.Amount + 1000 WHERE r.Pickup_Time > '16:00:00';"
        },
        6: {
            'desc': "Deletes the payment and trip records of drivers whose status is 'O'.",
            'query': "DELETE p, t FROM Payment p JOIN Trip t ON p.T_ID = t.T_ID JOIN Driver d ON t.Driver_ID = d.Driver_ID WHERE d.Driver_Status = 'O';"
        },
        7: {
            'desc': "Selects the payment details for all trips whose drivers are available.",
            'query': "SELECT * FROM Payment p JOIN Trip t ON p.T_ID = t.T_ID JOIN Driver d ON t.Driver_ID = d.Driver_ID WHERE d.Driver_Status = 'A';"
        },
        8: {
            'desc': "Selects all the customers who have had a trip in all fuel kinds.",
            'query': "SELECT c.Customer_ID, c.Name, c.Email FROM Customer c WHERE NOT EXISTS (SELECT v.Fuel FROM Vehicle v WHERE NOT EXISTS (SELECT t.Customer_ID FROM Trip t WHERE t.Customer_ID = c.Customer_ID AND t.Driver_ID = v.Driver_ID));"
        },
        9: {
            'desc': "Selects the driver and fuel details of the vehicle with fuel = 'CNG'.",
            'query': "SELECT d.Driver_ID, d.Name, v.Fuel FROM Driver d LEFT JOIN Vehicle v ON d.Driver_ID = v.Driver_ID WHERE v.Fuel = 'CNG' OR v.Fuel IS NULL;"
        },
        10: {
            'desc': "Selects the driver and fuel details of the vehicle with Maintenance_State = 'B'.",
            'query': "SELECT d.Name, v.Number_Plate, v.Fuel FROM Driver d INNER JOIN Vehicle v ON d.Driver_ID = v.Driver_ID WHERE v.Maintainance_state = 'B';"
        },
        11: {
            'desc': "Selects all drivers with an average rating greater than 4.",
            'query': "SELECT Driver_ID, Name, Avg_Rating FROM Driver WHERE Avg_Rating > 4;"
        },
        12: {
            'desc': "Selects all trips that took more than 30 minutes.",
            'query': "SELECT * FROM Trip WHERE TIME_TO_SEC(time_taken) > 1800;"
        },
        13: {
            'desc': "Selects the number of trips taken by each customer.",
            'query': "SELECT Customer_ID, COUNT(*) AS total_trips FROM Trip GROUP BY Customer_ID;"
        },
        14: {
            'desc': "Selects all vehicles that have more than 4 seats.",
            'query': "SELECT * FROM Vehicle WHERE Seats_accommodation > 4;"
        },
        15: {
            'desc': "Selects the highest fare price among all trips.",
            'query': "SELECT MAX(Fare_Price) AS highest_fare FROM Trip;"
        },
        16: {
            'desc': "Updates the driver status to 'I' for all drivers with an average rating less than 3.",
            'query': "UPDATE Driver SET Driver_Status = 'I' WHERE Avg_Rating < 3;"
        },
        17: {
            'desc': "Selects all payments made on a specific date.",
            'query': "SELECT * FROM Payment WHERE DATE(date) = '2024-07-13';"
        },
        18: {
            'desc': "Selects the total number of customers.",
            'query': "SELECT COUNT(*) AS total_customers FROM Customer;"
        },
        19: {
            'desc': "Selects all trips where the destination coordinates are within a specific range.",
            'query': "SELECT * FROM Trip WHERE Destination_x BETWEEN 10 AND 20 AND Destination_y BETWEEN 10 AND 20;"
        },
        20: {
            'desc': "Deletes all customers with a credit score less than 500.",
            'query': "DELETE FROM Customer WHERE Credit_Score < 500;"
        },
        21: {
            'desc': "Selects the driver details of those who have completed trips for a specific customer.",
            'query': "SELECT DISTINCT d.Driver_ID, d.Name FROM Driver d JOIN Trip t ON d.Driver_ID = t.Driver_ID WHERE t.Customer_ID = 1;"
        }
    }

    olap_queries = {
        1: {
            'desc': "OLAP Rollup Query 1",
            'query': "WITH table1 (amnt, t_id, pickup_time, date) AS (SELECT p.Amount, p.T_ID, r.Pickup_Time, r.Date FROM payment p JOIN ride_request r ON p.Customer_ID = r.Customer_ID) SELECT pickup_time, date, SUM(amnt) AS total_amount FROM table1 GROUP BY date, pickup_time WITH ROLLUP;"
        },
        2: {
            'desc': "OLAP Rollup Query 2",
            'query': "WITH table2(no_seats, fuel_type, color, amount) AS (SELECT v.Seats_accomadation, v.Fuel, v.Color, p.amount FROM vehicle v, payment p, trip t WHERE p.T_ID=t.T_ID AND v.Driver_ID=t.Driver_ID) SELECT no_seats, fuel_type, color, SUM(amount) FROM table2 GROUP BY no_seats, fuel_type, color WITH ROLLUP;"
        },
        3: {
            'desc': "OLAP Slicing Query",
            'query': "WITH table3(no_seats, fuel_type, color, amount, distance) AS (SELECT v.Seats_accomadation, v.Fuel, v.Color, p.amount, ABS(t.Pickup_x - t.Destination_x) + ABS(t.Pickup_y - t.Destination_y) FROM vehicle v, payment p, trip t WHERE p.T_ID=t.T_ID AND v.Driver_ID=t.Driver_ID) SELECT no_seats, SUM(amount) FROM table3 WHERE fuel_type='Petrol' AND color='Black' AND distance > 100 GROUP BY no_seats;"
        },
        4: {
            'desc': "OLAP Pivot Query",
            'query': "SELECT fuel, SUM(CASE WHEN fuel='Diesel' THEN 1 ELSE 0 END) AS Diesel_vehicle, SUM(CASE WHEN fuel='CNG' THEN 1 ELSE 0 END) AS CNG_vehicle, SUM(CASE WHEN fuel='EV' THEN 1 ELSE 0 END) AS EV_vehicle, SUM(CASE WHEN fuel='Petrol' THEN 1 ELSE 0 END) AS Petrol_vehicle FROM vehicle GROUP BY fuel;"
        }
    }

    trigger_queries = {
        1: {
            'desc': "Customer Wallet Updation Trigger",
            'query': """
            DELIMITER $$
            CREATE TRIGGER customer_wallet_updation
            BEFORE UPDATE ON customer
            FOR EACH ROW
            BEGIN
                IF NEW.type = 'elite' AND OLD.type = 'normal' THEN
                    SET NEW.wallet = OLD.wallet - 5000;
                END IF;
            END $$
            DELIMITER ;
            """
        },
        2: {
            'desc': "Check Gender Trigger",
            'query': """
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
            """
        },
        3: {
            'desc': "Vehicle Insertion Trigger",
            'query': """
            DELIMITER $$
            CREATE TRIGGER vehicle_insertion
            AFTER INSERT ON driver
            FOR EACH ROW
            BEGIN
                DECLARE mystring VARCHAR(12);
                SELECT CONCAT("HR", FLOOR(RAND()*100), "BF", FLOOR(RAND()*10000)) INTO mystring;
                INSERT INTO vehicle(Driver_ID, Number_Plate, Seats_accomadation, Fuel, Color, Maintainance_state)
                VALUES (NEW.Driver_ID, mystring, 6, "EV", "White", "G");
            END $$
            DELIMITER $$
            """
        }
    }

    transaction_queries = {
        1: {
            'desc': "Ride Cancellation",
            'query': """
            START TRANSACTION;
            SET @customer = NULL;
            SET @driver = NULL;
            SET @amount = NULL;
            SET @trip = NULL;
            SELECT @customer := Customer_ID, @driver := Driver_ID FROM ride_request WHERE R_ID = 70011;
            SELECT @trip := T_ID, @amount := Fare_Price FROM trip WHERE R_ID = 70011;
            DELETE FROM trip WHERE R_ID = 70011;
            DELETE FROM ride_request WHERE R_ID = 70011;
            UPDATE customer SET wallet = wallet - @amount / 100 WHERE Customer_ID = @customer;
            UPDATE driver SET wallet = wallet + @amount / 100 WHERE Driver_ID = @driver;
            COMMIT;
            """
        },
        2: {
            'desc': "Adding New Vehicle",
            'query': """
            START TRANSACTION;
            SET @driv = NULL;
            SET @mystring = CONCAT("HR", FLOOR(RAND()*100), "BF", FLOOR(RAND()*10000));
            SELECT @driv := Driver_ID FROM vehicle WHERE Number_Plate = "MH92IB9846";
            DELETE FROM vehicle WHERE Number_Plate = "MH92IB9846";
            INSERT INTO vehicle (Driver_ID, Number_Plate, Seats_accomadation, Fuel, Color, Maintainance_state)
            VALUES (@driv, @mystring, 6, "EV", "White", "G");
            COMMIT;
            """
        },
        3: {
            'desc': "Ride Accepted",
            'query': """
            START TRANSACTION;
            SET @customer = NULL;
            SET @driver = NULL;
            SET @amount = NULL;
            SET @ride = NULL;
            SELECT @customer := Customer_ID, @driver := Driver_ID FROM trip WHERE R_ID = 30011;
            SELECT @ride := R_ID, @amount := Fare_Price FROM trip WHERE T_ID = 30011;
            UPDATE ride_request SET status = 'A' WHERE R_ID = @ride;
            DELETE FROM trip WHERE T_ID = 30011;
            DELETE FROM ride_request WHERE R_ID = @ride;
            DELETE FROM payment WHERE T_ID = 30011;
            UPDATE customer SET wallet = wallet + @amount WHERE Customer_ID = @customer;
            UPDATE driver SET wallet = wallet + @amount WHERE Driver_ID = @driver;
            COMMIT;
            """
        },
        4: {
            'desc': "Updation of Customer Status",
            'query': """
            START TRANSACTION;
            UPDATE customer SET type = "prime" WHERE Customer_ID = "50045";
            UPDATE customer SET wallet = wallet - 4000 WHERE Customer_ID = "50045";
            COMMIT;
            """
        }
    }

    while True:
        print("\n--- Main Menu ---")
        print("1. OLAP Queries")
        print("2. Embedded Queries")
        print("3. Triggers")
        print("4. Transactions")
        print("5. Exit")
        choice = int(input("Enter your choice: "))

        if choice == 1:
            print("\n--- OLAP Queries ---")
            for key, value in olap_queries.items():
                print(f"{key}. {value['desc']}")
            query_choice = int(input("Enter your choice: "))
            if query_choice in olap_queries:
                execute_query(cur, olap_queries[query_choice]['query'])
            else:
                print("Invalid Choice")

        elif choice == 2:
            print("\n--- Embedded Queries ---")
            for key, value in embedded_queries.items():
                print(f"{key}. {value['desc']}")
            query_choice = int(input("Enter your choice: "))
            if query_choice in embedded_queries:
                execute_query(cur, embedded_queries[query_choice]['query'])
            else:
                print("Invalid Choice")

        elif choice == 3:
            print("\n--- Triggers ---")
            for key, value in trigger_queries.items():
                print(f"{key}. {value['desc']}")
            query_choice = int(input("Enter your choice: "))
            if query_choice in trigger_queries:
                cur.execute(trigger_queries[query_choice]['query'])
                db.commit()
                print("Trigger executed successfully.")
            else:
                print("Invalid Choice")

        elif choice == 4:
            print("\n--- Transactions ---")
            for key, value in transaction_queries.items():
                print(f"{key}. {value['desc']}")
            query_choice = int(input("Enter your choice: "))
            if query_choice in transaction_queries:
                cur.execute(transaction_queries[query_choice]['query'])
                db.commit()
                print("Transaction executed successfully.")
            else:
                print("Invalid Choice")

        elif choice == 5:
            break

        else:
            print("Invalid Choice")

    db.close()

if __name__ == "__main__":
    main()
