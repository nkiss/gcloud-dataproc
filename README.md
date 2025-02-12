# gcloud-dataproc

This project helps to learn and practice spark / pyspark. 

## Set up the environment
Use the Google Cloud Editor and terminal.

You can checkout this project by issuing the below command

`gh repo clone nkiss/gcloud-dataproc`


In order to create a Dataproc cluster for playing with pyspark
1. Change directory to `gcloud-dataproc`
2. Modify the project name to your project name in the `constants.sh`
3. Start to create the necessary elements for the dataproc cluster by issuing the command: `./dataproc-cluster-ctrl --up`

## Playing with pyspark
1. Navigate in the Google Cloud to Dataproc / Clusters / your_cluster_name 
2. Find the VM instances tab and next to the VM instance start SSH connection
3. When SSH session is ready start pyspark by issue `pyspark`
4. Load the public big data _Catalonian mobile data coverage_ with the below commands
- `table = "bigquery-public-data.catalonian_mobile_coverage_eu.mobile_data_2015_2017"`
- `df = spark.read.format("bigquery").option("table", table).load()`
5. run a sample query:
- `df.createOrReplaceTempView("tableA")`
- `spark.sql("select count(distinct(town_name)) from tableA where net='4G' and speed<'2.0' and town_name!='NULL'").show()`

## Clean up
PHS cluster is deleted after 2 hours inactivity.
To remove the bucket and the dataset run:
`./dataproc-cluster-ctrl --down`
