>[Back to Main course page](../README.md)
>
>Previous Week: [5: Batch processing](../week_5_batch_processing/README.md)
>
>Next Week: [Week 7, 8 & 9: Project](../week_7_project/README.md)


## Week 6: Streaming 

### Table of contents
- [Code structure](#code-structure)
- [Confluent cloud setup](#confluent-cloud-setup)
- [Introduction to Stream Processing](#introduction-to-stream-processing)
- [Introduction to Kafka](#introduction-to-kafka)
- [Kafka Configuration](#kafka-configuration)
- [Kafka Streams](#kafka-streams)
- [Faust - Python Stream Processing](#faust---python-stream-processing)
- [Streaming with Python](#streaming-with-python)
- [Kafka Streams with JVM library](#kafka-streams-with-jvm-library)
- [KSQL and ksqlDB](#ksql-and-ksqldb)
- [Kafka Connect](#kafka-connect)
- [Docker](#docker)
- 
- [Homework](#homework)
- [Community notes](#community-notes)

_[Back to the top](#table-of-contents)_

---

# Week 6: Stream Processing

### Code structure
* [Java examples](java)
* [Python examples](python)
* [KSQLD examples](ksqldb)

_[Back to the top](#table-of-contents)_

### Confluent cloud setup
Confluent cloud provides a free 30 days trial for, you can signup [here](https://www.confluent.io/confluent-cloud/tryfree/)

_[Back to the top](#table-of-contents)_

### [Introduction to Stream Processing](intro_stream_processing.md)
- [Slides](https://docs.google.com/presentation/d/1bCtdCba8v1HxJ_uMm9pwjRUC-NAMeB-6nOG2ng3KujA/edit?usp=sharing)

- #### Introduction

  :movie_camera: [Video](https://www.youtube.com/watch?v=hfvju3iOIP0)

- #### What is stream processing

  :movie_camera: [Video](https://www.youtube.com/watch?v=WxTxKGcfA-k)

_[Back to the top](#table-of-contents)_

### Introduction to Kafka
- #### [What is kafka?](kafka.md)

  :movie_camera: [Video](https://www.youtube.com/watch?v=zPLZUDPi4AY)

- #### [Confluent cloud](confluent_cloud.md)

  :movie_camera: [Video](https://www.youtube.com/watch?v=ZnEZFEYKppw)

- #### [Kafka producer consumer](kafka_producer_consumer.md)

  :movie_camera: [Video](https://www.youtube.com/watch?v=aegTuyxX7Yg)

_[Back to the top](#table-of-contents)_

### [Kafka Configuration](kafka_config.md)
- [Kafka Configuration Reference](https://docs.confluent.io/platform/current/installation/configuration/)

 :movie_camera: [Video](https://www.youtube.com/watch?v=SXQtWyRpMKs)

_[Back to the top](#table-of-contents)_

### Kafka Streams

- [Slides](https://docs.google.com/presentation/d/1fVi9sFa7fL2ZW3ynS5MAZm0bRSZ4jO10fymPmrfTUjE/edit?usp=sharing)

- [Streams Concepts](https://docs.confluent.io/platform/current/streams/concepts.html)

- #### [Kafka streams basics](kafka_streams_basics.md)

  :movie_camera: [Video](https://www.youtube.com/watch?v=dUyA_63eRb0)

- #### [Kafka stream join](kafka_stream_join.md)

  :movie_camera: [Video](https://www.youtube.com/watch?v=NcpKlujh34Y)

- #### [Kafka stream testing](kafka_stream_testing.md)

  :movie_camera: [Video](https://www.youtube.com/watch?v=TNx5rmLY8Pk)

- #### [Kafka stream windowing](kafka_stream_windowing.md)

  :movie_camera: [Video](https://www.youtube.com/watch?v=r1OuLdwxbRc)

- #### [Kafka ksqldb & Connect](kafka_ksqldb_connect.md)

  :movie_camera: [Video](https://www.youtube.com/watch?v=DziQ4a4tn9Y)

- #### [Kafka Schema registry](kafka_schema_registry.md)

  :movie_camera: [Video](https://www.youtube.com/watch?v=tBY_hBuyzwI)

_[Back to the top](#table-of-contents)_

### Faust - Python Stream Processing

- [Faust Documentation](https://faust.readthedocs.io/en/latest/index.html)
- [Faust vs Kafka Streams](https://faust.readthedocs.io/en/latest/playbooks/vskafka.html)

_[Back to the top](#table-of-contents)_

### [Streaming with Python](kafka_python.md)
Please follow the steps described under [pyspark-streaming](python/streams-example/pyspark/README.md)

- #### Kafka Streaming with Python

  :movie_camera: [Video](https://www.youtube.com/watch?v=Y76Ez_fIvtk)

- #### Pyspark Structured Streaming

  :movie_camera: [Video](https://www.youtube.com/watch?v=5hRJ8-6Fpyk)

_[Back to the top](#table-of-contents)_

### Kafka Streams with JVM library

- [Confluent Kafka Streams](https://kafka.apache.org/documentation/streams/)
- [Scala Example](https://github.com/AnkushKhanna/kafka-helper/tree/master/src/main/scala/kafka/schematest)

_[Back to the top](#table-of-contents)_

### KSQL and ksqlDB

- [Introducing KSQL: Streaming SQL for Apache Kafka](https://www.confluent.io/blog/ksql-streaming-sql-for-apache-kafka/)
- [ksqlDB](https://ksqldb.io/)

_[Back to the top](#table-of-contents)_

### Kafka Connect

- [Making Sense of Stream Data](https://medium.com/analytics-vidhya/making-sense-of-stream-data-b74c1252a8f5)

_[Back to the top](#table-of-contents)_

### Docker

#### Starting cluster

### Command line for Kafka

#### Create topic

```bash
./bin/kafka-topics.sh --create --topic demo_1 --bootstrap-server localhost:9092 --partitions 2
```

### Homework

Homework can be found [here](../cohorts/2023/week_6_stream_processing/homework.md).

Solution for homework [here](../cohorts/2023/week_6_stream_processing/homework_my_solutions.md).


[Form](https://forms.gle/rK7268U92mHJBpmW7)

The homework is mostly theoretical. In the last question you have to provide working code link, please keep in mind that this
question is not scored.

Deadline: 13 March 2023, 22:00 CET

_[Back to the top](#table-of-contents)_

### Community notes

Did you take notes? You can share them here.

* [Notes by Alvaro Navas](https://github.com/ziritrion/dataeng-zoomcamp/blob/main/notes/6_streaming.md )
* [Marcos Torregrosa's blog (spanish)](https://www.n4gash.com/2023/data-engineering-zoomcamp-semana-6-stream-processing/)
* Add your notes here (above this line)

_[Back to the top](#table-of-contents)_