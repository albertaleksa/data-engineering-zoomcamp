>[Back to Main course page](../README.md)
>
>Previous Week: [5: Batch processing](../week_5_batch_processing/README.md)
>
>Next Week: 


## Week 6: Streaming 

### Table of contents
- [Code structure](#code-structure)
- [Confluent cloud setup](#confluent-cloud-setup)
- [Introduction to Stream Processing](#introduction-to-stream-processing)
- [Introduction to Kafka](#introduction-to-kafka)
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

- #### Kafka stream testing

  :movie_camera: [Video](https://www.youtube.com/watch?v=TNx5rmLY8Pk)

- #### Kafka stream windowing

  :movie_camera: [Video](https://www.youtube.com/watch?v=r1OuLdwxbRc)

- #### Kafka ksqldb & Connect

  :movie_camera: [Video](https://www.youtube.com/watch?v=DziQ4a4tn9Y)

- #### Kafka Schema registry

  :movie_camera: [Video](https://www.youtube.com/watch?v=tBY_hBuyzwI)

_[Back to the top](#table-of-contents)_

### Faust - Python Stream Processing

- [Faust Documentation](https://faust.readthedocs.io/en/latest/index.html)
- [Faust vs Kafka Streams](https://faust.readthedocs.io/en/latest/playbooks/vskafka.html)

_[Back to the top](#table-of-contents)_

### Pyspark - Structured Streaming
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

---




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