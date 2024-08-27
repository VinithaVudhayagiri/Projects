-- Create AWS IAM policy & role with required permissions to the bucket
-- provide the role for creating s3 integration in snowflake
CREATE STORAGE INTEGRATION s3_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::<account>:role/snowflake-read-only'
  STORAGE_ALLOWED_LOCATIONS = ('*');

-- Establish Trust Relationship b/w s3 and SF.
DESC INTEGRATION s3_int;

---> set the Role
USE ROLE accountadmin;

---> set the Warehouse
USE WAREHOUSE compute_wh;


CREATE OR REPLACE DATABASE Analytics ;

---> create the Raw POS (Point-of-Sale) Schema
CREATE OR REPLACE SCHEMA Analytics.BookInsights;
create or replace TABLE Analytics.BookInsights.book_reviews(
    book VARCHAR(200),
    review VARCHAR(50),
    state VARCHAR(20),
    price NUMERIC(5,2)
);

---> create the Stage referencing the Blob location and CSV File Format
CREATE OR REPLACE STAGE Analytics.BookInsights.book_reviews_stage
  STORAGE_INTEGRATION = s3_int
  URL = '<AWS Path>'
  FILE_FORMAT = (type = csv,FIELD_OPTIONALLY_ENCLOSED_BY='"',SKIP_HEADER=1);

---> query the Stage to find the Menu CSV file
LIST @Analytics.BookInsights.book_reviews_stage;

TRUNCATE TABLE Analytics.BookInsights.book_reviews;

COPY INTO Analytics.BookInsights.book_reviews
FROM @Analytics.BookInsights.book_reviews_stage;

SELECT * FROM Analytics.BookInsights.book_reviews;
