#!/bin/bash

ARG_O=0
ARG_T=0
ARG_D=0
ARG_U=0
ARG_P=0
ARG_G=0
ARG_S=0
ARG_E=0

show_options() {
    # if no param is given, display a menu and then exit
    (( $# < 1 )) && {
        # display a menu of options
        echo "            MAIN MENU"
        echo
        echo "       -o               Preprocess of Sentinel-1"
        echo "       -t               Preprocess of Sentinel-2"
        echo "       -d <option>      Download mode: local or aws"
        echo "       -u <user>        User"
        echo "       -p <psswd>       Password"
        echo "       -g <path/file>   Geojson file"
        echo "       -s <start-date>  Start date"
        echo "       -e <end-date>    End date"
        exit 1
    }
}

main() {
    show_options "$@"
}

main "$@"
