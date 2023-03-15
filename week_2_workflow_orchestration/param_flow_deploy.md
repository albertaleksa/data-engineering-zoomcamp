## Parametrizing Flow & Deployments

### Prefect Flows: Parameterized Flow

Will get file `etl_web_to_gcs.py` and parametrize flow:
- Create file `parameterized_flow.py` and to it all from `etl_web_to_gcs.py`
- Add params into the flow `etl_web_to_gcs`:
    ```
    @flow()
    def etl_web_to_gcs(year: int, month: int, color: str) -> None:
        """The Main ETL function"""
        dataset_file = f"{color}_tripdata_{year}-{month:02}"
        dataset_url = f"https://github.com/DataTalksClub/nyc-tlc-data/releases/download/{color}/{dataset_file}.csv.gz"
    
        df = fetch(dataset_url)
        df_clean = clean(df)
        path = write_local(df_clean, color, dataset_file)
        write_gcs(path)
    ```

### Prefect Flows: Orchestrating Subflows with a Parent Flow
- Make a parent flow that will pass these parameters to the etl flow
- and we can set some defaults.
- This way it's able to loop over a list of months and
- run the etl pipeline for each dataset.
  ```
  @flow()
  def etl_parent_flow(months: list[int] = [1, 2], year: int = 2021, color: str = "yellow"):
      for month in months:
          etl_web_to_gcs(year, month, color)
  ```
- Once we have those parameters we can call the parent flow from main:
  ```
  if __name__ == '__main__':
    color = "yellow"
    months = [1, 2, 3]
    year = 2021
    etl_parent_flow(months, year, color)
  ```

### Prefect Task: Caching Strategy for Fetching CSVs from Web
Just for good measure let’s add that caching key back to our fetch() function
```
from prefect.tasks import task_input_hash
from datetime import timedelta
```

```
@task(retries=3, cache_key_fn=task_input_hash, cache_expiration=timedelta(days=1))
def fetch(dataset_url: str) -> pd.DataFrame:
    """Read taxi data from web into pandas DataFrame"""
    # if randint(0, 1) > 0:
    #     raise Exception

    df = pd.read_csv(dataset_url)

    return df
```

### Manually Running the Flow (Web to GCS)
`$ python flows/03_deployments/parameterized_flow.py`

### Prefect Deployment: Overview
https://docs.prefect.io/concepts/deployments/

- A deployment in Prefect is a **server-side** concept 
- that encapsulates a flow, 
- allowing it to be scheduled and triggered via the **API**.

A flow can have **multiple** deployments and you can think of it as the **container** of metadata needed for the flow to be scheduled. This might be what type of infrastructure the flow will run on, or where the flow code is stored, maybe it’s scheduled or has certain parameters.

There are two ways to create a deployment:
1) using the CLI command
2) with python.

### Prefect Deployment: Build & Apply (using CLI)

#### Build:
- In terminal build deployment:
  ```
  $ prefect deployment build flows/03_deployments/parameterized_flow.py:etl_parent_flow -n "Parameterized ETL"
  ```
  It created a yaml file `etl_parent_flow-deployment.yaml` with all our details. This is the metadata. 

  We can adjust the parameters here or in the UI after we apply but let’s just do it here:

- Edit yaml with  parameters: `{ "color": "yellow", "months" :[1, 2, 3], "year": 2021}`

#### Apply the deployment:
- In terminal:
  ```
  $ prefect deployment apply etl_parent_flow-deployment.yaml
  ```
- It's mean send all of the metadata to the prefect API

### Prefect Deployments on Prefect Orion UI
- In Orion UI we can see our Deployment in **Deployments**
- We can **edit** it
- We can **Quick Run** or **Custom Run** deployment


### Prefect Work Queues and Agents
- After triggering a **Quick Run**, it will have a "Scheduled" state under "Flow runs".
- To deploy this workflow for execution, we need an agent.
- Agents consist of lightweight Python processes in our execution environment. They pick up scheduled workflow runs from Work Queues.
- Work Queues coordinate many deployments with many agents by collecting scheduled workflow runs for deployment according to some filtering criteria.
- We launch an agent with the following command. The agent will automatically run our scheduled workflow:
  ```
  $ prefect agent start --work-queue "default"
  ```
- Quit the terminal window with Ctrl+C.

### Prefect Notifications
We can setup a notification.

Go to the Orion UI, select **Notifications** and create a notification.
