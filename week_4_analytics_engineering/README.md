>[Back to Main course page](../README.md)
>
>Previous Week: [3: Data Warehouse](../week_3_data_warehouse/README.md)
>
>Next Week: [5: Batch processing](../week_5_batch_processing/README.md)


## Week 4: Analytics Engineering 

### Table of contents
- [Introduction to Analytics Engineering](#introduction-to-analytics-engineering)
- [What is dbt?](#what-is-dbt)
- [Starting a dbt project](#starting-a-dbt-project)
- [Development of dbt models](#development-of-dbt-models)
- [Testing and documenting dbt models](#testing-and-documenting-dbt-models)
- [Deployment of a dbt project](#deployment-of-a-dbt-project)
- [Data visualization](#data-visualization)
- [Advanced knowledge](#advanced-knowledge-)
- [Homework](#homework)
- [Workshop: Maximizing Confidence in Your Data Model Changes with dbt and PipeRider](#workshop--maximizing-confidence-in-your-data-model-changes-with-dbt-and-piperider)
- [Community notes](#community-notes)
- [Useful links](#useful-links)


- [Slides](https://docs.google.com/presentation/d/1xSll_jv0T8JF4rYZvLHfkJXYqUjPtThA/edit?usp=sharing&ouid=114544032874539580154&rtpof=true&sd=true) 

_[Back to the top](#table-of-contents)_

### [Introduction to Analytics Engineering](intro_analytics_engineering.md)
- What is analytics engineering?
- ETL vs ELT 
- Data modeling concepts (fact and dim tables)

 :movie_camera: [Video](https://www.youtube.com/watch?v=uF76d5EmdtU&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=32)

_[Back to the top](#table-of-contents)_

### [What is dbt?](what_is_dbt.md)
 * Intro to dbt 

 :movie_camera: [Video](https://www.youtube.com/watch?v=4eCouvVOJUw&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=33)

_[Back to the top](#table-of-contents)_

### Starting a dbt project
- #### [Project's goal & Preparation](goal_preparation.md)

- #### [Alternative a: Using BigQuery + dbt cloud](dbt_project_bg_dbt_cloud.md)
  * Starting a new project with dbt init (dbt cloud and core)
  * dbt cloud setup
  * project.yml

   :movie_camera: [Video](https://www.youtube.com/watch?v=iMxh6s_wL4Q&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=34)
 
- #### [Alternative b: Using Postgres + dbt core (locally)](dbt_project_pg_dbt_core.md)
  * Starting a new project with dbt init (dbt cloud and core)
  * dbt core local setup
  * profiles.yml
  * project.yml

   :movie_camera: [Video](https://www.youtube.com/watch?v=1HmL63e-vRs&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=35)

_[Back to the top](#table-of-contents)_

### [Development of dbt models](dev_dbt_models.md)
 * Anatomy of a dbt model: written code vs compiled Sources
 * Materialisations: table, view, incremental, ephemeral  
 * Seeds, sources and ref  
 * Jinja and Macros 
 * Packages 
 * Variables

 :movie_camera: [Video](https://www.youtube.com/watch?v=UVI30Vxzd6c&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=36)

_Note: This video is shown entirely on dbt cloud IDE but the same steps can be followed locally on the IDE of your choice_

_[Back to the top](#table-of-contents)_

### [Testing and documenting dbt models](test_doc_dbt_models.md)
 * Tests  
 * Documentation 

 :movie_camera: [Video](https://www.youtube.com/watch?v=UishFmq1hLM&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=37)

_Note: This video is shown entirely on dbt cloud IDE but the same steps can be followed locally on the IDE of your choice_

_[Back to the top](#table-of-contents)_

### [Deployment of a dbt project](dbt_deployment.md)
- #### Alternative a: Using BigQuery + dbt cloud
  * Deployment: development environment vs production 
  * dbt cloud: scheduler, sources and hosted documentation

  :movie_camera: [Video](https://www.youtube.com/watch?v=rjf6yZNGX8I&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=38)
  
- #### Alternative b: Using Postgres + dbt core (locally)
  * Deployment: development environment vs production 
  * dbt cloud: scheduler, sources and hosted documentation

  :movie_camera: [Video](https://www.youtube.com/watch?v=Cs9Od1pcrzM&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=39)

_[Back to the top](#table-of-contents)_

### [Data visualization](data_visualization.md)
- #### Google Data Studio

  :movie_camera: [Video](https://www.youtube.com/watch?v=39nLTs74A3E&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=42) 
- #### Metabase (local installation)

  :movie_camera: [Video](https://www.youtube.com/watch?v=BnLkrA7a6gM&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=43) 

_[Back to the top](#table-of-contents)_
 
### Advanced knowledge:
 * [Make a model Incremental](https://docs.getdbt.com/docs/building-a-dbt-project/building-models/configuring-incremental-models)
 * [Use of tags](https://docs.getdbt.com/reference/resource-configs/tags)
 * [Hooks](https://docs.getdbt.com/docs/building-a-dbt-project/hooks-operations)
 * [Analysis](https://docs.getdbt.com/docs/building-a-dbt-project/analyses)
 * [Snapshots](https://docs.getdbt.com/docs/building-a-dbt-project/snapshots)
 * [Exposure](https://docs.getdbt.com/docs/building-a-dbt-project/exposures)
 * [Metrics](https://docs.getdbt.com/docs/building-a-dbt-project/metrics)

_[Back to the top](#table-of-contents)_

### [Homework](../cohorts/2023/week_4_analytics_engineering/homework.md)

_[Back to the top](#table-of-contents)_

## Workshop: Maximizing Confidence in Your Data Model Changes with dbt and PipeRider

To learn how to use PipeRider together with dbt for detecting changes in model and data, sign up for a workshop [here](https://www.eventbrite.com/e/maximizing-confidence-in-your-data-model-changes-with-dbt-and-piperider-tickets-535584366257)

[More details](../cohorts/2023/workshops/piperider.md)

_[Back to the top](#table-of-contents)_

## Community notes

Did you take notes? You can share them here.

* [Notes by Alvaro Navas](https://github.com/ziritrion/dataeng-zoomcamp/blob/main/notes/4_analytics.md)
* [Sandy's DE learning blog](https://learningdataengineering540969211.wordpress.com/2022/02/17/week-4-setting-up-dbt-cloud-with-bigquery/)
* [Notes by Victor Padilha](https://github.com/padilha/de-zoomcamp/tree/master/week4)
* [Marcos Torregrosa's blog (spanish)](https://www.n4gash.com/2023/data-engineering-zoomcamp-semana-4/)
* [Notes by froukje](https://github.com/froukje/de-zoomcamp/blob/main/week_4_analytics_engineering/notes/notes_week_04.md)
* [Notes by Alain Boisvert](https://github.com/boisalai/de-zoomcamp-2023/blob/main/week4.md)
* [Setting up Prefect with dbt by Vera](https://medium.com/@verazabeida/zoomcamp-week-5-5b6a9d53a3a0)
* [Blog by Xia He-Bleinagel](https://xiahe-bleinagel.com/2023/02/week-4-data-engineering-zoomcamp-notes-analytics-engineering-and-dbt/)
* [Setting up DBT with BigQuery by Tofag](https://medium.com/@fagbuyit/setting-up-your-dbt-cloud-dej-9-d18e5b7c96ba)
* [Blog post by Dewi Oktaviani](https://medium.com/@oktavianidewi/de-zoomcamp-2023-learning-week-4-analytics-engineering-with-dbt-53f781803d3e)
* [Notes from Vincenzo Galante](https://binchentso.notion.site/Data-Talks-Club-Data-Engineering-Zoomcamp-8699af8e7ff94ec49e6f9bdec8eb69fd)
* [Notes from Balaji](https://github.com/Balajirvp/DE-Zoomcamp/blob/main/Week%204/Data%20Engineering%20Zoomcamp%20Week%204.ipynb)
* Add your notes here (above this line)

## Useful links

- [Visualizing data with Metabase course](https://www.metabase.com/learn/visualization/)

_[Back to the top](#table-of-contents)_