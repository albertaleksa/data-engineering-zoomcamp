>[Back to Main Homework page](../README.md)
>
>[Back to Week 3 Main page](../../../week_3_data_warehouse/README.md)
>
> [Homework without solutions](homework.md)

## Week 3 Homework
<b><u>Important Note:</b></u> <p>You can load the data however you would like, but keep the files in .GZ Format. 
If you are using orchestration such as Airflow or Prefect do not load the data into Big Query using the orchestrator.</br> 
Stop with loading the files into a bucket. </br></br>
<u>NOTE:</u> You can use the CSV option for the GZ files when creating an External Table</br>

<b>SETUP:</b></br>
Create an external table using the fhv 2019 data. </br>
Create a table in BQ using the fhv 2019 data (do not partition or cluster this table). </br>
Data can be found here: https://github.com/DataTalksClub/nyc-tlc-data/releases/tag/fhv </p>

### Preparation:
1. Create file `parameterized_flow_web_to_gs_gz.py` for load data into Cloud Storage:
    ```python
    from pathlib import Path
    from prefect import flow, task
    # for getting data into Google Cloud
    from prefect_gcp.cloud_storage import GcsBucket
    
    import os
    
    
    # @task(retries=3, cache_key_fn=task_input_hash, cache_expiration=timedelta(days=1))
    @task(retries=3, log_prints=True)
    def load(dataset_url: str, color: str, dataset_file: str) -> Path:
        """Load data to local"""
        path = Path(f"data/{color}/{dataset_file}.csv.gz")
        os.system(f"wget {dataset_url} -O {path}")
        print(path)
    
        return path
    
    
    @task()
    def write_gcs(path: Path) -> None:
        """Upload local file to GCS"""
        gcs_block = GcsBucket.load("zoom-gcs")
        gcs_block.upload_from_path(from_path=path, to_path=path, timeout=120)
    
        return
    
    
    @flow()
    def etl_web_to_gcs(year: int, month: int, color: str) -> None:
        """The Main ETL function"""
        dataset_file = f"{color}_tripdata_{year}-{month:02}"
        dataset_url = f"https://github.com/DataTalksClub/nyc-tlc-data/releases/download/{color}/{dataset_file}.csv.gz"
    
        path = load(dataset_url, color, dataset_file)
        write_gcs(path)
    
    
    @flow()
    def etl_parent_flow(months: list[int] = [1, 2], year: int = 2021, color: str = "yellow"):
        for month in months:
            etl_web_to_gcs(year, month, color)
    
    
    if __name__ == '__main__':
        color = "yellow"
        months = [1, 2, 3]
        year = 2021
        etl_parent_flow(months, year, color)
    
    ```
2. Go to the dir with week_3 homework:
    ```
    $ cd cohorts/2023/week_3_data_warehouse
    ```
3. Create dir `data/fhv` (will be error without it):
   ```
   $ mkdir -p data/fhv 
   ```
4. Build and apply deployment:
   ```
   $ prefect deployment build parameterized_flow_web_to_gs_gz.py:etl_parent_flow -n web_gc -a
   ```
   - P.S. Should be run Prefect UI:
   ```
   $ prefect orion start
   ```
   - And Prefect agent:
   ```
   $ prefect agent start --work-queue "default"
   ```
5. Run deployment:
   ```
   $ prefect deployment run etl-parent-flow/web_gc -p "color=fhv" -p "year=2019" -p "months=[1,2,3,4,5,6,7,8,9,10,11,12]"
   ```
6. Create external table referring to gcs path:
   ```sql
   CREATE OR REPLACE EXTERNAL TABLE `nytaxi.external_fhv_tripdata`
   OPTIONS (
     format = 'CSV',
     compression = 'GZIP',
     uris = ['gs://dtc_data_lake_substantial-mix-378619/data/fhv/fhv_tripdata_2019-*.csv.gz']
   );
   ```
7. Create a non partitioned table from external table:
   ```sql
   CREATE OR REPLACE TABLE `nytaxi.external_fhv_tripdata_non_partitoned` AS
   SELECT * FROM `nytaxi.external_fhv_tripdata`;
   ```


## Question 1:
What is the count for fhv vehicle records for year 2019?
- 65,623,481
  - 43,244,696
- 22,978,333
- 13,942,414

### Solution:
   ```sql
   SELECT  COUNT(*)
   FROM  `nytaxi.external_fhv_tripdata`;
   ```
### Result:
* 43 244 696

## Question 2:
Write a query to count the distinct number of affiliated_base_number for the entire dataset on both the tables.</br> 
What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?

- 25.2 MB for the External Table and 100.87MB for the BQ Table
- 225.82 MB for the External Table and 47.60MB for the BQ Table
- 0 MB for the External Table and 0MB for the BQ Table
  - 0 MB for the External Table and 317.94MB for the BQ Table 

### Solution:
   ```sql
   SELECT  DISTINCT(Affiliated_base_number)
   FROM   `nytaxi.external_fhv_tripdata`;
   -- 0 MB
   
   SELECT  DISTINCT(Affiliated_base_number)
   FROM   `nytaxi.fhv_tripdata_non_partitoned`;
   -- 317,94 MB
   ```
### Result:
* 0 MB for the External Table and 317.94MB for the BQ Table

## Question 3:
How many records have both a blank (null) PUlocationID and DOlocationID in the entire dataset?
* - 717,748
- 1,215,687
- 5
- 20,332


### Solution:
   ```sql
   SELECT  COUNT(*)
   FROM  `nytaxi.fhv_tripdata_non_partitoned`
   WHERE PUlocationID IS NULL AND DOlocationID IS NULL;
   ```
### Result:
* 717 748

## Question 4:
What is the best strategy to optimize the table if query always filter by pickup_datetime and order by affiliated_base_number?
- Cluster on pickup_datetime Cluster on affiliated_base_number
  - Partition by pickup_datetime Cluster on affiliated_base_number
- Partition by pickup_datetime Partition by affiliated_base_number
- Partition by affiliated_base_number Cluster on pickup_datetime

### Solution:
- Partition by pickup_datetime Cluster on affiliated_base_number

## Question 5:
Implement the optimized solution you chose for question 4. Write a query to retrieve the distinct affiliated_base_number between pickup_datetime 2019/03/01 and 2019/03/31 (inclusive).</br> 
Use the BQ table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 4 and note the estimated bytes processed. What are these values? Choose the answer which most closely matches.
- 12.82 MB for non-partitioned table and 647.87 MB for the partitioned table
  - 647.87 MB for non-partitioned table and 23.06 MB for the partitioned table
- 582.63 MB for non-partitioned table and 0 MB for the partitioned table
- 646.25 MB for non-partitioned table and 646.25 MB for the partitioned table

### Solution:
   ```sql
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
   ```
### Result:
* 647.87 MB for non-partitioned table and 23.06 MB for the partitioned table


## Question 6: 
Where is the data stored in the External Table you created?

- Big Query
  - GCP Bucket
- Container Registry
- Big Table

### Solution:
* GCP Bucket

## Question 7:
It is best practice in Big Query to always cluster your data:
- True
  - False

### Solution:
* False

## (Not required) Question 8:
A better format to store these files may be parquet. Create a data pipeline to download the gzip files and convert them into parquet. Upload the files to your GCP Bucket and create an External and BQ Table. 


Note: Column types for all files used in an External Table must have the same datatype. While an External Table may be created and shown in the side panel in Big Query, this will need to be validated by running a count query on the External Table to check if any errors occur. 
 

### Solution:
1. Create file `parameterized_flow_web_to_gs_parquet.py` for load parquet data into Cloud Storage:
    ```python
    from pathlib import Path
    import pandas as pd
    from prefect import flow, task
    # for getting data into Google Cloud
    from prefect_gcp.cloud_storage import GcsBucket
    
    
    # @task(retries=3, cache_key_fn=task_input_hash, cache_expiration=timedelta(days=1))
    @task(retries=3)
    def fetch(dataset_url: str) -> pd.DataFrame:
        """Read taxi data from web into pandas DataFrame"""
        df = pd.read_csv(dataset_url)
    
        return df
    
    
    @task(log_prints=True)
    def clean(df: pd.DataFrame, color: str) -> pd.DataFrame:
        """Fix dtype issues"""
        if color == "yellow":
            df['tpep_pickup_datetime'] = pd.to_datetime(df['tpep_pickup_datetime'])
            df['tpep_dropoff_datetime'] = pd.to_datetime(df['tpep_dropoff_datetime'])
            df['VendorID'] = df['VendorID'].astype('Int64')
        elif color == "green":
            df['lpep_pickup_datetime'] = pd.to_datetime(df['lpep_pickup_datetime'])
            df['lpep_dropoff_datetime'] = pd.to_datetime(df['lpep_dropoff_datetime'])
            df['VendorID'] = df['VendorID'].astype('Int64')
        else:
            df['pickup_datetime'] = pd.to_datetime(df['pickup_datetime'])
            df['dropOff_datetime'] = pd.to_datetime(df['dropOff_datetime'])
            df['PUlocationID'] = df['PUlocationID'].astype('Int64')
            df['DOlocationID'] = df['DOlocationID'].astype('Int64')
            df['SR_Flag'] = df['SR_Flag'].astype('Int64')
    
        print(df.head(2))
        print(f"columns: {df.dtypes}")
        print(f"rows: {len(df)}")
    
        return df
    
    
    @task()
    def write_local(df: pd.DataFrame, color: str, dataset_file: str) -> Path:
        """Write DataFrame out locally as parquet file"""
        path = Path(f"data/{color}/{dataset_file}.parquet")
        df.to_parquet(path, compression="gzip")
    
        return path
    
    
    @task()
    def write_gcs(path: Path) -> None:
        """Upload local parquet file to GCS"""
        gcs_block = GcsBucket.load("zoom-gcs")
        gcs_block.upload_from_path(from_path=path, to_path=path, timeout=120)
    
        return
    
    
    @flow()
    def etl_web_to_gcs(year: int, month: int, color: str) -> None:
        """The Main ETL function"""
        dataset_file = f"{color}_tripdata_{year}-{month:02}"
        dataset_url = f"https://github.com/DataTalksClub/nyc-tlc-data/releases/download/{color}/{dataset_file}.csv.gz"
    
        df = fetch(dataset_url)
        df_clean = clean(df, color)
        path = write_local(df_clean, color, dataset_file)
        write_gcs(path)
    
    
    @flow()
    def etl_parent_flow(months: list[int] = [1, 2], year: int = 2021, color: str = "yellow"):
        for month in months:
            etl_web_to_gcs(year, month, color)
    
    
    if __name__ == '__main__':
        color = "yellow"
        months = [1, 2, 3]
        year = 2021
        etl_parent_flow(months, year, color)

    ```
2. Go to the dir with week_3 homework:
    ```
    $ cd cohorts/2023/week_3_data_warehouse
    ```
3. Create dir `data/fhv` if needed (will be error without it):
   ```
   $ mkdir -p data/fhv 
   ```
4. Build and apply deployment:
   ```
   $ prefect deployment build parameterized_flow_web_to_gs_parquet.py:etl_parent_flow -n web_gc_parquet -a
   ```
   - P.S. Should be run Prefect UI:
   ```
   $ prefect orion start
   ```
   - And Prefect agent:
   ```
   $ prefect agent start --work-queue "default"
   ```
5. Run deployment:
   ```
   $ prefect deployment run etl-parent-flow/web_gc_parquet -p "color=fhv" -p "year=2019" -p "months=[1,2,3,4,5,6,7,8,9,10,11,12]"
   ```
6. Create external table referring to gcs path (from parquet files):
   ```sql
    CREATE OR REPLACE EXTERNAL TABLE `nytaxi.external_fhv_parquet`
    OPTIONS (
      format = 'PARQUET',
      uris = ['gs://dtc_data_lake_substantial-mix-378619/data/fhv/fhv_tripdata_2019-*.parquet']
    );
   ```
7. Create a materialized table from external table:
   ```sql
    CREATE OR REPLACE TABLE `nytaxi.fhv_parquet` AS
    SELECT * FROM `nytaxi.external_fhv_parquet`;
   ```
8. Check count:
    ```sql
    SELECT  COUNT(*)
    FROM`nytaxi.external_fhv_parquet`;
    
    SELECT  COUNT(*)
    FROM`nytaxi.fhv_parquet`;
    ```


## Submitting the solutions

* Form for submitting: https://forms.gle/rLdvQW2igsAT73HTA
* You can submit your homework multiple times. In this case, only the last submission will be used. 

Deadline: 13 February (Monday), 22:00 CET


## Solution

Solution: https://www.youtube.com/watch?v=j8r2OigKBWE

_[Back to the top](#week-3-homework)_