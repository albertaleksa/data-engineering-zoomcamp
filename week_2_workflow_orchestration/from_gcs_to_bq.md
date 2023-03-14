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

```

### Prefect Task: Load into BigQuery
```

```

### Prefect Task: 
```

```

