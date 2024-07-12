CREATE TABLE Customer (
    Customer_ID INT NOT NULL AUTO_INCREMENT,
    Name VARCHAR(20) NOT NULL,
    Email VARCHAR(30) NOT NULL,
    DOB VARCHAR(10) NOT NULL,
    Phn_Number VARCHAR(10) NOT NULL,
    Credit_Score float NOT NULL,
    PRIMARY KEY (Customer_ID),
    UNIQUE INDEX unique_customer_ID (Customer_ID ASC) VISIBLE,
    UNIQUE INDEX unique_email (Email ASC) VISIBLE,
    UNIQUE INDEX unique_phn_number (Phn_Number ASC) VISIBLE
);

CREATE TABLE Driver (
    Driver_ID INT NOT NULL AUTO_INCREMENT,
    Email_ID VARCHAR(30) NOT NULL,
    Name VARCHAR(20) NOT NULL,
    Phone_Number VARCHAR(10) NOT NULL,
    Gender CHAR(1),
    Address VARCHAR(40),
    Avg_Rating FLOAT NOT NULL,
    Driver_Status CHAR(1),
    PRIMARY KEY (Driver_ID),
    UNIQUE INDEX unique_driver_id (Driver_ID ASC) VISIBLE,
    UNIQUE INDEX unique_email (Email_ID ASC) VISIBLE,
    UNIQUE INDEX unique_phn_number (Phone_Number ASC) VISIBLE,
    CHECK (Phone_Number = 10)
);

CREATE TABLE Vehicle (
    Number_Plate VARCHAR(15) NOT NULL,
    Driver_ID INT NOT NULL,
    Seats_accommodation INT NOT NULL,
    Fuel VARCHAR(10) NOT NULL,
    Color VARCHAR(45) NOT NULL,
    Maintainance_state CHAR(1),
    PRIMARY KEY (Number_Plate),
    FOREIGN KEY (Driver_ID) REFERENCES Driver(Driver_ID)
);

CREATE TABLE Payment (
    Reference_ID VARCHAR(20) NOT NULL,
    T_ID INT NOT NULL,
    Customer_ID INT NOT NULL,
    Amount DECIMAL NOT NULL,
    PRIMARY KEY (T_ID, Reference_ID, Customer_ID)
);

CREATE TABLE Ride_Request (
    R_ID INT NOT NULL AUTO_INCREMENT,
    date DATE,
    Driver_ID INT NOT NULL,
    Customer_ID INT NOT NULL,
    Pickup_Time TIME,
    PRIMARY KEY (R_ID),
    FOREIGN KEY (Driver_ID) REFERENCES Driver(Driver_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);
CREATE TABLE Trip (
    T_ID INT NOT NULL AUTO_INCREMENT,
    Driver_ID INT NOT NULL,
    R_ID INT NOT NULL,
    Customer_ID INT NOT NULL,
    Pickup_x FLOAT NOT NULL,
    Pickup_y FLOAT NOT NULL,
    Destination_x FLOAT NOT NULL,
    Destination_y FLOAT NOT NULL,
    Fare_Price FLOAT NOT NULL,
    time_taken TIME,
    PRIMARY KEY (T_ID),
    FOREIGN KEY (Driver_ID) REFERENCES Driver(Driver_ID),
    FOREIGN KEY (R_ID) REFERENCES Ride_Request(R_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);
