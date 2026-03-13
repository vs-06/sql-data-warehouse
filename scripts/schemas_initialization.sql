/*
===========================
This Script is used to create schemas of bronze, silver, and gold layers. It does not check if the table exists already and all it's related operations.
===========================
*/

CREATE DATABASE DataWarehouse;
USE DataWarehouse;

/* Creating Schemas */

CREATE SCHEMA dw_bronze;
CREATE SCHEMA dw_silver;
CREATE SCHEMA dw_gold;

DROP SCHEMA bronze;
DROP SCHEMA silver;
DROP SCHEMA gold;
DROP SCHEMA DataWarehouse;

/* NOTE: I was trying to create schemas inside DataWarehouse database, but MySQL doesn't suport that. In MySQL, both database and schema refers to same thing, so I created schemas with "dw_" suffix.
