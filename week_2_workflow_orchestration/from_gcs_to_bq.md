>[Back to Week Menu](README.md)
>
>Previous Theme: [ETL with GCP & Prefect](etl_gcp_prefect.md)
>
>Next Theme: [Parametrizing Flow & Deployments](param_flow_deploy.md)

## From Google Cloud Storage to Big Query

## Flow 2: From GCS to BigQuery

### Scenario explanation:
- In dir `02_gcp` create file `etl_gcs_to_bq.py`:
  - Will get data from **Google Cloud Storage**
  - Put it into **Big Query**


### Prefect Flow: GCS to BigQuery
```
@flow()
def etl_gcs_to_bq():
    """Main ETL flow to load data into Big Query"""
    color = "yellow"
    year = 2021
    month = 1

    path = extract_from_gcs(color, year, month)
    df = transform(path)
    write_bq(df)
```

### Prefect Task: Extract from GCS
```
@task(retries=3)
def extract_from_gcs(color: str, year: int, month: int) -> Path:
    """Download trip data from GCS"""
    gcs_path = f"data/{color}/{color}_tripdata_{year}-{month:02}.parquet"
    gcs_block = GcsBucket.load("zoom-gcs")
    gcs_block.get_directory(from_path=gcs_path, local_path=f"./")

    return Path(f"../data/{gcs_path}")
```

### Prefect Task: Data Transformation
```
@task(log_prints=True)
def transform(path: Path) -> pd.DataFrame:
    """Data cleaning example"""
    df = pd.read_parquet(path)
    print(f"pre: missing passenger count: {df['passenger_count'].isna().sum()}")
    df['passenger_count'].fillna(0, inplace=True)
    print(f"post: missing passenger count: {df['passenger_count'].isna().sum()}")

    return df
```

### BigQuery: Overview & Data Import from GCS
In Google Cloud Platform:
> Big Query -> Add Data -> Choose source: Google Cloud Storage ->
> 
> Select file from GCS bucket or use a URI pattern: Choose our *.parquet file
> 
> Dataset: Create New Dataset or choose existed
> 
> Table: rides
> 
> Create table

Got to the created table `rides` and delete all data using SQL. 


### Prefect Task: Load into BigQuery
```
@task()
def write_bq(df: pd.DataFrame) -> None:
    """Write DataFrame to BigQuery"""
    gcp_credentials_block = GcpCredentials.load("zoom-gcp-creds")

    df.to_gbq(
        destination_table="trips_data_all.rides",
        project_id="substantial-mix-378619",
        credentials=gcp_credentials_block.get_credentials_from_service_account(),
        chunksize=500_000,
        if_exists="append"
    )
```

_[Back to the top](#from-google-cloud-storage-to-big-query)_
