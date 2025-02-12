# gcloud-dataproc

## Set up the environment
Use the Google Cloud Editor and terminal.

You can checkout this project by issuing the below command

`gh repo clone nkiss/gcloud-dataproc`


In order to create a Dataproc cluster for playing with pyspark
1. Change directory to `gcloud-dataproc`
2. Modify the project name to your project name in the `constants.sh`
3. Start to create the necessary elements for the dataproc cluster by issuing the command: `./dataproc-cluster-ctrl --up`

Login with ssh to the Virtual machine and type pyspark.

## Clean up
PHS cluster is deleted after 2 hours inactivity.
To remove the bucket and the dataset run:
`./dataproc-cluster-ctrl --down`
