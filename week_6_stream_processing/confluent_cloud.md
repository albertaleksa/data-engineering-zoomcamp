>[Back to Week Menu](README.md)
>
>Previous Theme:  [What is kafka?](kafka.md)
>
>Next Theme: [Kafka producer consumer](kafka_producer_consumer.md)

# Introduction to Kafka

## Confluent cloud

_[Video source](https://www.youtube.com/watch?v=ZnEZFEYKppw)_

1. Register on Confluent Cloud for free 30 days trial (https://www.confluent.io/confluent-cloud/tryfree/).
2. Create Cluster.
   > Create Cluster (Basic) -> Google Cloud (us-east1; Single zone) -> Skip payment
   > 
   > Cluster name: kafka_tutorial_cluster ->
   > 
   > Launch Cluster
3. Create API key

    An API key consists of a key and a secret. Kafka API keys are required to interact with Kafka clusters in Confluent Cloud. Each Kafka API key is valid for a specific Kafka cluster.
   > API Keys -> Create key -> Global access -> Next
   > 
   > Description: kafka_cluster_tutorial_api_key -> Download and continue
4. Create a topic

    A Topic is a category/feed name to which records are stored and published. All Kafka records are organized into topics. Producer applications write data to topics and consumer applications read from topics. Records published to the cluster stay in the cluster until a configurable retention period has passed by.
   > Topics -> Create topic
   > 
   > Topic name: tutorial_topic
   > 
   > Partitions: 2
   > 
   > Show advanced settings:
   > 
   > Delete Retention time: '1 day' ->
   > 
   > Save and create
5. Produce a new message
   > Messages -> Produce a new message to this topic
   > 
   > Left by default -> Produce
   > 
   A new message is appeared in our Kafka topic
6. Create a connector

    Confluent Cloud offers pre-built, fully managed Kafka connectors that make it easy to instantly connect your clusters to popular data sources and sinks. Connect to external data systems effortlessly with simple configuration and no ongoing operational burden.
   > Connectors -> Datagen Source
   > 
   > Choose tutorial_topic -> Continue ->
   > 
   > Global access -> Continue ->
   > 
   > > Select output record value format: JSON
   > >
   > > Select a template: Orders
   > 
   > Continue -> Continue ->
   > 
   > Connector name: OrdersConnector_tutorial
   > 
   > Continue ->
7. Now messages create and put in our Topic
8. Shutdown connector
   > Connector -> Choose connector -> Pause

    We always have to stop processes at the end of a work session so we don’t burn our $400 free credit dollars.

_[Back to the top](#confluent-cloud)_