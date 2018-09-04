# antares3-sentinel-download

# Workflow to download Sentinel imagery for MAD-Mex

To obtain Sentinel images, you can consult them through the `dhusget.sh` script. For example, all the images available for Mexico between 2018-01-01 and 2018-08-01 could be searched as shown below:

```bash dhusget.sh -d https://scihub.copernicus.eu/dhus -u <user> -p <passwd> -m Sentinel-2 -S 2018-01-01T00:00:00.000Z -E 2018-08-01T23:00:00.000Z -T S2MSI1C -c -117.12,14.53:-86.81,32.7 -q```

Where `<user>` and `<passwd>` are the credential for access in [Copernicus Open Access Hub](https://scihub.copernicus.eu/dhus/#/home). The rest of the parameters are to limit the search for a specific mission, in our case Sentinel-2, the initial and final dates in which the scene was taken, the type of product and finally the coordinates of opposite vertices of the bounding box of the region of interest, in our example Mexico. For more details on the use of the script consult the following [link](https://scihub.copernicus.eu/userguide/BatchScripting).

If you need help to determine the bounding box of a particular region, you can consult the following [page](https://boundingbox.klokantech.com/).



	



 