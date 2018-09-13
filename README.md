# antares3-sentinel-download

# Downloading Sentinel-2 data

For now, the Sentinel-2 scene download process is not integrated into the MAD-Mex system. The download process is described below using the [sentinelsat](https://github.com/sentinelsat/sentinelsat) and [sentinelhub](https://github.com/sentinel-hub/sentinelhub-py) libraries.

Before starting, it is mandatory to have an account in AWS and Copernicus Open Access Hub, it is assumed that you have such libraries installed in a UNIX environment as well as the [sen2cor](http://step.esa.int/main/third-party-plugins-2/sen2cor/) tool, for more details on the installation and configuration of Sentinelat and Sentinelhub you can review the documentation [here](https://sentinelsat.readthedocs.io/en/stable/) and [here](https://sentinelhub-py.readthedocs.io/en/latest/configure.html) respectively.

The approach we show below is to search the available scenes for a region using the Sentinelsat search engine. Here is an example of use for the region of Oaxaca, Mexico for a specific period of time. The `--footprints` flag means that you do not download the found scenes but write the results to a file called `search_footprints.geojson`.

```
sentinelsat -u <user> -p <passwd> -g oaxaca.geojson -s 20180801 -e 20180810 --producttype S2MSI1C -q "orbitdirection=Descending" --url "https://scihub.copernicus.eu/dhus" --footprints --cloud 5 --sentinel 2
```

With the following output:

```
I1C -q "orbitdirection=Descending" --url "https://scihub.copernicus.eu/dhus" --footprints --cloud 5 --sentinel 2
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

It is very important to mention that the file of the search region must be a polygon as simple as possible, a very complex polygon and with many points can cause an error in the command. For the previous example, this is the search file for the Oaxaca region:

```
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {},
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [
              -98.69018554687499,
              16.29905101458183
            ],
            [
              -98.272705078125,
              15.971891580928983
            ],
            [
              -96.416015625,
              15.464269084198357
            ],
            [
              -94.998779296875,
              16.024695711685315
            ],
            [
              -93.8232421875,
              15.866241564066629
            ],
            [
              -93.658447265625,
              17.24574420800713
            ],
            [
              -94.46044921875,
              17.308687886770034
            ],
            [
              -95.262451171875,
              17.8846591795428
            ],
            [
              -96.536865234375,
              18.771115062337024
            ],
            [
              -97.591552734375,
              18.562947442888312
            ],
            [
              -98.734130859375,
              17.78007412664325
            ],
            [
              -98.32763671875,
              16.951724234434437
            ],
            [
              -98.69018554687499,
              16.29905101458183
            ]
          ]
        ]
      }
    }
  ]
}
```
It is possible to configure environment variables for the user and password in sentinelsat and avoid entering them in the command line. Simply write the following lines in the `~/.bashrc` file


```
export DHUS_USER="<user>"
export DHUS_PASSWORD="<password>"
export DHUS_URL="https://scihub.copernicus.eu/dhus"
```
Therefore, an alternative command line would be:

```
sentinelsat -g oaxaca.geojson -s 20180801 -e 20180810 --producttype S2MSI1C -q "orbitdirection=Descending" --footprints --cloud 5 --sentinel 2
```

The download now is done with Sentinelhub with its download tool from AWS. To do that, we'll use a python script to read the `search_footprints.geojson` file to get the product name. 


```
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

```
sentinelhub.aws --product S2B_MSIL1C_20180805T170009_N0206_R069_T14QPE_20180805T221143 -f ~/s2_downloads
``` 
The `~/s2_downloads` folder must be created previously. 


# Running sen2cor

There is an important aspect to keep in mind, the scenes downloaded with Sentinelhub come from the S3 bucket `sentinel-s2-l1c`, therefore the `.SAFE` format is only being emulated by the download tool. Once the download has finished, we can proceed to run `sen2cor` as follows:

```
L2A_Process ~/s2_downloads/S2B_MSIL1C_20180805T170009_N0206_R069_T14QPE_20180805T221143.SAFE
```

The above command is possible if the following alias is previously defined in the `~/.bashrc` file:

```
alias L2A_Process='/home/<user>/Sen2Cor-02.05.05-Linux64/bin/L2A_Process'
```
The complete path depends on the folder of installation defined for sen2cor.










