>[Back to Week Menu](README.md)
>
>Previous Theme:  [Confluent cloud](confluent_cloud.md)
>
>Next Theme: 

# Introduction to Kafka

## Kafka producer consumer

_[Video source](https://www.youtube.com/watch?v=aegTuyxX7Yg)_

### What we will cover

We will cover :

- Produce some messages programmatically
- Consume some data programmatically

We will use Java for this. If we want to use Python, there’s a Docker image to help us.

### Create a topic with Confluent cloud

- Login to [Confluent Cloud](https://confluent.cloud/).

- From the **Welcome back** page, click on **Environments**, select the **Default cluster**, click on
**kafka_tutorial_cluster** and select **Topics** in the left menu.

- Click on **Add topic** button.
   > **Topic name**: rides
   > 
   > **Partitions**: 2
   > 
   > Click on **Show advanced settings**:
   > 
   > > **Retention time**: 1 day
   > 
   > Save and create
- Click on **Save & create** button.

This topic has no messages, schema or configuration.

### Create a client
- Select **Clients** on the left menu, click on **New client** button, and choose **Java** as language. This provides
snippet code to configure our client.

Here the snippet code created.

**Snippet**

``` yaml
# Required connection configs for Kafka producer, consumer, and admin
bootstrap.servers=pkc-41voz.northamerica-northeast1.gcp.confluent.cloud:9092
security.protocol=SASL_SSL
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username='{{ CLUSTER_API_KEY }}' password='{{ CLUSTER_API_SECRET }}';
sasl.mechanism=PLAIN
# Required for correctness in Apache Kafka clients prior to 2.6
client.dns.lookup=use_all_dns_ips

# Best practice for higher availability in Apache Kafka clients prior to 3.0
session.timeout.ms=45000

# Best practice for Kafka producer to prevent data loss
acks=all

# Required connection configs for Confluent Cloud Schema Registry
schema.registry.url=https://{{ SR_ENDPOINT }}
basic.auth.credentials.source=USER_INFO
basic.auth.user.info={{ SR_API_KEY }}:{{ SR_API_SECRET }}
```

### Java class

Start your Java IDE (I use Visual Studio Code) to open `week_6_stream_processing/java/kafka_examples` directory from a cloned
repo on your disk of [data-engineering-zoomcamp](https://github.com/DataTalksClub/data-engineering-zoomcamp).

A Java class `Ride` has been created with the same structure as the taxi trip files in New York City.

The `JsonProducer` class contains the `getRides()` method that reads a CSV file and return a list of `Ride`.

**File `JsonProducer.java`**

``` java
public List<Ride> getRides() throws IOException, CsvException {
    var ridesStream = this.getClass().getResource("/rides.csv");
    var reader = new CSVReader(new FileReader(ridesStream.getFile()));
    reader.skip(1);
    return reader.readAll().stream().map(arr -> new Ride(arr))
            .collect(Collectors.toList());
}
```

Remember that Java streams enable functional-style operations on streams of elements. A stream is an abstraction of a
non-mutable collection of functions applied in some order to the data. A stream is not a collection where you can store
elements. See [Using Java Streams in Java 8 and Beyond](https://www.jrebel.com/blog/java-streams-in-java-8) for more
information about Java streams.

The `main()` method creates a new producer, get a list of `Ride`, and publish these rides.

**File `JsonProducer.java`**

``` java
public static void main(String[] args) throws IOException, CsvException,
    ExecutionException, InterruptedException {

    var producer = new JsonProducer();
    var rides = producer.getRides();
    producer.publishRides(rides);
}
```

### Create Properties

We have to create properties using the snippet code obtained previously.

**File `JsonProducer.java`**

``` java
private Properties props = new Properties();

public JsonProducer() {
    String BOOTSTRAP_SERVER = "pkc-41voz.northamerica-northeast1.gcp.confluent.cloud:9092";

    props.put(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG, BOOTSTRAP_SERVER);
    props.put("security.protocol", "SASL_SSL");
    props.put("sasl.jaas.config",
        "org.apache.kafka.common.security.plain.PlainLoginModule required username='"
        + kafkaClusterKey + "' password='" + kafkaClusterSecret + "';");
    props.put("sasl.mechanism", "PLAIN");
    props.put("client.dns.lookup", "use_all_dns_ips");
    props.put("session.timeout.ms", "45000");
    props.put(ProducerConfig.ACKS_CONFIG, "all");
    props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringSerializer");
    props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, "io.confluent.kafka.serializers.KafkaJsonSerializer");
}
```

### :fire: Handling Credentials

It's best to put credentials (passwords, private keys, etc.), any sensitive information you don't want publicly disclosed, 
as environment variables and use [System.getenv()](https://docs.oracle.com/en/java/javase/19/docs/api/java.base/java/lang/System.html#getenv()).

In your IDE, place these confidential variables in environment variables field.

![w6s21](../images/w6s21.png)

Then you can import these variables into your code at runtime like this:

``` java
public class App {
    public static void main(String[] args) throws InterruptedException {
        var kafkaClusterKey = System.getenv("KAFKA_CLUSTER_KEY");
        var kafkaClusterSecret = System.getenv("KAFKA_CLUSTER_SECRET");
        System.out.println("kafkaClusterKey=" + kafkaClusterKey);
        System.out.println("kafkaClusterSecret=" + kafkaClusterSecret);
    }
}
```

### Serialization

We need two types of serializer: **StringSerializer** and **JsonSerializer**. Remember that serialization is the process
of converting objects into bytes. Apache Kafka provides a pre-built serializer and deserializer for several basic types
:

- [StringSerializer](https://kafka.apache.org/34/javadoc/org/apache/kafka/common/serialization/StringSerializer.html)
- ShortSerializer
- IntegerSerializer
- LongSerializer
- DoubleSerializer
- BytesSerializer

See [StringSerializer](https://kafka.apache.org/34/javadoc/org/apache/kafka/common/serialization/StringSerializer.html)
and [JSON Schema
Serializer](https://docs.confluent.io/platform/current/schema-registry/serdes-develop/serdes-json.html#json-schema-serializer).

### Create `publishRides()` method

Now create the `publishRides()` method.

**File `JsonProducer.java`**

``` java
 public void publishRides(List<Ride> rides) throws ExecutionException, InterruptedException {
    KafkaProducer<String, Ride> kafkaProducer = new KafkaProducer<String, Ride>(props);
    for(Ride ride: rides) {
        ride.tpep_pickup_datetime = LocalDateTime.now().minusMinutes(20);
        ride.tpep_dropoff_datetime = LocalDateTime.now();
        var record = kafkaProducer.send(new ProducerRecord<>("rides",
            String.valueOf(ride.DOLocationID), ride), (metadata, exception) -> {

            if(exception != null) {
                System.out.println(exception.getMessage());
            }
        });
        System.out.println(record.get().offset());
        System.out.println(ride.DOLocationID);
        Thread.sleep(500);
    }
}
```

[KafkaProducer](https://javadoc.io/static/org.apache.kafka/kafka-clients/3.4.0/org/apache/kafka/clients/producer/KafkaProducer.html)
is a Kafka client that publishes records to the Kafka cluster.

### `build.gradle` file

We need to add implementations in the dependencies of `build.gradle` file.

**File `build.gradle`**

``` txt
plugins {
    id 'java'
    id "com.github.davidmc24.gradle.plugin.avro" version "1.5.0"
}


group 'org.example'
version '1.0-SNAPSHOT'

repositories {
    mavenCentral()
    maven {
        url "https://packages.confluent.io/maven"
    }
}

dependencies {
    implementation 'org.apache.kafka:kafka-clients:3.3.1'
    implementation 'com.opencsv:opencsv:5.7.1'
    implementation 'io.confluent:kafka-json-serializer:7.3.1'
    implementation 'org.apache.kafka:kafka-streams:3.3.1'
    implementation 'io.confluent:kafka-avro-serializer:7.3.1'
    implementation 'io.confluent:kafka-schema-registry-client:7.3.1'
    implementation 'io.confluent:kafka-streams-avro-serde:7.3.1'
    implementation "org.apache.avro:avro:1.11.0"
    testImplementation 'org.junit.jupiter:junit-jupiter-api:5.8.1'
    testRuntimeOnly 'org.junit.jupiter:junit-jupiter-engine:5.8.1'
    testImplementation 'org.apache.kafka:kafka-streams-test-utils:3.3.1'
}

sourceSets.main.java.srcDirs = ['build/generated-main-avro-java','src/main/java']

test {
    useJUnitPlatform()
}
```

### Run `JsonProducer`

Now, let’s run `JsonProducer`.

If all goes well, you should see messages appear in the log of the Java IDE and also under **Messages** tab of the topic
**rides** in Confluent cloud.

<table>
<tr><td>
<img src="../images/w6s17.png">
</td><td>
<img src="../images/w6s18.png">
</td></tr>
</table>

### Create `JsonConsumer` class

Now, for the consumer, we’re going to do basically the same thing as before with the producer.

### Create `Properties` for Consumer

We have to create properties using the snippet code obtained previously.

**File `JsonConsumer.java`**

``` java
private Properties props = new Properties();

private KafkaConsumer<String, Ride> consumer;

public JsonConsumer() {
    String BOOTSTRAP_SERVER = "pkc-41voz.northamerica-northeast1.gcp.confluent.cloud:9092";

    props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, BOOTSTRAP_SERVER);
    props.put("security.protocol", "SASL_SSL");
    props.put("sasl.jaas.config", "org.apache.kafka.common.security.plain.PlainLoginModule required username='"
        + kafkaClusterKey + "' password='" + kafkaClusterSecret + "';");
    props.put("sasl.mechanism", "PLAIN");
    props.put("client.dns.lookup", "use_all_dns_ips");
    props.put("session.timeout.ms", "45000");

    props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringDeserializer");
    props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, "io.confluent.kafka.serializers.KafkaJsonDeserializer");
    props.put(ConsumerConfig.GROUP_ID_CONFIG, "kafka_tutorial_example.jsonconsumer.v1");
    props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");
    props.put(KafkaJsonDeserializerConfig.JSON_VALUE_TYPE, Ride.class);

    consumer = new KafkaConsumer<String, Ride>(props);
    consumer.subscribe(List.of("rides"));
}
```

Remember that deserialization is the inverse process of the serialization — converting a stream of bytes into an object.

[KafkaConsumer](https://javadoc.io/static/org.apache.kafka/kafka-clients/3.4.0/org/apache/kafka/clients/consumer/KafkaConsumer.html)
is a client that consumes records from a Kafka cluster.

### Create `consumeFromKafka()` method

Let’s create the `consumeFromKafka()` method.

**File `JsonConsumer.java`**

``` java
public void consumeFromKafka() {
    System.out.println("Consuming form kafka started");
    var results = consumer.poll(Duration.of(1, ChronoUnit.SECONDS));
    var i = 0;
    do {
        for(ConsumerRecord<String, Ride> result: results) {
            System.out.println(result.value().DOLocationID);
        }
        results =  consumer.poll(Duration.of(1, ChronoUnit.SECONDS));
        System.out.println("RESULTS:::" + results.count());
        i++;
    }
    while(!results.isEmpty() || i < 10);
}
```

Finally, we create the `main()` method

**File `JsonConsumer.java`**

``` java
public static void main(String[] args) {
    JsonConsumer jsonConsumer = new JsonConsumer();
    jsonConsumer.consumeFromKafka();
}
```

### Default constructor for `Ride` class

After encountering several exceptions (from 14:00 to 20:00), the instructor adds a default constructor to the `Ride` class.

**File `Ride.java`**

``` java
public Ride() {}
```

### Run `JsonConsumer`

Now, let’s run `JsonConsumer`.

If all goes well, you should see messages appear in the log of the Java IDE like this.

![w6s19](../images/w6s19.png)

_[Back to the top](#kafka-producer-consumer)_