>[Back to Week Menu](README.md)
>
>Previous Theme:   [Kafka ksqldb & Connect](kafka_ksqldb_connect.md)
>
>Next Theme: [Pyspark - Structured Streaming](#kafka_python.md)

# Pyspark - Structured Streaming

Please follow the steps described under [pyspark-streaming](python/streams-example/pyspark/README.md)

## Kafka Streaming with Python

_[Video source](https://www.youtube.com/watch?v=Y76Ez_fIvtk)_

I will use VM in GCP that was created in week_1.

### Run Kafka in Docker

1. Copy folder `week_6_stream_processing` to remote VM:
    > scp -r week_6_stream_processing albert_tests@de-zoomcamp:data-engineering-zoomcamp/

    Delete folder `java` because I don't need it in VM.
2. Using [Readme from docker folder](python/docker/README.md) **Create Docker Network & Volume**:
   ```bash
   # Create Network
   docker network  create kafka-spark-network
   
   # Create Volume
   docker volume create --name=hadoop-distributed-file-system
   ```
3. Go to kafka folder and **Run Services on Docker**:
   ```bash
   # Start Docker-Compose (within for kafka and spark folders)
   docker-compose up -d
   
   # check services
   docker ps 
   ```
   From `docker-compose.yml` file from `broker` settings:
   ```
   KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT
   KAFKA_LISTENERS: PLAINTEXT://broker:29092,PLAINTEXT_HOST://broker:9092
   KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://broker:29092,PLAINTEXT_HOST://localhost:9092
   KAFKA_INTER_BROKER_LISTENER_NAME: PLAINTEXT
   ```

### JSON Example (using kafka library)
1. Go to `/python/json_example/` folder and **Run producer**:
   ```bash
   # Install kafka library for python
   pip install kafka-python
   # Run producer
   python3 producer.py
   ```
2. **Run consumer**:
   ```bash
   # Run consumer with default settings
   python3 consumer.py
   # Run consumer for specific topic
   python3 consumer.py --topic <topic-name>
   ```

### AVRO Example (using confluent_kafka library)
1. Go to `avro_example` folder
2. Install confluent-kafka:
   ```bash
   # Install confluent_kafka library for python
   pip install confluent-kafka
   # also needed
   pip install fastavro
      ```
3. **Run producer**:
   ```bash
   python3 producer.py
   ```
4. **Run consumer**:
   ```bash
   # Run consumer with default settings
   python3 consumer.py
   # Run consumer for specific topic
   python3 consumer.py --topic <topic-name>
   ```

### Difference between JSON and AVRO Examples
How we define Serialization/Deserialization and which level of Serialization/Deserialization we needed to own in our codebase. Our Serialization ensures Contract between services.

_[Back to the top](#pyspark---structured-streaming)_


## Pyspark Structured Streaming

_[Video source](https://www.youtube.com/watch?v=5hRJ8-6Fpyk)_

1. Go to `~/data-engineering-zoomcamp/week_6_stream_processing/python/docker/kafka` folder and **Run Services on Docker** if it was stopped:
   ```bash
   # Start Docker-Compose (within for kafka folder)
   docker-compose up -d
   ```
2. Be sure that `kafka-spark-network` network exists; it allows to communicate between Kafka and Spark services. And `hadoop-distributed-file-system` volume exists; it will be used as a replication of hdfs to store some logs, messages.
   ```bash
   docker volume ls # should list hadoop-distributed-file-system
   docker network ls # should list kafka-spark-network 
   ```
3. **Build Required Images** for running **Spark**.

   The details of how to spark-images are build in different layers can be created can be read through 
the blog post written by André Perez on [Medium blog -Towards Data Science](https://towardsdatascience.com/apache-spark-cluster-on-docker-ft-a-juyterlab-interface-418383c95445)

   ```bash
   # go to `spark` folder
   cd ~/data-engineering-zoomcamp/week_6_stream_processing/python/docker/spark/
   # Build Spark Images
   chmod +x build.sh
   ./build.sh 
   ```

   Check images:
   ```
   docker image ls
   ```
4. Run images for Spark in docker:
   ```bash
   # Start Docker-Compose (spark folder)
   docker-compose up -d
   ```
5. **Run producer** from `pyspark` folder:
   ```bash
   cd ~/data-engineering-zoomcamp/week_6_stream_processing/python/streams-example/pyspark
   # Run producer
   python3 producer.py
   ```
6. **Run consumer**:
   ```bash
   # Run consumer with default settings
   python3 consumer.py
   # Run consumer for specific topic
   python3 consumer.py --topic <topic-name>
   ```
7. Running Streaming Script

   If run `python3 streaming.py` will be an Error:
   Failed to find data source: kafka. Please deploy the application as per the deployment section of "Structured Streaming + Kafka Integration Guide".
   
   spark-submit script ensures installation of necessary jars before running the streaming.py

   ```bash
   ./spark-submit.sh streaming.py 
   ```

Failed to find data source: kafka. Please deploy the application as per the deployment section of "Structured Streaming + Kafka Integration Guide".

_[Back to the top](#pyspark---structured-streaming)_