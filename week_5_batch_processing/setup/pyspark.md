>[Back to Week Menu](../README.md)
>
>[Back to Installing Spark](../spark_install.md)
>
>Previous Theme: [Introduction to Spark](../intro_spark.md)

## PySpark

### Exports

This document assumes you already have python.

To run PySpark, we first need to add it to `PYTHONPATH`:

```bash
export PYTHONPATH="${SPARK_HOME}/python/:$PYTHONPATH"
export PYTHONPATH="${SPARK_HOME}/python/lib/py4j-0.10.9.5-src.zip:$PYTHONPATH"
```

Make sure that the version under `${SPARK_HOME}/python/lib/` matches the filename of py4j or you will
encounter `ModuleNotFoundError: No module named 'py4j'` while executing `import pyspark`.

For example, if the file under `${SPARK_HOME}/python/lib/` is `py4j-0.10.9.3-src.zip`, then the
`export PYTHONPATH` statement above should be changed to

```bash
export PYTHONPATH="${SPARK_HOME}/python/lib/py4j-0.10.9.3-src.zip:$PYTHONPATH"
```

### Add to `.bashrc` exports to avoid type it every time after login/logout

Open `.bashrc` in HOME dir:

```bash
nano .bashrc
```

Add to the end:
```
export PYTHONPATH="${SPARK_HOME}/python/:$PYTHONPATH"
export PYTHONPATH="${SPARK_HOME}/python/lib/py4j-0.10.9.5-src.zip:$PYTHONPATH"
```

Re-evaluate `.bashrc`:
```bash
source .bashrc
```

### PySpark in Jupyter Notebook 

Now you can run Jupyter or IPython to test if things work. Go to some other directory, e.g. `~/tmp`.

(Needed to forward port 8888 in PyCharm Pro or Visual Studio Code if jupyter runs in Cloud VM to access to Jupyter Notebook through browser)

Download a CSV file that we'll use for testing:

```bash
wget https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv
```

Now let's run `ipython` (or `jupyter notebook`) and execute:

```python
import pyspark
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .master("local[*]") \
    .appName('test') \
    .getOrCreate()

df = spark.read \
    .option("header", "true") \
    .csv('taxi+_zone_lookup.csv')

df.show()
```

Test that writing works as well:

```python
df.write.parquet('zones')
```

Forward another port `4040` to have access to Interface of Spark Master (http://127.0.0.1:4040/)

_[Back to the top](#pyspark)_