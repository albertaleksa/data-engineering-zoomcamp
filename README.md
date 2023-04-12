# Data Engineering Zoomcamp
Original content: https://github.com/DataTalksClub/data-engineering-zoomcamp

### Table of contents

- [Syllabus](#syllabus)
  - [Week 1: Introduction & Prerequisites](#week-1-introduction--prerequisites)
  - [Week 2: Workflow Orchestration](#week-2-workflow-orchestration)
  - [Week 3: Data Warehouse](#week-3-data-warehouse)
  - [Week 4: Analytics engineering](#week-4-analytics-engineering)
  - [Week 5: Batch processing](#week-5-batch-processing)
  - [Week 6: Streaming](#week-6-streaming)
  - [Week 7, 8 & 9: Project](#week-7-8--9-project)
  - [Workshop: Maximizing Confidence in Your Data Model Changes with dbt and PipeRider](#workshop-maximizing-confidence-in-your-data-model-changes-with-dbt-and-piperider)
- [Overview](#overview)
  - [Architecture diagram](#architecture-diagram)
  - [Technologies](#technologies)
  - [Tools](#tools)

## Syllabus

### [Week 1: Introduction & Prerequisites](week_1_basics_n_setup/README.md)
[Original](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/week_1_basics_n_setup)

* Course overview
* Introduction to GCP
* Docker and docker-compose
* Running Postgres locally with Docker
* Setting up infrastructure on GCP with Terraform
* Preparing the environment for the course
* Homework

_[Back to the top](#table-of-contents)_

### [Week 2: Workflow Orchestration](week_2_workflow_orchestration/README.md)
[Original](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/week_2_workflow_orchestration)

* Data Lake
* Workflow orchestration
* Introduction to Prefect
* ETL with GCP & Prefect
* Parametrizing workflows
* Prefect Cloud and additional resources
* Homework

_[Back to the top](#table-of-contents)_

### [Week 3: Data Warehouse](week_3_data_warehouse/README.md)
[Original](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/week_3_data_warehouse)

* Data Warehouse
* BigQuery
* Partitioning and clustering
* BigQuery best practices
* Internals of BigQuery
* Integrating BigQuery with Airflow
* BigQuery Machine Learning

_[Back to the top](#table-of-contents)_

### [Week 4: Analytics engineering](week_4_analytics_engineering/README.md)
[Original](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/week_4_analytics_engineering)

* Basics of analytics engineering
* dbt (data build tool)
* BigQuery and dbt
* Postgres and dbt
* dbt models
* Testing and documenting
* Deployment to the cloud and locally
* Visualizing the data with google data studio and metabase

_[Back to the top](#table-of-contents)_

### [Week 5: Batch processing](week_5_batch_processing/README.md)
[Original](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/week_5_batch_processing)

* Batch processing
* What is Spark
* Spark Dataframes
* Spark SQL
* Internals: GroupBy and joins

_[Back to the top](#table-of-contents)_

### [Week 6: Streaming](week_6_stream_processing/README.md)
[Original](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/week_6_stream_processing)

* Introduction to Kafka
* Schemas (avro)
* Kafka Streams
* Kafka Connect and KSQL

_[Back to the top](#table-of-contents)_

### [Week 7, 8 & 9: Project](week_7_project)

Putting everything we learned to practice

* Week 7 and 8: working on your project
* Week 9: reviewing your peers

_[Back to the top](#table-of-contents)_

### Workshop: Maximizing Confidence in Your Data Model Changes with dbt and PipeRider

[More details](cohorts/2023/workshops/piperider.md)


## Overview

### Architecture diagram

![Architecture diagram](images/arch.png)

### Technologies

* Google Cloud Platform (GCP): Cloud-based auto-scaling platform by Google
  * Google Cloud Storage (GCS): Data Lake
  * BigQuery: Data Warehouse
* Terraform: Infrastructure-as-Code (IaC)
* Docker: Containerization
* SQL: Data Analysis & Exploration
* Prefect: Workflow Orchestration
* dbt: Data Transformation
* Spark: Distributed Processing
* Kafka: Streaming

### Tools

* Docker and Docker-Compose
* Python 3 (e.g. via Anaconda)
* Google Cloud SDK
* Terraform

_[Back to the top](#table-of-contents)_
