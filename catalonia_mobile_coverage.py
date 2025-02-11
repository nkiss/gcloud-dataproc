import sys

from pyspark.sql import SparkSession
from pyspark.sql.functions import col
from pyspark.sql.types import BooleanType

if len(sys.argv) == 1:
    print("Please provide a GCS bucket name.")

bucket = sys.argv[1]
# check if public data is still availbale if there is an error
table = "bigquery-public-data.catalonian_mobile_coverage_eu.mobile_data_2015_2017"

spark = SparkSession.builder \
          .appName("pyspark-example") \
          .getOrCreate()

df = spark.read.format("bigquery").option("table", table).load()

#preview data, show 10 lines
limitied = df.limit(10)
limited.show()

# count the signal "low signal" 
#low_signal=df.filter("signal<3").count()
#print(f'low signal count: {low_signal}')
