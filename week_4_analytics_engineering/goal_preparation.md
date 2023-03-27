>[Back to Week Menu](README.md)
>
>Previous Theme: [What is dbt?](what_is_dbt.md)
>
>Next Theme: [Starting a dbt project: Using BigQuery + dbt cloud](dbt_project_bg_dbt_cloud.md)

# Starting a dbt project

## Project's goal & Preparation

### Goal

Transforming the data loaded in DWH to Analytical Views developing a [dbt project](taxi_rides_ny/README.md).

[Slides](https://docs.google.com/presentation/d/1xSll_jv0T8JF4rYZvLHfkJXYqUjPtThA/edit?usp=sharing&ouid=114544032874539580154&rtpof=true&sd=true)

### Prerequisites
We will build a project using dbt and a running data warehouse. 
By this stage of the course you should have already: 
- A running warehouse (BigQuery or postgres) 
- A set of running pipelines ingesting the project dataset (week 3 completed): [Datasets list](https://github.com/DataTalksClub/nyc-tlc-data/)
    * Yellow taxi data - Years 2019 and 2020
    * Green taxi data - Years 2019 and 2020 
    * fhv data - Year 2019. 

#### My Solution
1. Run 5 times deployment `etl-parent-flow/web_gc` from [Preparation for Homework3](../cohorts/2023/week_3_data_warehouse/homework_my_solutions.md#preparation-):
  ```
  $ prefect deployment run etl-parent-flow/web_gc -p "color=fhv" -p "year=2019" -p "months=[1,2,3,4,5,6,7,8,9,10,11,12]"
  $ prefect deployment run etl-parent-flow/web_gc -p "color=yellow" -p "year=2019" -p "months=[1,2,3,4,5,6,7,8,9,10,11,12]"
  $ prefect deployment run etl-parent-flow/web_gc -p "color=green" -p "year=2019" -p "months=[1,2,3,4,5,6,7,8,9,10,11,12]"
  $ prefect deployment run etl-parent-flow/web_gc -p "color=yellow" -p "year=2020" -p "months=[1,2,3,4,5,6,7,8,9,10,11,12]"
  $ prefect deployment run etl-parent-flow/web_gc -p "color=green" -p "year=2020" -p "months=[1,2,3,4,5,6,7,8,9,10,11,12]"
  ```
_Note:_
  *  _A quick hack has been shared to load that data quicker, check instructions in [week3/extras](https://github.com/DataTalksClub/data-engineering-zoomcamp/tree/main/week_3_data_warehouse/extras)_
  * _If you recieve an error stating "Permission denied while globbing file pattern." when attemting to run fact_trips.sql this video may be helpful in resolving the issue_ 
 
 :movie_camera: [Video](https://www.youtube.com/watch?v=kL3ZVNL9Y4A)

_[Back to the top](#starting-a-dbt-project)_