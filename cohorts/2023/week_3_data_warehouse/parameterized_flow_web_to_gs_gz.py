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
