>[Back to Week Menu](README.md)
>
>Previous Theme: [Resilient Distributed Datasets](rdd.md)
>
>Next Theme: 

# Running Spark in the Cloud
_Video sources: [1](https://youtu.be/Yyz293hBVcQ&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb), [2](https://youtu.be/HXBwSlXo5IA&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQ), [3](https://youtu.be/osAiAYahvh8&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb), [4](https://youtu.be/HIm2BOj8C0Q&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)_

So far we've seen how to run Spark locally and how to work with local data. In this section we will cover how to use Spark with remote data and run Spark in the cloud as well.

## Connecting to Google Cloud Storage

_[Video source](https://youtu.be/Yyz293hBVcQ&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)_

Google Cloud Storage is an _object store_, which means that it doesn't offer a fully featured file system. Spark can connect to remote object stores by using ***connectors***; each object store has its own connector, so we will need to use [Google's Cloud Storage Connector](https://cloud.google.com/dataproc/docs/concepts/connectors/cloud-storage) if we want our local Spark instance to connect to our Data Lake.

Before we do that, we will use `gsutil` to upload our local files to our Data Lake. `gsutil` is included with the GCP SDK, so you should already have it if you've followed the previous chapters.

### Uploading files to Cloud Storage with `gsutil`

Assuming you've got a bunch of parquet files you'd like to upload to Cloud Storage, run the following command to upload them:

```bash
gsutil -m cp -r <local_folder> gs://<bucket_name/destination_folder>
```
* The `-m` option is for enabling multithreaded upload in order to speed it up.
* `cp` is for copying files.
* `-r` stands for _recursive_; it's used to state that the contents of the local folder are to be uploaded. For single files this option isn't needed.

### Configuring Spark with the GCS connector

Go to the [Google's Cloud Storage Connector page](https://cloud.google.com/dataproc/docs/concepts/connectors/cloud-storage) and download the corresponding version of the connector. The version tested for this lesson is version 2.5.5 for Hadoop 3; create a `lib` folder in your work directory and run the following command from it:

```bash
gsutil cp gs://hadoop-lib/gcs/gcs-connector-hadoop3-2.2.5.jar gcs-connector-hadoop3-2.2.5.jar
```

This will download the connector to the local folder.

We now need to follow a few extra steps before creating the Spark session in our notebook. Import the following libraries:

```python
import pyspark
from pyspark.sql import SparkSession
from pyspark.conf import SparkConf
from pyspark.context import SparkContext
```

Now we need to configure Spark by creating a configuration object. Run the following code to create it:

```python
credentials_location = '~/.google/credentials/google_credentials.json'

conf = SparkConf() \
    .setMaster('local[*]') \
    .setAppName('test') \
    .set("spark.jars", "./lib/gcs-connector-hadoop3-2.2.5.jar") \
    .set("spark.hadoop.google.cloud.auth.service.account.enable", "true") \
    .set("spark.hadoop.google.cloud.auth.service.account.json.keyfile", credentials_location)
```

You may have noticed that we're including a couple of options that we previously used when creating a Spark Session with its builder. That's because we implicitly created a ***context***, which represents a connection to a spark cluster. This time we need to explicitly create and configure the context like so:

```python
sc = SparkContext(conf=conf)

hadoop_conf = sc._jsc.hadoopConfiguration()

hadoop_conf.set("fs.AbstractFileSystem.gs.impl",  "com.google.cloud.hadoop.fs.gcs.GoogleHadoopFS")
hadoop_conf.set("fs.gs.impl", "com.google.cloud.hadoop.fs.gcs.GoogleHadoopFileSystem")
hadoop_conf.set("fs.gs.auth.service.account.json.keyfile", credentials_location)
hadoop_conf.set("fs.gs.auth.service.account.enable", "true")
```

This will likely output a warning when running the code. You may ignore it.

We can now finally instantiate a Spark session:

```python
spark = SparkSession.builder \
    .config(conf=sc.getConf()) \
    .getOrCreate()
```

### Reading the remote data

In order to read the parquet files stored in the Data Lake, you simply use the bucket URI as a parameter, like so:

```python
df_green = spark.read.parquet('gs://dtc_data_lake_de-zoomcamp-nytaxi/pq/green/*/*')
```

You should obviously change the URI in this example for yours.

You may now work with the `df_green` dataframe normally.
 
_[Back to the top](#)_

## Creating a Local Spark Cluster

_[Video source](https://www.youtube.com/watch?v=HXBwSlXo5IA&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=62)_

### Spark standalone master and workers

[At the beginning of this lesson](#creating-a-spark-session) we saw how to create a Spark session from a notebook, like so:

```python
spark = SparkSession.builder \
    .master("local[*]") \
    .appName('test') \
    .getOrCreate()
```

This code will stard a local cluster, but once the notebook kernel is shut down, the cluster will disappear.

We will now see how to crate a Spark cluster in [Standalone Mode](https://spark.apache.org/docs/latest/spark-standalone.html) so that the cluster can remain running even after we stop running our notebooks.

Simply go to your Spark install directory from a terminal and run the following command:

```bash
./sbin/start-master.sh
```

You should now be able to open the main Spark dashboard by browsing to `localhost:8080` (remember to forward the port if you're running it on a virtual machine). At the very top of the dashboard the URL for the dashboard should appear; copy it and use it in your session code like so:

```python
spark = SparkSession.builder \
    .master("spark://<URL>:7077") \
    .appName('test') \
    .getOrCreate()
```
* Note that we used the HTTP port 8080 for browsing to the dashboard but we use the Spark port 7077 for connecting our code to the cluster.
* Using `localhost` as a stand-in for the URL may not work.

You may note that in the Spark dashboard there aren't any _workers_ listed. The actual Spark jobs are run from within ***workers*** (or _slaves_ in older Spark versions), which we need to create and set up.

Similarly to how we created the Spark master, we can run a worker from the command line by running the following command from the Spark install directory:

```bash
./sbin/start-worker.sh <master-spark-URL>
```
* In older Spark versions, the script to run is `start-slave.sh` .

Once you've run the command, you should see a worker in the Spark dashboard.

Note that a worker may not be able to run multiple jobs simultaneously. If you're running separate notebooks and connecting to the same Spark worker, you can check in the Spark dashboard how many Running Applications exist. Since we haven't configured the workers, any jobs will take as many resources as there are available for the job.

### Parametrizing our scripts for Spark

So far we've hard-coded many of the values such as folders and dates in our code, but with a little bit of tweaking we can make our code so that it can receive parameters from Spark and make our code much more reusable and versatile.

We will use the [argparse library](https://docs.python.org/3/library/argparse.html) for parsing parameters. Convert a notebook to a script with `nbconvert`, manually modify it or create it from scratch and add the following:

```python
import argparse

import pyspark
from pyspark.sql import SparkSession
from pyspark.sql import functions as F

parser.add_argument('--input_green', required=True)
parser.add_argument('--input_yellow', required=True)
parser.add_argument('--output', required=True)

input_green = args.input_green
input_yellow = args.input_yellow
output = args.output
```

We can now modify previous lines using the 3 parameters we've created. For example:

```python
df_green = spark.read.parquet(input_green)
```

Once we've finished our script, we simply call it from a terminal line with the parameters we need:

```bash
python my_script.py \
    --input_green=data/pq/green/2020/*/ \
    --input_yellow=data/pq/yellow/2020/*/ \
    --output=data/report-2020
```

### Submitting Spark jobs with Spark submit

However, we still haven't covered any Spark specific parameters; things like the the cluster URL when having multiple available clusters or how many workers to use for the job. Instead of specifying these parameters when setting up the session inside the script, we can use an external script called [Spark submit](https://spark.apache.org/docs/latest/submitting-applications.html).

The basic usage is as follows:

```bash
spark-submit \
    --master="spark://<URL>" \
    my_script.py \
        --input_green=data/pq/green/2020/*/ \
        --input_yellow=data/pq/yellow/2020/*/ \
        --output=data/report-2020
```

And the Spark session code in the script is simplified like so:

```python
spark = SparkSession.builder \
    .appName('test') \
    .getOrCreate()
```

You may find more sophisticated uses of `spark-submit` in the [official documentation](https://spark.apache.org/docs/latest/submitting-applications.html).

> You may download a finished script [from this link](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/week_5_batch_processing/code/06_spark_sql.py)

After you're done running Spark in standalone mode, you will need to manually shut it down. Simply run the `./sbin/stop-worker.sh` (`./sbin/stop-slave.sh` in older Spark versions) and ``./sbin/stop-master.sh` scripts to shut down Spark.

_[Back to the top](#)_

## Setting up a Dataproc Cluster

### Creating the cluster

_[Video source](https://www.youtube.com/watch?v=osAiAYahvh8&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=61)_

[Dataproc](https://cloud.google.com/dataproc) is Google's cloud-managed service for running Spark and other data processing tools such as Flink, Presto, etc.

You may access Dataproc from the GCP dashboard and typing `dataproc` on the search bar. The first time you access it you will have to enable the API.

In the images below you may find some example values for creating a simple cluster. Give it a name of your choosing and choose the same region as your bucket.

![creating a cluster](images/05_01.png)

We would normally choose a `standard` cluster, but you may choose `single node` if you just want to experiment and not run any jobs.

![creating a cluster](images/05_02.png)

Optionally, you may install additional components but we won't be covering them in this lesson.

![creating a cluster](images/05_03.png)

You may leave all other optional settings with their default values. After you click on `Create`, it will take a few seconds to create the cluster. You may notice an extra VM instance under VMs; that's the Spark instance.

### Running a job with the web UI

In a [previous section](#configuring-spark-with-the-gcs-connector) we saw how to connect Spark to our bucket in GCP. However, in Dataproc we don't need to specify this connection because it's already pre-comfigured for us. We will also submit jobs using a menu, following similar principles to what we saw in the previous section.

In Dataproc's _Clusters_ page, choose your cluster and un the _Cluster details_ page, click on `Submit job`. Under _Job type_ choose `PySpark`, then in _Main Python file_ write the path to your script (you may upload the script to your bucket and then copy the URL).

![setting up a job](images/05_04.png)

Make sure that your script does not specify the `master` cluster! Your script should take the connection details from Dataproc; make sure it looks something like this:

```python
spark = SparkSession.builder \
    .appName('test') \
    .getOrCreate()
```

You may use [this script](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/week_5_batch_processing/code/06_spark_sql.py) for testing.

We also need to specify arguments, in a similar fashion to what we saw [in the previous section](#parametrizing-our-scripts-for-spark), but using the URL's for our folders rather than the local paths:

![setting up a job](images/05_05.png)

Now press `Submit`. Sadly there is no easy way to access the Spark dashboard but you can check the status of the job from the `Job details` page.

### Running a job with the gcloud SDK

Besides the web UI, there are additional ways to run a job, listed [in this link](https://cloud.google.com/dataproc/docs/guides/submit-job). We will focus on the gcloud SDK now.

Before you can submit jobs with the SDK, you will need to grant permissions to the Service Account we've been using so far. Go to _IAM & Admin_ and edit your Service Account so that the `Dataproc Administrator` role is added to it.

We can now submit a job from the command line, like this:

```bash
gcloud dataproc jobs submit pyspark \
    --cluster=<your-cluster-name> \
    --region=europe-west6 \
    gs://<url-of-your-script> \
    -- \
        --param1=<your-param-value> \
        --param2=<your-param-value>
```

You may find more details on how to run jobs [in the official docs](https://cloud.google.com/dataproc/docs/guides/submit-job).

_[Back to the top](#)_

_[Back to the top](#)_

>Previous: [Analytics Engineering](4_analytics.md)

>[Back to index](README.md)
>>Extra: [Preparing Data for Spark](extra1_preparing_data.md)

>Next: [Streaming](6_streaming.md)
___

>Under construction

# Spark and Docker

# Running Spark in the Cloud (GCP)

# Connecting Spark to a DWH
## Spark with BigQuery (Athena/presto/hive/etc - similar)
## reading from GCP and saving to BG
------
_[Back to the top](#running-spark-in-the-cloud)_