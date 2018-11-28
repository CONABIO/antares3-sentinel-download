import sys
import argparse
import sentinelsat

from sentinelsat import SentinelAPI, read_geojson, geojson_to_wkt
from datetime import date

def cmdline_args():
    # Make parser object
    parser = argparse.ArgumentParser(description=
        """
        This is a script to download Sentinel-1 and Sentinel-2 scenes.
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

    parser.add_argument("-s", 
                        "--start", 
                        required=True,
                        help="The Start Date - format YYYYMMDD")

    parser.add_argument("-e", 
                        "--end", 
                        required=True,
                        help="The End Date - format YYYYMMDD")

    parser.add_argument("-c", 
                        "--max-cloudcover", 
                        required=False,
                        default=100,
                        help="Maximum cloudiness in scene")

    parser.add_argument("-d","--download",
                        action="store_true",
                        help="include to enable")

    parser.add_argument("-v", "--verbosity",
                        type=int,
                        choices=[0,1,2],
                        default=0,
                        help="Increase output verbosity")


    return(parser.parse_args())


def search(user, psswd, sensor, file, start, end):
    '''
        
    '''
    url = 'https://scihub.copernicus.eu/dhus'
    api = SentinelAPI(user, psswd, url)
    footprint = geojson_to_wkt(read_geojson(file))
    
    if sensor == 's1':
        products = api.query(footprint,
                             date = (start, end),
                             platformname = 'Sentinel-1',
                             orbitdirection = 'ascending',
                             polarisationmode = 'VV VH',
                             producttype = 'GRD',
                             sensoroperationalmode = 'IW')

    for x in products:
        print (products[x]["filename"], products[x]["size"] )
    print("Found {} scenes in the region specified".format(len(products)))
    
    
if __name__ == '__main__':
    
    if sys.version_info<(3,0,0):
        sys.stderr.write("You need python 3.0 or later to run this script\n")
        sys.exit(1)
        
    try:
        args = cmdline_args()
        print(args)
    except:
        print('Try : \n download_sentinel.py -t s1 -g test.geojson -s 2018-01-0 -e 2018-12-31')

    search(args.user, args.password, args.satelite, args.geojson, args.start, args.end)

    


