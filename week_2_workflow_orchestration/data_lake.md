## Data Lake

- Ingest data as quick as possible
- Make it available to anyone who wants data
- Associate metadata for faster access
- secure, scalable, fast and cheap

![Data Lake Features](https://github.com/DreadYo/data-engineering-zoomcamp/blob/master/images/data_lake_features.png)

### Data Lake vs Data Warehouse

- Data Lake facilitate fast storing and fast access
- Storing the data fast is the priority of Data Lake; We may not need data now, but we might later.

![Data Lake vs Data Warehouse](https://github.com/DreadYo/data-engineering-zoomcamp/blob/master/images/data_lake_vs_dw.png)


### How did it start?

- Companies realized the value of data
- Store and access data quickly
- Cannot always define structure of data
- Usefulness of data being realized later in the project lifecycle
- Increase in data scientists
- R&D on data products
- Need for Cheap storage of Big data


### ETL vs ELT

- Extract Transform Load **vs** Extract Load Transform
- Data Warehouse **vs** Data Lake
- Schema on Write **vs** Schema on Read


### Gotcha of Data Lake

- Converting into Data Swamp
- No versioning
- Incompatible schemas for same data without versioning
- No metadata associated
- Joins not possible

### Cloud provider for data lake

- Google Cloud Platform > Cloud Storage
- Amazon Web Services > Amazon S3
- Microsoft Azure > Azure BLOB Storage
