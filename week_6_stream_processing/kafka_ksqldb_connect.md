>[Back to Week Menu](README.md)
>
>Previous Theme:   [Kafka stream windowing](kafka_stream_windowing.md)
>
>Next Theme: 

# Kafka Streams

_[Video source](https://www.youtube.com/watch?v=DziQ4a4tn9Y)_

## Kafka ksqlDB & Connect

[ksqlDB](https://ksqldb.io/) is a tool for specifying stream transformations in SQL such as joins. The output of these
transformations is a new topic.

ksqlDB allows you to query, read, write, and process data in Apache Kafka in real-time and at scale using a lightweight
SQL syntax. ksqlDB does not require proficiency with a programming language such as Java or Scala, and you don’t have to
install a separate processing cluster technology.

ksqlDB is complementary to the Kafka Streams API, and indeed executes queries through Kafka Streams applications.

One of the key benefits of ksqlDB is that it does not require the user to develop any code in Java or Scala. This
enables users to leverage a SQL-like interface alone to construct streaming ETL pipelines, to respond to real-time,
continuous business requests, to spot anomalies, and more. ksqlDB is a great fit when your processing logic can be
naturally expressed through SQL.

For more, see:

- [ksqlDB Overview](https://docs.confluent.io/platform/current/ksqldb/index.html#ksqldb-overview)
- [ksqlDB Introduction](https://developer.confluent.io/learn-kafka/ksqldb/intro/)
- [ksqlDB Documentation](https://docs.ksqldb.io/en/latest/)
- [ksqlDB Reference](https://docs.ksqldb.io/en/latest/developer-guide/ksqldb-reference/)

### ksqlDB in Confluent Cloud

> In UI go to `ksqlDB` and create a new cluster `ksqlDB_cluster_0`. Need to wait.

See [ksqlDB in Confluent Cloud](https://docs.confluent.io/cloud/current/ksqldb/index.html) for more.

Below are examples of ksqlDB queries.

Got to the created `ksqlDB_cluster_0` cluster and type in `Editor` window:

**Create streams**

``` sql
CREATE STREAM ride_streams (
    VendorId varchar,
    trip_distance double,
    payment_type varchar,
    passenger_count double
)  WITH (KAFKA_TOPIC='rides',
        VALUE_FORMAT='JSON');
```

Choose `auto.offset.reset = Earliest` and Run query.
We created stream `ride_streams`.

Then we can choose `Ride_streams` in Flow and see the data we queried.

**Query stream**

``` sql
select * from RIDE_STREAMS
EMIT CHANGES;
```

**Query stream count**

``` sql
SELECT VENDORID, count(*) FROM RIDE_STREAMS
GROUP BY VENDORID
EMIT CHANGES;
```

**Query stream with filters**

``` sql
SELECT payment_type, count(*) FROM RIDE_STREAMS
WHERE payment_type IN ('1', '2')
GROUP BY payment_type
EMIT CHANGES;
```

We can run our Producer and see how count in the result of query is increasing/update.

**Query stream with window functions**

``` sql
CREATE TABLE payment_type_sessions AS
  SELECT payment_type,
         count(*)
  FROM  RIDE_STREAMS
  WINDOW SESSION (60 SECONDS)
  GROUP BY payment_type
  EMIT CHANGES;
```

Table `payment_type_sessions` is created and you can see it in `Tables` menu.

Get data from this table:
```sql
select * from PAYMENT_TYPE_SESSIONS EMIT CHANGES;
```

### ksqlDB Documentation for details

- [ksqlDB Reference](https://docs.ksqldb.io/en/latest/developer-guide/ksqldb-reference/quick-reference/)
- [ksqlDB Java Client](https://docs.ksqldb.io/en/latest/developer-guide/ksqldb-clients/java-client/)

### Connectors

Kafka Connect is the pluggable, declarative data integration framework for Kafka to perform streaming integration
between Kafka and other systems such as databases, cloud services, search indexes, file systems, and key-value stores.

Kafka Connect makes it easy to stream data from numerous sources into Kafka, and stream data out of Kafka to numerous
targets. The diagram you see here shows a small sample of these sources and sinks (targets). There are literally
hundreds of different connectors available for Kafka Connect. Some of the most popular ones include:

- RDBMS (Oracle, SQL Server, Db2, Postgres, MySQL)
- Cloud object stores (Amazon S3, Azure Blob Storage, Google Cloud Storage)
- Message queues (ActiveMQ, IBM MQ, RabbitMQ)
- NoSQL and document stores (Elasticsearch, MongoDB, Cassandra)
- Cloud data warehouses (Snowflake, Google BigQuery, Amazon Redshift)

See [Introduction to Kafka Connect](https://developer.confluent.io/learn-kafka/kafka-connect/intro/), [Kafka Connect
Fundamentals: What is Kafka Connect?](https://www.confluent.io/blog/kafka-connect-tutorial/) and [Self-managed
connectors](https://docs.confluent.io/kafka-connectors/self-managed/kafka_connectors.html) for more.


_[Back to the top](#kafka-ksqldb--connect)_