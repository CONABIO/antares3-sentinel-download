#!/bin/bash

#default values

delete=n

function usage()
{
		printf "\n"
    printf "\t\t Fill nodata proccess for Landsat 7 scenes\n"
		printf "\n"
    printf "Usage: Some example here\n"
    printf "\n"
    printf "  -h --help\t\tPrints this help and exits\n"
    printf "  -p --path\tPath to Landsat 7 scenes (default $path)\n"
    printf "  -d --delete\tDelete original scenes (default off)\n"
		printf "\n"
}

# Works on Linux
getopt --test > /dev/null
if [[ $? -ne 4 ]]; then
    printf "I’m sorry, `getopt --test` failed in this environment.\n"
    exit 1
fi

OPTIONS=hp:d
LONGOPTIONS=help,path:,delete

PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTIONS --name "$0" -- "$@")

if [[ $? -ne 0 ]]; then
    # e.g. $? == 1
    #  then getopt has complained about wrong arguments to stdout
    usage
    exit 2
fi

# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

# options are split until we see --
while true; do
    case "$1" in
        -h|--help)
            usage
            exit
            ;;
        -p|--path)
            path="$2"
            shift 2
            ;;
        -d|--delete)
            delete=y
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            printf "Programming error\n"
            exit 3
            ;;
    esac
done

# handle non-option arguments
if [[ -z "$path" ]]; then
    usage
    printf "[ERROR] A path to scene(s) is required.\n"
    exit 4
fi


echo "Procesing scenes in" $path
