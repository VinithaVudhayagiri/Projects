create storage integration azure_snowflake_integration
    type = external_stage
    storage_provider = azure
    azure_tenant_id = '5fd8c3fb-e858-4d84-956d-3c0bf74e7e98'
    enabled = true
    storage_allowed_locations = ( 'azure://snowflakeazureintegrate.blob.core.windows.net/snowfalkeintegration/');

DESC STORAGE INTEGRATION azure_snowflake_integration;


USE SCHEMA AZUREINTEGRATION;

CREATE STAGE azure_stage
  STORAGE_INTEGRATION = azure_snowflake_integration
  URL = 'azure://snowflakeazureintegrate.blob.core.windows.net/snowfalkeintegration/'
  FILE_FORMAT = (type=json);

CREATE OR REPLACE TABLE TEST_TABLE(
EVENT VARIANT
);
  
COPY INTO TEST_TABLE
  FROM @azure_stage;

select * from test_table;