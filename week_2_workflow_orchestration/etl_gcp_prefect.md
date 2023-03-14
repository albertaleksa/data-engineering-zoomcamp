## ETL with GCP & Prefect

## Flow 1: Putting data to Google Cloud Storage

### Scenario explanation
- Create dir `02_gcp`
- Create file `etl_web_to_gcs.py`:
  - **Main** flow function, will call a number of other functions (task functions)
  - Will take the data from the web `*.csv` file
  - cleanup
  - save as a `*.parquet` file in **Data Lake** in GCP

### Prefect Flow: pandas DataFrame to Google Cloud Storage
```
@flow()
def etl_web_to_gcs() -> None:
    """The Main ETL function"""
    color = "yellow"
    year = 2021
    month = 1
    dataset_file = f"{color}_tripdata_{year}-{month:02}"
    dataset_url = f"https://github.com/DataTalksClub/nyc-tlc-data/releases/download/{color}/{dataset_file}.csv.gz"

    df = fetch(dataset_url)
    df_clean = clean(df)
```

### Prefect Task: Extract Dataset from the Web with retries
```
@task(retries=3)
def fetch(dataset_url: str) -> pd.DataFrame:
    """Read taxi data from web into pandas DataFrame"""
    # if randint(0, 1) > 0:
    #     raise Exception

    df = pd.read_csv(dataset_url)
    return df
```

### Prefect Task: Data Cleanup
```
@task(log_prints=True)
def clean(df: pd.DataFrame) -> pd.DataFrame:
    """Fix dtype issues"""
    df['tpep_pickup_datetime'] = pd.to_datetime(df['tpep_pickup_datetime'])
    df['tpep_dropoff_datetime'] = pd.to_datetime(df['tpep_dropoff_datetime'])
    print(df.head(2))
    print(f"columns: {df.dtypes}")
    print(f"rows: {len(df)}")
    return df
```

### Prefect Task: Write to Local Filesystem
```
@task()
def write_local(df: pd.DataFrame, color: str, dataset_file: str) -> Path:
    """Write DataFrame out locally as parquet file"""
    path = Path(f"data/{color}/{dataset_file}.parquet")
    df.to_parquet(path, compression="gzip")
    return path
```

### Prefect Blocks: GCS Bucket
To use GCP Blocks is needed to register them before:
```
$ prefect block register -m prefect_gcp
```
In Prefect Orion UI:
> Blocks -> Add Block -> GCS Bucket -> Add +

> Block Name: zoom-gcs
> 
> Bucket: <Name of the Bucket (get from GCP or create)>
> 
> Gcp Credentials (Optional): Add + (to create Block for GCP Credentials)
> > Block Name: zoom-gcp-creds
> >
> > SService Account Info (Optional):
> >
> > Copy info key for Service account from *.json key-file (Service account in GCP should have roles: Storage Admin + BigQuery Admin)
> 
> Choose created Block zoom-gcp-creds
> 
> -> Create

### Prefect Task: Write to GCS
```
@task()
def write_gcs(path: Path) -> None:
    """Upload local parquet file to GCS"""
    gcs_block = GcsBucket.load("zoom-gcs")
    gcs_block.upload_from_path(from_path=f"{path}", to_path=path)
    return
```
Then file will appear in the GCP Bucket