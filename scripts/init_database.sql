/*
===============================================================================
Create Database and Schemas
===============================================================================

Script Purpose:
    This script creates a new database named 'DataWarehouse' after checking
    if it already exists.

    If the database exists, it is dropped and recreated. Additionally, the
    script sets up three schemas within the database:
    'bronze', 'silver', and 'gold'.

WARNING:
    Running this script will drop the entire 'DataWarehouse' database if it
    exists.

    All data in the database will be permanently deleted. Proceed with caution
    and ensure you have proper backups before running this script.
*/


-- ============================================================================
-- Create Database
-- ============================================================================

USE master;
GO

-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (
    SELECT 1
    FROM sys.databases
    WHERE name = 'DataWarehouse'
)
BEGIN
    ALTER DATABASE DataWarehouse
        SET SINGLE_USER
        WITH ROLLBACK IMMEDIATE;

    DROP DATABASE DataWarehouse;
END;
GO


-- Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO


-- ============================================================================
-- Create Schemas
-- ============================================================================

USE DataWarehouse;
GO

-- Create Bronze Schema
CREATE SCHEMA bronze;
GO

-- Create Silver Schema
CREATE SCHEMA silver;
GO

-- Create Gold Schema
CREATE SCHEMA gold;
GO
