>[Back to Week Menu](README.md)
>
>Previous Theme: [Parametrizing Flow & Deployments](param_flow_deploy.md)
>
> [Homework](../cohorts/2023/week_2_workflow_orchestration/homework.md)

## Schedules & Docker Storage with Infrastructure

### Scheduling Flows on Orion UI
In Orion UI:
- Choose deployment
- **Add** under the **Schedule**
- Set interval (i.e. every 5 min)
- or use **cron**

### Scheduling when creating Deployments (via CLI)
Alternatively, we can also use the set the --cron parameter during deployment.:
```
$ prefect deployment build flows/03_deployments/parameterized_flow.py:etl_parent_flow -n etl2 --cron "0 0 * * *" -a
```

### Scheduling after you've created a Deployment (via CLI)
For example:
```
$ prefect deployment set-schedule [OPTIONS] NAME
```

### Running Prefect Flows on Docker Containers
We can use Docker images to make our workflows production-ready.

First, we write a Dockerfile for our workflow, then login to DockerHub, create an image repository, and finally push the image.

### Docker Containers: Dockerfile, Build and Publish

- Create file `docker-requirements.txt` and copy in it some libs from `requirements.txt`:
    ```
    pandas==1.5.2
    prefect-gcp[cloud_storage]==0.2.3
    protobuf==4.21.11
    pyarrow==10.0.1
    ```
- Create Dockerfile:
  ```
  FROM prefecthq/prefect:2.7.7-python3.9
  
  COPY docker-requirements.txt .
  
  RUN pip install -r docker-requirements.txt --trusted-host pypi.python.org --no-cache-dir
  
  COPY flows /opt/prefect/flows
  RUN mkdir -p /opt/prefect/data/yellow
  ```
- Build docker image:
  ```
  $ docker image build -t dreadyo/prefect:zoom .
  ```
  where `dreadyo` my DockerHub username 

- Push that image to my DockerHub:
  ```
  $ docker login -u dreadyo
  $ docker image push dreadyo/prefect:zoom
  ```

### Prefect Blocks: Docker Container
- In `UI Orion` create Docker Container:
  > Blocks -> Docker Container -> Add:
  > > Block Name: zoom
  > > 
  > > Image (Optional): dreadyo/prefect:zoom
  > >
  > > ImagePullPolicy (Optional): ALWAYS
  > >
  > > Auto Remove (Optional): ON
  > 
  > -> Create
- It is also possible to create blocks using Python code.
File `make_docker_block.py`:
  ```
  from prefect.infrastructure.docker import DockerContainer
  
  # alternative to creating DockerContainer block in the UI
  docker_block = DockerContainer(
      image="dreadyo/prefect:zoom",  # insert your image here
      image_pull_policy="ALWAYS",
      auto_remove=True,
  )
  
  docker_block.save("zoom", overwrite=True)
  ```

### Prefect Deployment from a Python Script
- Create file `docker_deploy.py` in `/flows/03_deployments/`:
  ```
  from prefect.deployments import Deployment
  from prefect.infrastructure.docker import DockerContainer
  from parameterized_flow import etl_parent_flow
  
  docker_block = DockerContainer.load("zoom")
  
  docker_dep = Deployment.build_from_flow(
      flow=etl_parent_flow,
      name="docker-flow",
      infrastructure=docker_block
  )
  
  if __name__ == '__main__':
      docker_dep.apply()
  ```
- Run:
  ```
  $ python flows/03_deployments/docker_deploy.py
  ```
- Go to the `Orion UI`, select **Deployments** in the the menu. We should see the docker-flow

### Prefect Profiles (Docker Container - Orion Server Integration)
- See a list of available profiles:
  ```
  $ prefect profile ls
  ```
- Use a local `Orion API Server`:
  ```
  $ prefect config set PREFECT_API_URL="http://127.0.0.1:4200/api"
  ```
  
### Prefect Agent & Workflow run in a Docker Container
- Start agent:
  ```
  $ prefect agent start -q default
  ```
- We could run our flow from `Orion UI` or from **command line**. Here is how to do with command line:
  ```
  $ prefect deployment run etl-parent-flow/docker-flow -p "months=[1,2]"
  ```
### Problems
I had a problem with **crashed** flow:
> prefect.agent - Reported flow run 'f1b53a94-9f52-45b9-a0a3-e8f315639bb4' as crashed: Flow run infrastructure exited with non-zero status code 137.

To avoid it I had to remove *caching* from **fetch** task from file `parameterized_flow.py`


### Conclusion (what we've done):
1) Brought our code into a Docker container and a Docker image
2) Put that Docker image into our DockerHub
3) Ran that code in Docker container on our local machine.

_[Back to the top](#schedules--docker-storage-with-infrastructure)_