>[Back to Main course page](../README.md)
>
>Previous Week: [4: Analytics engineering](../week_4_analytics_engineering/README.md)
>
>Next Week: [6: Streaming](week_6_stream_processing)


## Week 5: Batch processing 

### Table of contents
- [Introduction to Batch Processing](#introduction-to-batch-processing)
- [Introduction to Spark](#introduction-to-spark)
- [Installing Spark](#installing-spark)
- [Spark SQL and DataFrames](#spark-sql-and-dataframes)
- [Spark Internals](#spark-internals)
- [Resilient Distributed Datasets](#resilient-distributed-datasets)
- [Running Spark in the Cloud](#running-spark-in-the-cloud)
- [Homework](#homework)
- [Community notes](#community-notes)

_[Back to the top](#table-of-contents)_

---

### [Introduction to Batch Processing](intro_batch_processing.md)
- Batch vs Streaming
- Types of batch jobs
- Orchestrating batch jobs
- Pros and cons of batch jobs

 :movie_camera: [Video](https://youtu.be/dcHe5Fl3MF8?list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

_[Back to the top](#table-of-contents)_

### [Introduction to Spark](intro_spark.md)
- What is Spark?
- Why do we need Spark?

 :movie_camera: [Video](https://youtu.be/FhaqbEOuQ8U?list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

_[Back to the top](#table-of-contents)_

### [Installing Spark](spark_install.md)
Follow [these intructions](setup/) to install Spark:

- [Windows](setup/windows.md)
- [Linux](setup/linux.md)
- [MacOS](setup/macos.md)
- And follow [this](setup/pyspark.md) to run PySpark in Jupyter

 :movie_camera: [Video](https://youtu.be/hqUbB9c8sKg?list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

_[Back to the top](#table-of-contents)_

### Spark SQL and DataFrames
- #### [First Look at Spark/PySpark](spark_first_look.md)

    :movie_camera: [Video](https://www.youtube.com/watch?v=r_Sf6fCB40c&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=50)

- #### [Spark Dataframes](spark_dataframes.md)

    :movie_camera: [Video](https://youtu.be/ti3aC1m3rE8?list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

- #### [(Optional) Preparing Yellow and Green Taxi Data](preparing_data.md)

    Script to prepare the Dataset [download_data.sh](code/download_data.sh)
    
    **Note**: The other way to infer the schema (apart from pandas) for the csv files, is to set the `inferSchema` option to `true` while reading the files in Spark.

    :movie_camera: [Video](https://youtu.be/CI3P4tAtru4?list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

- #### [SQL with Spark](spark_sql.md)

    :movie_camera: [Video](https://www.youtube.com/watch?v=uAlp2VuZZPY&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

_[Back to the top](#table-of-contents)_


### [Spark Internals](spark_internals.md)
- #### Anatomy of a Spark Cluster

    :movie_camera: [Video](https://youtu.be/68CipcZt7ZA&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

- #### GroupBy in Spark

    :movie_camera: [Video](https://youtu.be/9qrDsY_2COo&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

- #### Joins in Spark

    :movie_camera: [Video](https://youtu.be/lu7TrqAWuH4&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

_[Back to the top](#table-of-contents)_

### [Resilient Distributed Datasets](rdd.md)
- #### Operations on Spark RDDs

    :movie_camera: [Video](https://youtu.be/Bdu-xIrF3OM&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

- #### Spark RDD mapPartition

    :movie_camera: [Video](https://youtu.be/k3uB2K99roI&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

_[Back to the top](#table-of-contents)_

### [Running Spark in the Cloud](spark_in_cloud.md)
- #### Connecting to Google Cloud Storage

    :movie_camera: [Video](https://youtu.be/Yyz293hBVcQ&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

- #### Creating a Local Spark Cluster

    :movie_camera: [Video](https://youtu.be/HXBwSlXo5IA&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

- #### Setting up a Dataproc Cluster

    :movie_camera: [Video](https://youtu.be/osAiAYahvh8&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

- #### Connecting Spark to Big Query

    :movie_camera: [Video](https://youtu.be/HIm2BOj8C0Q&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

_[Back to the top](#table-of-contents)_

### Homework 
Homework can be found [here](../cohorts/2023/week_5_batch_processing/homework.md).

Solution for homework [here](../cohorts/2023/week_5_batch_processing/homework_my_solutions.md).

_[Back to the top](#table-of-contents)_

## Community notes

Did you take notes? You can share them here.

* [Notes by Alvaro Navas](https://github.com/ziritrion/dataeng-zoomcamp/blob/main/notes/5_batch_processing.md)
* [Sandy's DE Learning Blog](https://learningdataengineering540969211.wordpress.com/2022/02/24/week-5-de-zoomcamp-5-2-1-installing-spark-on-linux/)
* [Notes by Alain Boisvert](https://github.com/boisalai/de-zoomcamp-2023/blob/main/week5.md)
* [Alternative : Using docker-compose to launch spark by rafik](https://gist.github.com/rafik-rahoui/f98df941c4ccced9c46e9ccbdef63a03) 
* [Marcos Torregrosa's blog (spanish)](https://www.n4gash.com/2023/data-engineering-zoomcamp-semana-5-batch-spark)
* [Notes by Victor Padilha](https://github.com/padilha/de-zoomcamp/tree/master/week5)
* Add your notes here (above this line)

_[Back to the top](#table-of-contents)_