# antares3-sentinel-download

# Downloading Sentinel-2 data

For now, the Sentinel-2 scene download process is not integrated into the MAD-Mex system. The download process is described below using the [sentinelsat](https://github.com/sentinelsat/sentinelsat) and [sentinelhub](https://github.com/sentinel-hub/sentinelhub-py) libraries.

It is assumed that you have such libraries installed in a UNIX environment as well as the [sen2cor](http://step.esa.int/main/third-party-plugins-2/sen2cor/) tool, for more details on the installation and configuration of Sentinelat and Sentinelhub you can review the documentation [here](https://sentinelsat.readthedocs.io/en/stable/) and [here](https://sentinelhub-py.readthedocs.io/en/latest/configure.html) respectively.

The approach we show below is to search the available scenes for a region using the Sentinelsat search engine. Here is an example of use for the region of Oaxaca, Mexico for a specific period of time. The `--footprints` flag means that you do not download the found scenes but write the results to a file called `search_footprints.geojson` (which will be in the path where you executed the cmd).

```bash
sentinelsat -u <user> -p <passwd> -g oaxaca.geojson -s 20180801 -e 20180810 --producttype S2MSI1C -q "orbitdirection=Descending" --url "https://scihub.copernicus.eu/dhus" --footprints --cloud 5 --sentinel 2
```
**Note the `q` flag in command above are extra search keywords for query**

With the following output:

```
Found 6 products
Product 86734389-979e-4655-b081-89c07e8429e0 - Date: 2018-08-09T16:38:29.024Z, Instrument: MSI, Mode: , Satellite: Sentinel-2, Size: 749.11 MB
Product aa8662c7-78d5-49ba-b1a2-7e86f168b844 - Date: 2018-08-09T16:38:29.024Z, Instrument: MSI, Mode: , Satellite: Sentinel-2, Size: 699.30 MB
Product d2f77768-9e19-4e8b-9d15-7998fa83a82c - Date: 2018-08-09T16:38:29.024Z, Instrument: MSI, Mode: , Satellite: Sentinel-2, Size: 402.28 MB
Product aedab398-aaa7-4369-ab82-c21824dcdd3c - Date: 2018-08-07T16:49:01.024Z, Instrument: MSI, Mode: , Satellite: Sentinel-2, Size: 734.11 MB
Product eae1b4f2-1c61-4dc2-a121-4f9e00be5256 - Date: 2018-08-07T16:49:01.024Z, Instrument: MSI, Mode: , Satellite: Sentinel-2, Size: 210.16 MB
Product e06d305a-5355-4a8a-bd68-24fa61cb37f4 - Date: 2018-08-05T17:00:09.024Z, Instrument: MSI, Mode: , Satellite: Sentinel-2, Size: 23.55 MB
---
6 scenes found with a total size of 2.75 GB
```

It is very important to mention that the file of the search region must be a polygon as simple as possible, a very complex polygon with many points can cause an error in the command. For the previous example, [here](https://gist.github.com/robmartz/f488fde09f262d8db5a87e2cd5f538c7) is the `geojson` file for Oaxaca. To create new geojson you can consult the following [link](http://geojson.io/#map=6/23.352/-103.447).


It is possible to configure environment variables for the user and password in sentinelsat and avoid entering them in the command line. Simply write the following lines in the `~/.bashrc` file


```
export DHUS_USER="<user>"
export DHUS_PASSWORD="<password>"
export DHUS_URL="https://scihub.copernicus.eu/dhus"
```
Therefore, an alternative command line would be:

```bash
sentinelsat -g oaxaca.geojson -s 20180801 -e 20180810 --producttype S2MSI1C -q "orbitdirection=Descending" --footprints --cloud 5 --sentinel 2
```

## Using sentinelsat

If you want to download, remove `footprints` flag and add `d` flag which is the one to download all files found and `path` to set the path where the files will be saved (here we delete orbitdirection keyword):

```
sentinelsat -u <user> -p <password> -g oaxaca.geojson --sentinel 2 --url https://scihub.copernicus.eu/dhus --producttype S2MSI1C -s 20180801 -e 20180810 -d --path <directory>
```

## Using jupyter notebook

See: [search_and_download_s2.ipynb](https://github.com/CONABIO/antares3-sentinel-download/blob/master/search_and_download_s2.ipynb)


## Using AWS

The download now is done with Sentinelhub with its download tool from AWS. To do that, we'll use a python script to read the `search_footprints.geojson` file to get the product name. 


```python
import json

with open('search_footprints.geojson') as f:
    data = json.load(f)

for feature in data['features']:
    print (feature['properties']['identifier'])
```


In our case, with the following output:
```
S2B_MSIL1C_20180809T163829_N0206_R126_T15PUT_20180809T221152
S2B_MSIL1C_20180809T163829_N0206_R126_T15PTT_20180809T221152
S2B_MSIL1C_20180809T163829_N0206_R126_T15PVT_20180809T221152
S2A_MSIL1C_20180807T164901_N0206_R026_T14PPC_20180807T203921
S2A_MSIL1C_20180807T164901_N0206_R026_T14QNF_20180807T203921
S2B_MSIL1C_20180805T170009_N0206_R069_T14QPE_20180805T221143
```

In order to process the scenes downloaded with sen2cor, we must download the images in a .SAFE format as shown below:

```bash
sentinelhub.aws --product S2B_MSIL1C_20180805T170009_N0206_R069_T14QPE_20180805T221143 -f ~/s2_downloads
``` 
The `~/s2_downloads` folder must be created previously. 

## Parallel downloading

To speed up the download process, you can use the python script for parallel downloads, simultaneously downloading as many scenes as cores in the CPU. The python script reads the geojson file from the query, then builds the sentinelhub commands and runs them in parallel.

```bash
python parallel_downloads.py
```

## Note


1 .- There is a preconfigured AMI for MAD-Mex called `sentinel2_download_preproc` with all the libraries and configurations   needed to reproduce this example.

2.- If what you want is to process a scene that is already in `S3`, maybe it is more convenient to copy it into the `EC2` instance. Keep in mind that when we download a scene and store it in S3, the empty folders are not copied. Therefore, to run `sen2cor` properly, folders that are lost when copying a scene in `S3` must be generated. This is to generate the folders `HTML`, `AUX_DATA` and `rep_info` inside the folder with `.SAFE` format.



# Running sen2cor

There is an important aspect to keep in mind, the scenes downloaded with Sentinelhub come from the S3 bucket `sentinel-s2-l1c`, therefore the `.SAFE` format is only being emulated by the download tool. Once the download has finished, we can proceed to run `sen2cor` as follows:

```bash
L2A_Process ~/s2_downloads/S2B_MSIL1C_20180805T170009_N0206_R069_T14QPE_20180805T221143.SAFE
```

The above command is possible if the following alias is previously defined in the `~/.bashrc` file:

```bash
alias L2A_Process='/home/<user>/Sen2Cor-02.05.05-Linux64/bin/L2A_Process'
```
The complete path depends on the folder of installation defined for sen2cor.

## sen2cor as docker service

We can run `sen2cor.2.8.0` with dem as a docker service creating an image from [here](https://github.com/CONABIO/sen2cor_docker). The following is an example how to create two services:

```bash
archives=/LUSTRE/MADMEX/tasks/2019_tasks/sen2cor_docker/data_zipped
unzipped_scenes=/LUSTRE/MADMEX/tasks/2019_tasks/sen2cor_docker/data_unzipped
src=/LUSTRE/MADMEX/tasks/2019_tasks/sen2cor_docker/sentinel_processing_version_2.8.0/src/
aux=/LUSTRE/MADMEX/sentinel2_aux_data/data/CCI4SEN2COR/
aux_container=/Sen2Cor-02.08.00-Linux64/lib/python2.7/site-packages/sen2cor/aux_data/
```

```bash
sudo docker service create --name l2a --detach=false --restart-condition=on-failure --env USERID=1000 \
--env SEN2COR_HOME=/sen2cor --env SEN2COR_BIN=/sen2cor \
--workdir=/var/sentinel2_data/unzipped_scenes \
--mount type=bind,source=$archives,destination=/var/sentinel2_data/archives \
--mount type=bind,source=$unzipped_scenes,destination=/var/sentinel2_data/unzipped_scenes \
--mount type=bind,source=$src,destination=/src \
--mount type=bind,source=$aux,destination=$aux_container \
madmex/sen2cordocker_l2a:2.8.0 \
/src/wrapper.sh -d S2A_MSIL1C_20180107T175721_N0206_R141_T12QUM_20180107T193335
```

```bash
sudo docker service create --name l2a-2 --detach=false --restart-condition=on-failure --env USERID=1000 \
--env SEN2COR_HOME=/sen2cor --env SEN2COR_BIN=/sen2cor \
--workdir=/var/sentinel2_data/unzipped_scenes \
--mount type=bind,source=$archives,destination=/var/sentinel2_data/archives \
--mount type=bind,source=$unzipped_scenes,destination=/var/sentinel2_data/unzipped_scenes \
--mount type=bind,source=$src,destination=/src \
--mount type=bind,source=$aux,destination=$aux_container \
madmex/sen2cordocker_l2a:2.8.0 \
/src/wrapper.sh -d S2A_MSIL1C_20180107T175721_N0206_R141_T12QVM_20180107T193335
```

to monitor them:
```bash
sudo docker service ps l2a
```

to view the logs:
```bash
sudo docker service logs l2a
sudo docker service logs l2a-2
```

and to delete the ones that already finished:
```bash
for container in $(sudo docker service ps l2a | grep Shutdown  | tr -s ' ' | cut -d' ' -f2 | cut -d'.' -f1); do sudo docker service rm $container; done
```

## sen2cor with SLURM

**Requirement: in your nodes make sure to have docker image: `madmex/sen2cordocker_l2a:2.8.0` already pulled**

1. Create file `list_zipped.txt` with zip files to preprocess with sen2cor and directories: `logs_docker` and `logs_slurm` in your working directory. Clone next repository: [sen2cor_docker](https://github.com/CONABIO/sen2cor_docker) in your working directory and modify bash variable `src` (in the next shell) to the path of your working directory which holds `src` from repo.

2. Create shell `sen2cor_preprocess_with_docker.sh`:


**Note: modify `exclude` and `partition`, `archives`, `unzipped_scenes`, `src` flags according to your specifications**

```
#!/bin/bash
# first parameter is file to preprocess with sen2cor

#SBATCH --partition=cacomixtle
#SBATCH --ntasks=1           # total processes across nodes
#SBATCH --ntasks-per-node=1
#SBATCH --requeue
#SBATCH --exclude keri,nodo2,nodo4,nodo5

archives=/LUSTRE/MADMEX/tasks/2019_tasks/sen2cor_docker/data_zipped
unzipped_scenes=/LUSTRE/MADMEX/tasks/2019_tasks/sen2cor_docker/data_unzipped_slurm
src=/LUSTRE/MADMEX/tasks/2019_tasks/sen2cor_docker/sentinel_processing_version_2.8.0/src/
aux=/LUSTRE/MADMEX/sentinel2_aux_data/data/CCI4SEN2COR/
aux_container=/Sen2Cor-02.08.00-Linux64/lib/python2.7/site-packages/sen2cor/aux_data/

id_container=$(sudo docker run  \
-e USERID=1000 -e SEN2COR_HOME=/sen2cor -e SEN2COR_BIN=/sen2cor \
--workdir=/var/sentinel2_data/unzipped_scenes \
-v $archives:/var/sentinel2_data/archives \
-v $unzipped_scenes:/var/sentinel2_data/unzipped_scenes \
-v $src:/src \
-v $aux:$aux_container \
-dit madmex/sen2cordocker_l2a:2.8.0 \
/src/wrapper.sh -d $1)


status=$(sudo docker ps -a -f id=$id_container --format "{{.Status}}"|cut -d' ' -f1)
logfile=logs_docker/$(basename -s '.zip' $1).txt

while [ "$status" == "Up" ]
do
status=$(sudo docker ps -a -f id=$id_container --format "{{.Status}}"|cut -d' ' -f1)
done

sudo docker logs $id_container > $logfile

sudo docker rm $id_container
```

3. Execute next line to create list of jobs to launch:


```
for f in $(cat list_zipped.txt);do filename=$(basename -s '.zip' $f);echo "sbatch --error=logs_slurm/$filename.err --output=logs_slurm/$filename.out sen2cor_preprocess_with_docker.sh $f" >> slurm_sen2cor_launch.sh;done

```

4. Launch:

```
bash slurm_sen2cor_launch.sh
```

* Check logs in directory: `logs_docker` and in `logs_slurm`.





