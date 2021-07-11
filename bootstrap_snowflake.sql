-- Create RAW database, all raw data will land here from Airbyte.
CREATE DATABASE DATA_RAW 

-- Create Analytics database (this will be our warehouse and owned by DBT)
CREATE DATABASE DATA_ANALYTICS 

CREATE SCHEMA "DBT_RAW"."RAW_NORTHWINDS" COMMENT = 'Raw landing for the Northwinds product';


--WAREHOUSES -- 

--For Ingestion (Airbyte)
create or replace warehouse sf_ingestion_wh with
  warehouse_size='X-SMALL'
  auto_suspend = 180
  auto_resume = true
  initially_suspended=true;

  --For transformation (DBT)
  create or replace warehouse sf_transformation_wh with
  warehouse_size='X-SMALL'
  auto_suspend = 180
  auto_resume = true
  initially_suspended=true;

--For analtics (Mode)
  create or replace warehouse sf_analytics_wh with
  warehouse_size='X-SMALL'
  auto_suspend = 180
  auto_resume = true
  initially_suspended=true;



  -- ROLES --
  -- set variables (these need to be uppercase)
SET AIRBYTE_ROLE = 'AIRBYTE_ROLE';
SET AIRBYTE_USERNAME = 'AIRBYTE_USER';

-- set user password
SET AIRBYTE_PASSWORD = '-password-';

BEGIN;

-- create Airbyte role
CREATE ROLE IF NOT EXISTS $AIRBYTE_ROLE;

-- create Airbyte user
CREATE USER IF NOT EXISTS $AIRBYTE_USERNAME
PASSWORD = $AIRBYTE_PASSWORD
DEFAULT_ROLE = $AIRBYTE_ROLE
DEFAULT_WAREHOUSE= $AIRBYTE_WAREHOUSE;

-- grant Airbyte schema access
GRANT OWNERSHIP ON SCHEMA $AIRBYTE_SCHEMA TO ROLE $AIRBYTE_ROLE;

COMMIT;