# antares3-sentinel-download

# Downloading Sentinel-2 data

For now, the Sentinel-2 scene download process is not integrated into the MAD-Mex system. The download process is described below using the [sentinelsat](https://github.com/sentinelsat/sentinelsat) and [sentinelhub](https://github.com/sentinel-hub/sentinelhub-py) libraries.

Before starting, it is mandatory to have an account in AWS and Copernicus Open Access Hub, it is assumed that you have such libraries installed in a UNIX environment, for more details on the installation and configuration of Sentinelat and Sentinelhub you can review the documentation [here](https://sentinelsat.readthedocs.io/en/stable/) and [here](https://sentinelhub-py.readthedocs.io/en/latest/configure.html) respectively.

The approach we show below is to search the available scenes for a region using the Sentinelsat search engine.

```sentinelsat -u <user> -p <passwd> -g oaxaca.geojson -s 20180801 -e 20180810 --producttype S2MSI1C -q "orbitdirection=Descending" --url "https://scihub.copernicus.eu/dhus" --footprints --cloud 5 --sentinel 2```








