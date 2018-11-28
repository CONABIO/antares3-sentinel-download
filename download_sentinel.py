import sys
import argparse

def cmdline_args():
    # Make parser object
    parser = argparse.ArgumentParser(description=
        """
        This is a script to download Sentinel-1 and Sentinel-2 scenes.
        """,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    
    parser.add_argument("-t", "--satelite",
                        type=str,
                        choices=["s1","s2"],
                        required=True,
                        help="Sensor type to download, can be sentinel-2 or sentinel-1")

    parser.add_argument("-g", "--geojson",
                        type=argparse.FileType('r'),
                        required=True,
                        help="Geojson geometry file. It should be a polygon as simple as possible")

    parser.add_argument("-s", 
                        "--start-date", 
                        required=True,
                        help="The Start Date - format YYYY-MM-DD")

    parser.add_argument("-e", 
                        "--end-date", 
                        required=True,
                        help="The End Date - format YYYY-MM-DD")

    parser.add_argument("-d","--download",
                        action="store_true",
                        help="include to enable")

    parser.add_argument("-v", "--verbosity",
                        type=int, choices=[0,1,2], default=0,
                        help="Increase output verbosity")


    return(parser.parse_args())


if __name__ == '__main__':
    
    if sys.version_info<(3,0,0):
        sys.stderr.write("You need python 3.0 or later to run this script\n")
        sys.exit(1)
        
    try:
        args = cmdline_args()
        print(args)
    except:
        print('Try : \n download_sentinel.py -t s1 -g test.geojson -s 2018-01-0 -e 2018-12-31')

    print()