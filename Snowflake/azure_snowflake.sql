-- Create a storage integration to connect Snowflake with Azure Blob Storage
CREATE STORAGE INTEGRATION azure_snowflake_integration
    TYPE = EXTERNAL_STAGE
    STORAGE_PROVIDER = AZURE
    AZURE_TENANT_ID = '<azure_tenant_id>'  -- Replace with your Azure tenant ID
    ENABLED = TRUE
    STORAGE_ALLOWED_LOCATIONS = ( 'azure://<account>.blob.core.windows.net/<folder>/' );

-- Verify the storage integration configuration
DESC STORAGE INTEGRATION azure_snowflake_integration;

-- Use the appropriate schema
USE SCHEMA AZUREINTEGRATION;

-- Create a stage in Snowflake to reference the Azure Blob Storage location
CREATE STAGE azure_stage
  STORAGE_INTEGRATION = azure_snowflake_integration
  URL = 'azure://<account>.blob.core.windows.net/<folder>/'
  FILE_FORMAT = (TYPE = JSON);

-- Create or replace a table to store the data
CREATE OR REPLACE TABLE TEST_TABLE(
  EVENT VARIANT  -- Store JSON data in the VARIANT column
);

-- Copy data from Azure Blob Storage into the Snowflake table
COPY INTO TEST_TABLE
  FROM @azure_stage;

-- Query the table to view the copied data
SELECT * FROM TEST_TABLE;
