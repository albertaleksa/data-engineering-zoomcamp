-- Query public available table
SELECT station_id, name
FROM bigquery-public-data.new_york_citibike.citibike_stations
LIMIT 100;


-- Creating external table referring to gcs path
CREATE
OR REPLACE EXTERNAL TABLE `nytaxi.external_yellow_tripdata`
OPTIONS (
  format = 'CSV',
  uris = ['gs://dtc_data_lake_substantial-mix-378619/data/yellow/yellow_tripdata_2019-*.csv', 'gs://dtc_data_lake_substantial-mix-378619/data/yellow/yellow_tripdata_2021-*.csv']
);

-- Check yello trip data
SELECT *
FROM nytaxi.external_yellow_tripdata limit 10;

-- Create a non partitioned table from external table
CREATE
OR REPLACE TABLE nytaxi.yellow_tripdata_non_partitoned AS
SELECT *
FROM nytaxi.external_yellow_tripdata;


-- Create a partitioned table from external table
CREATE
OR REPLACE TABLE nytaxi.yellow_tripdata_partitoned
PARTITION BY
  DATE(tpep_pickup_datetime) AS
SELECT *
FROM nytaxi.external_yellow_tripdata;

-- Impact of partition
-- Scanning 276 MB of data
SELECT DISTINCT(VendorID)
FROM nytaxi.yellow_tripdata_non_partitoned
WHERE DATE (tpep_pickup_datetime) BETWEEN '2019-03-01' AND '2019-03-10';

-- Scanning ~40 MB of DATA
SELECT DISTINCT(VendorID)
FROM nytaxi.yellow_tripdata_partitoned
WHERE DATE (tpep_pickup_datetime) BETWEEN '2019-03-01' AND '2019-03-10';

-- Let''s look into the partitons
SELECT table_name, partition_id, total_rows
FROM `nytaxi.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name = ''yellow_tripdata_partitoned''
ORDER BY total_rows DESC;

-- Creating a partition and cluster table
CREATE
OR REPLACE TABLE nytaxi.yellow_tripdata_partitoned_clustered
PARTITION BY DATE(tpep_pickup_datetime)
CLUSTER BY VendorID AS
SELECT *
FROM nytaxi.external_yellow_tripdata;

-- Query scans 255.1 MB
SELECT count(*) as trips
FROM nytaxi.yellow_tripdata_partitoned
WHERE DATE (tpep_pickup_datetime) BETWEEN '2019-03-01' AND '2021-01-31'
  AND VendorID=1;

-- Query scans 196.51 MB
SELECT count(*) as trips
FROM nytaxi.yellow_tripdata_partitoned_clustered
WHERE DATE (tpep_pickup_datetime) BETWEEN '2019-03-01' AND '2021-01-31'
  AND VendorID=1;
