package org.example;

import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.common.serialization.Deserializer;
import org.apache.kafka.common.serialization.Serde;
import org.apache.kafka.common.serialization.Serializer;

// import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.common.serialization.Serdes;
import org.apache.kafka.streams.KafkaStreams;
import org.apache.kafka.streams.StreamsBuilder;
import org.apache.kafka.streams.StreamsConfig;
import org.apache.kafka.streams.kstream.Consumed;
import org.apache.kafka.streams.kstream.Produced;
// import org.apache.kafka.streams.Topology;
// import org.apache.kafka.streams.kstream.Consumed;
// import org.apache.kafka.streams.kstream.Produced;
// import org.example.customserdes.CustomSerdes;
import org.example.data.Ride;

import java.util.Properties;

import java.util.Map;
import java.util.HashMap;
import java.util.List;
import io.confluent.kafka.serializers.KafkaJsonDeserializer;
import io.confluent.kafka.serializers.KafkaJsonSerializer;


public class JsonKStream {
    private Properties props = new Properties();

    public JsonKStream() {
        props.put(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG, "pkc-619z3.us-east1.gcp.confluent.cloud:9092");
        props.put("security.protocol", "SASL_SSL");
        props.put("sasl.jaas.config", "org.apache.kafka.common.security.plain.PlainLoginModule required username='"+Secrets.KAFKA_CLUSTER_KEY+"' password='"+Secrets.KAFKA_CLUSTER_SECRET+"';");
        props.put("sasl.mechanism", "PLAIN");
        props.put("client.dns.lookup", "use_all_dns_ips");
        props.put("session.timeout.ms", "45000");
        props.put(StreamsConfig.APPLICATION_ID_CONFIG, "kafka_tutorial.kstream.count.plocation.v1");
        props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "latest");
        props.put(StreamsConfig.CACHE_MAX_BYTES_BUFFERING_CONFIG, 0);

    }

    // public Topology createTopology() {
    //     StreamsBuilder streamsBuilder = new StreamsBuilder();
    //     var ridesStream = streamsBuilder.stream("rides", Consumed.with(Serdes.String(), CustomSerdes.getSerde(Ride.class)));
    //     var puLocationCount = ridesStream.groupByKey().count().toStream();
    //     puLocationCount.to("rides-pulocation-count", Produced.with(Serdes.String(), Serdes.Long()));
    //     return streamsBuilder.build();
    // }

    public void countPLocation() throws InterruptedException {
        StreamsBuilder streamsBuilder = new StreamsBuilder();
        var ridesStream = streamsBuilder.stream("rides", Consumed.with(Serdes.String(), getJsonSerde()));
        var puLocationCount = ridesStream.groupByKey().count().toStream();
        puLocationCount.to("rides-pulocation-count", Produced.with(Serdes.String(), Serdes.Long()));

        var kStreams = new KafkaStreams(streamsBuilder.build(), props);
        kStreams.start();

        Runtime.getRuntime().addShutdownHook(new Thread(kStreams::close));

        // var topology = createTopology();
        // var kStreams = new KafkaStreams(topology, props);
        // kStreams.start();
        // while (kStreams.state() != KafkaStreams.State.RUNNING) {
        //     System.out.println(kStreams.state());
        //     Thread.sleep(1000);
        // }
        // System.out.println(kStreams.state());
        // Runtime.getRuntime().addShutdownHook(new Thread(kStreams::close));
    }

    private Serde<Ride> getJsonSerde() {
        Map<String, Object> serdeProps = new HashMap<>();
        serdeProps.put("json.value.type", Ride.class);
        final Serializer<Ride> mySerializer = new KafkaJsonSerializer<>();
        mySerializer.configure(serdeProps, false);
    
        final Deserializer<Ride> myDeserializer = new KafkaJsonDeserializer<>();
        myDeserializer.configure(serdeProps, false);
        return Serdes.serdeFrom(mySerializer, myDeserializer);
    }

    public static void main(String[] args) throws InterruptedException {
        var object = new JsonKStream();
        object.countPLocation();
    }
}
