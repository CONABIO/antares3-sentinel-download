import sys
import argparse
import sentinelsat
import logging

from sentinelsat import SentinelAPI, read_geojson, geojson_to_wkt
from datetime import date
from _download import exec_commands

logging.basicConfig(level=logging.INFO)


def cmdline_args():
    # Make parser object
    parser = argparse.ArgumentParser(description=
        """
            This script performs a search of the available scenes of sentinel-1 and sentinel-2
            according to the parameters provided by the user. Additionally, if download is
            required, it will be done in the directory provided. It is highly recommended to
            download only small amounts of scenes with this script. If you want to download many
            scenes it is recommended to do it with Sun Grid Engine providing the appropriate
            flag for it.
        """,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument("-u", "--user",
                        required=True,
                        help="User ESA account")

    parser.add_argument("-p", "--password",
                        required=True,
                        help="Password ESA account")

    parser.add_argument("-t", "--satelite",
                        type=str,
                        choices=["s1","s2"],
                        required=True,
                        help="Sensor type to download, can be sentinel-2 or sentinel-1")

    parser.add_argument("-g", "--geojson",
                        required=True,
                        help="Geojson geometry file. It should be a polygon as simple as possible")

    parser.add_argument("-s", "--start",
                        required=True,
                        help="The Start Date - format YYYYMMDD")

    parser.add_argument("-e", "--end",
                        required=True,
                        help="The End Date - format YYYYMMDD")

    parser.add_argument("-c", "--maxcloud",
                        required=False,
                        default=1,
                        help="Maximum cloudiness in scene")

    parser.add_argument("-d","--download",
                        choices=["local","sge", "none"],
                        default="none",
                        help="Download mode")

    parser.add_argument("-v", "--verbosity",
                        type=int,
                        choices=[0,1,2],
                        default=0,
                        help="Increase output verbosity")


    return(parser.parse_args())


def search(user, psswd, sensor, file, start, end, maxcloud):
    '''
        Searching for all the available scenes in the specified
        region and with the parameters provided by user
    '''
    url = 'https://scihub.copernicus.eu/dhus'
    api = SentinelAPI(user, psswd, url)
    footprint = geojson_to_wkt(read_geojson(file))

    if sensor == 's1':
        products = api.query(footprint,
                             date = (start, end),
                             platformname = 'Sentinel-1',
                             orbitdirection = 'ASCENDING',
                             polarisationmode = 'VV VH',
                             producttype = 'GRD',
                             sensoroperationalmode = 'IW')
        for x in products:
            logging.info("\t {}  {} ".format(products[x]["filename"], products[x]["size"]) )
        logging.info("\t Found {} scenes in the region specified".format(len(products)))

        with open("scenes_s1_found.txt", "w") as f:
            for i in products:
                f.write(products[i]["uuid"]+ "\n")

        return (products, api)

    if sensor == 's2':
        products = api.query(footprint,
                             date = (start, end),
                             platformname='Sentinel-2',
                             cloudcoverpercentage=(0, maxcloud))
        for x in products:
            logging.info("\t {}  {} ".format(products[x]["filename"], products[x]["size"]) )
        logging.info("\t Found {} scenes in the region specified".format(len(products)))

        with open("scenes_s2_found.txt", "w") as f:
            for i in products:
                f.write(products[i]["identifier"]+ "\n")

        return (products)

def download_local_s2(out_dir):
    '''
        Downloads all the scenes found by query
    '''
    commands = []
    with open("scenes_s2_found.txt") as f:
        for line in f:
            tmp_list = []
            tmp_list.append("sentinelhub.aws")
            tmp_list.append("--product")
            tmp_list.append(line[:-1])
            tmp_list.append("-f")
            tmp_list.append(out_dir)
            commands.append(tmp_list)

    exec_commands(commands, len(commands))

def download_local_s1(scenes, api):
    '''
        Downloads all the scenes found by query
    '''
    api.download_all(scenes)


def download_sge(out_dir):
    '''
        Downloads all the scenes found by query
    '''
    # api.download_all(scenes)
    print ("Download sge")

if __name__ == '__main__':

    if sys.version_info<(3,0,0):
        sys.stderr.write("You need python 3.0 or later to run this script\n")
        sys.exit(1)

    try:
        args = cmdline_args()
        logging.info(args)
        if args.satelite == "s1":
            outdir = "s1_downloads"

        if args.satelite == "s2":
            outdir = "s2_downloads"

        if args.download == "local" and args.satelite == "s2":
            logging.info("Querying scenes")
            scenes = search(args.user, args.password, args.satelite, args.geojson, args.start, args.end, args.maxcloud)
            logging.info("Starting local download for Sentinel-2")
            download_local_s2(outdir)

        if args.download == "local" and args.satelite == "s1":
            logging.info("Querying scenes")
            scenes, a = search(args.user, args.password, args.satelite, args.geojson, args.start, args.end, args.maxcloud)
            logging.info("Starting local download Sentinel-1")
            download_local_s1(scenes, a)

        if args.download == "sge":
            logging.info("Querying scenes")
            scenes = search(args.user, args.password, args.satelite, args.geojson, args.start, args.end, args.maxcloud)
            logging.info("Starting SGE download")
            download_sge(outdir)

        if args.download == "none":
            logging.info("Querying scenes")
            scenes = search(args.user, args.password, args.satelite, args.geojson, args.start, args.end, args.maxcloud)
    except:
        logging.error("Oops!",sys.exc_info()[0],"occured.")
        logging.info('Try : \n download_sentinel.py -u <user> -p <psswd> -t <satelite> -g /path/to/file.geojson -s YYYYMMDD -e YYYYMMDD')
