## Introduction to Prefect concepts

### What is Prefect?

- modern open-source Dataflow automation platform
- that allow to add observability and orchestration
- by using Python just to write code as Workflows.
- Allow to build, run and monitor this pipeline at scale.

### Installing Prefect
- Create a virtualenv and install dependencies using `venv`
  ```
  python3 -m venv zooomcamp
  # activate env
  source zooomcamp/bin/activate
  ```
  or using `conda`:
  ```
  conda create -n zooomcamp python=<python version>
  # activate env
  conda activate zooomcamp
  ```
- Install requirements from requirements.txt:
  ```
  pip install -r requirements.txt
  ```

  ```
  # requirements.txt:
  pandas==1.5.2
  prefect==2.7.7
  prefect-sqlalchemy==0.2.2
  prefect-gcp[cloud_storage]==0.2.3
  protobuf==4.21.11
  pandas-gbq==0.18.1
  psycopg2-binary==2.9.5
  sqlalchemy==1.4.46
  ```

### Ingest data
Run python script:
```
python ingest_data.py
```

### Transform the Script (ingest_data.py) into a Prefect Flow

- Import modules
  ```
  from prefect import flow, task
  ```
  **flow** - a container of workflow logic, allow to interact and understand the state of the workflow.
  
  **flow** can contain **tasks**

- Add function and move all from `if __name__ == '__main__':` in it
  ```
  @flow(name="Ingest Flow")
  def main_flow():
  ```

- Convert function `ingest_data` into a **task** by adding *decorator* **@task()**
- Run script `python ingest_data.py`. Created flow and task. 

### Prefect Task: Extract Data
- Add task(function) for extraction data and move from function `ingest_data`
code for downloading file and creating Dataframe:
  ```
  @task(log_prints=True, retries=3, cache_key_fn=task_input_hash, cache_expiration=timedelta(days=1))
  def extract_data(url):
  ```
- Add in `def main_flow()`:
  ```
  raw_data = extract_data(csv_url)
  ```
- Add to import:
  ```
  from prefect.tasks import task_input_hash
  from datetime import timedelta
  ```
- `cache_key_fn=task_input_hash` for cashing and making task execution go faster and more efficiently

### Prefect Task: Transform / Data Cleanup
Cleanup data: remove rows with field passenger_count equal to 0
- Create task for transform data:
  ```
  @task(log_prints=True)
  def transform_data(df):
      print(f"pre: missing passenger count: {df['passenger_count'].isin([0]).sum()}")
      df = df[df['passenger_count'] != 0]
      print(f"post: missing passenger count: {df['passenger_count'].isin([0]).sum()}")
  
      return df
  ```
- Add to `main_flow`:
  ```
  data = transform_data(raw_data)
  ```

### Prefect Task: Load Data into Postgres
- Use function `ingest_data` for load data into the Postgres db
- Add connection to the db
- In function `main_flow()` modify:
  ```
  ingest_data(user, password, host, port, db, table_name, data)
  ```

### Prefect Flow: Parameterization & Subflows



* Installing Prefect
* Prefect flow
* Creating an ETL
* Prefect task
* Blocks and collections
* Orion UI

