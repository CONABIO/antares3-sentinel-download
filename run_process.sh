#!/bin/bash

ARG_O=0
ARG_T=0
ARG_D=0

show_options() {
    # if no param is given, display a menu and then exit
    (( $# < 1 )) && {
        # display a menu of options
        echo "            MAIN MENU"
        echo
        echo "       -o               Preprocess of Sentinel-1"
        echo "       -t               Preprocess of Sentinel-2"
        echo "       -d <option>      Download mode: local or sge"
        echo "       -u <user>        User"
        echo "       -p <psswd>       Password"
        echo "       -g <path/file>   Geojson file"
        echo "       -s <start-date>  Start date"
        echo "       -e <end-date>    End date"
        exit 1
    }
}

parse_options() {

    while getopts :otd:u:p:g:s:e: opt
    do
      case $opt in
        o)
          ARG_O=1
          echo "ARG_O is set"
          ;;
        t)
          ARG_T=1
          echo "ARG_T is set"
          ;;
        d)
          arg_d=$OPTARG
          ARG_D=1
          echo "arg_d is set to \"$arg_d\""
          ;;
        u)
          user="$5"
          ;;
        p)
          psswd="$7"
          ;;
        g)
          gfile="$9"
          ;;
        s)
          start="${11}"
          ;;
        e)
          end="${13}"
          ;;
        ?)
          echo "Unknow option"
          echo "$OPTARG is not valid"
          exit 1
          ;;
      esac
    done
}


run() {

    (( $ARG_O == 1 )) && {
      echo "s1_preprocess"
    }

    (( $ARG_D == 1 )) && {
        [ $arg_d == 'local' ] && ( echo "run_with_download_local" )
        [ $arg_d == 'sge' ] && ( echo "run_with_download_sge" )
    }

    (( $ARG_T == 1 )) && {
        echo "s2_preprocess"
    }

    echo "user:     " $user
    echo "password: " $psswd
    echo "geojson:  " $gfile
    echo "start:    " $start
    echo "end:      " $end

}


main() {
    show_options "$@"
    parse_options "$@"
    run
}

main "$@"
