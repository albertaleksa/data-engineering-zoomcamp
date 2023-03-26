-- Homework3
-- Preparation
-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `nytaxi.external_fhv_tripdata`
OPTIONS (
  format = 'CSV',
  compression = 'GZIP',
  uris = ['gs://dtc_data_lake_substantial-mix-378619/data/fhv/fhv_tripdata_2019-*.csv.gz']
);

-- Create a non partitioned table from external table
CREATE OR REPLACE TABLE `nytaxi.fhv_tripdata_non_partitoned` AS
SELECT * FROM `nytaxi.external_fhv_tripdata`;

SELECT  *
FROM  `nytaxi.external_fhv_tripdata`
LIMIT 10;

-- Question 1
SELECT  COUNT(*)
FROM  `nytaxi.fhv_tripdata_non_partitoned`;
-- 43244696

-- Question 2
SELECT  DISTINCT(Affiliated_base_number)
FROM   `nytaxi.external_fhv_tripdata`;
-- 0 MB

SELECT  DISTINCT(Affiliated_base_number)
FROM   `nytaxi.fhv_tripdata_non_partitoned`;
-- 317,94 MB

-- Question 3
SELECT  COUNT(*)
FROM  `nytaxi.fhv_tripdata_non_partitoned`
WHERE PUlocationID IS NULL AND DOlocationID IS NULL;
-- 717748

-- Question 4
-- Partition by pickup_datetime Cluster on affiliated_base_number

-- Question 5
-- Creating a partition and cluster table
CREATE OR REPLACE TABLE `nytaxi.fhv_tripdata_partitoned_clustered`
PARTITION BY DATE(pickup_datetime)
CLUSTER BY Affiliated_base_number AS
SELECT * FROM `nytaxi.external_fhv_tripdata`;

SELECT  DISTINCT(Affiliated_base_number)
FROM   `nytaxi.fhv_tripdata_non_partitoned`
WHERE DATE(pickup_datetime) BETWEEN '2019-03-01' AND '2019-03-31';
-- 647.87 MB

SELECT  DISTINCT(Affiliated_base_number)
FROM   `nytaxi.fhv_tripdata_partitoned_clustered`
WHERE DATE(pickup_datetime) BETWEEN '2019-03-01' AND '2019-03-31';
-- 23.05 MB


-- Question 8
-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `nytaxi.external_fhv_parquet`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://dtc_data_lake_substantial-mix-378619/data/fhv/fhv_tripdata_2019-*.parquet']
);

-- Create a non partitioned table from external table
CREATE OR REPLACE TABLE `nytaxi.fhv_parquet` AS
SELECT * FROM `nytaxi.external_fhv_parquet`;

SELECT  COUNT(*)
FROM`nytaxi.external_fhv_parquet`;

SELECT  COUNT(*)
FROM`nytaxi.fhv_parquet`;

