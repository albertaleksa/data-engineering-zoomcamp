>[Back to Week Menu](README.md)
>
>Next Theme: [What is kafka?](kafka.md)

## Introduction to Stream Processing

_Video sources: [1](https://www.youtube.com/watch?v=hfvju3iOIP0), [2](https://www.youtube.com/watch?v=WxTxKGcfA-k)_

[Slides](https://docs.google.com/presentation/d/1bCtdCba8v1HxJ_uMm9pwjRUC-NAMeB-6nOG2ng3KujA/edit?usp=sharing)

### Introduction

_[Video source](https://www.youtube.com/watch?v=hfvju3iOIP0)_

- What is stream processing?
- What is Kafka
- Stream processing message properties
- Kafka setup and configuration
- Time spanning in stream processing
- Kafka producer and Kafka consumer
- Partitions
- How to work with Kafka streams
- Schema and its role in flow processing
- Kafka Connect
- ksqlDB

_[Back to the top](#introduction-to-stream-processing)_

### What is stream processing

_[Video source](https://www.youtube.com/watch?v=WxTxKGcfA-k)_

**Stream processing** is a data management technique that involves ingesting a continuous data stream to quickly analyze, filter, transform or enhance the data in real time.

**Data exchange** allows data to be shared between different computer programs.

#### Producer and consumers

More generally, a **producer** can create messages that **consumers** can read. The **consumers** may be interested in certain
**topics**. The **producer** indicates the **topic** of his messages. The **consumer** can subscribe to the **topics** of his choice.

#### Data exchange in stream processing

When the producer posts a message on a particular topic, consumers who have subscribed to that topic receive the message
in real time.

Real time does not mean immediately, but rather a few seconds late, or more generally much faster than batch processing.

_[Back to the top](#introduction-to-stream-processing)_