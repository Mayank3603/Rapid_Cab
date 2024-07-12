# Rapid_Cab

## Overview

The **Rapid_Cab** project is a comprehensive DBMS application designed to manage a cab service efficiently. It provides functionalities for managing drivers, vehicles, customers, and trip records. The backend is implemented using MySQL, which handles data storage and retrieval, while a command-line interface (CLI) enables users to interact with the system easily.

## Command-Line Interface (CLI)

The CLI allows users to execute various operations on the database through simple prompts. Users can choose from options related to OLAP queries, embedded queries, triggers, and transactions. Each option is accompanied by a description, ensuring clarity for the user. This interactive approach enhances usability and accessibility for managing cab service operations.

## Backend (MySQL)

The project uses MySQL as the backend database, where all the data related to drivers, vehicles, customers, payments, and trips are stored. The database schema includes six tables that capture various aspects of the cab service.

### Database Tables

1. **Driver**
   - Stores information about the drivers, including their ID, name, gender, status, and average rating.
   
2. **Vehicle**
   - Contains details of the vehicles, such as the number plate, type, fuel, and maintenance state. This table is linked to the Driver table, allowing for management of vehicles per driver.

3. **Customer**
   - Holds customer information, including their ID, name, email, credit score, and wallet balance.

4. **Trip**
   - Records details about each trip, including trip ID, driver ID, customer ID, fare price, and trip duration.

5. **Payment**
   - Manages payment transactions associated with trips, storing amounts and payment dates.

6. **Ride_Request**
   - Keeps track of ride requests made by customers, storing relevant details such as request status and associated customer and trip IDs.

### Relationships and Deletions

The project employs cascading deletions where appropriate. For example, deleting a driver automatically removes associated vehicles, ensuring referential integrity.

## OLAP Queries

Online Analytical Processing (OLAP) queries are included to facilitate complex data analysis. These queries allow users to perform operations such as roll-ups and slicing, enabling better insights into trip data, driver performance, and customer behavior.

### Example OLAP Queries

- Roll-Up Queries: Aggregate data to provide higher-level summaries.
- Slicing Queries: Filter data based on specific criteria to analyze particular aspects.

## Triggers

Triggers are used to enforce business rules and automate actions in the database. They respond to events such as inserts or updates in tables, allowing for automatic updates to related records or calculations.

### Example Triggers

- **Customer Wallet Updation Trigger**: Adjusts the customer wallet balance when their type changes.
- **Check Gender Trigger**: Ensures that gender is set to a default value if not provided during insertion.

## Transactions

The application supports transactions to ensure data integrity and consistency. Transactions allow a series of operations to be executed as a single unit, either fully completing or rolling back in case of an error.

### Non-Conflicting and Conflicting Transactions

The project implements both non-conflicting and conflicting transactions. Non-conflicting transactions are those that can be executed concurrently without interfering with each other. Conflicting transactions, on the other hand, may require locking mechanisms to ensure that simultaneous operations do not lead to data inconsistencies.

## Conclusion

The Rapid_Cab project showcases a robust implementation of a cab service management system. Through its well-structured database, interactive CLI, and efficient use of triggers and transactions, it provides a comprehensive solution for managing cab operations effectively. This project serves as an excellent example of utilizing DBMS principles in real-world applications.
