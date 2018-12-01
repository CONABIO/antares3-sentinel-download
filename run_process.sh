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
        echo "       -d <option>      Download mode: local, sge or none"
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
          SATELITE="s1"
          #echo "ARG_O is set"
          ;;
        t)
          ARG_T=1
          SATELITE="s2"
          #echo "ARG_T is set"
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

check_download_mode() {
  (( $ARG_D == 1 )) && {
        [ $arg_d == 'local' ] && ( run_with_download_local )
        [ $arg_d == 'sge' ] && ( run_with_download_sge )
        [ $arg_d == 'none' ] && ( run_without_download )
    }
}

run_with_download_local() {
    echo "Running python with download local..."
    python download_sentinel.py -u $user -p $psswd -t $SATELITE -g $gfile -s $start -e $end -d $arg_d
}

run_with_download_sge() {
    echo "Running python with download with sge..."
    python download_sentinel.py -u $user -p $psswd -t $SATELITE -g $gfile -s $start -e $end -d $arg_d
}

run_without_download() {
    echo "Running python without download..."
    python download_sentinel.py -u $user -p $psswd -t $SATELITE -g $gfile -s $start -e $end -d $arg_d
}

s1_preprocess() {
    echo "s1 preprocess enabled"
    # Download S1
    check_download_mode
    # Preproc S1
    # Upload to s3
}

s2_preprocess() {
    echo "s2 preprocess enabled"
    # Download S2
    check_download_mode
    # Preproc S1
    # Upload to s3
}

run() {
    (( $ARG_O == 1 )) && {
      s1_preprocess
    }
    (( $ARG_T == 1 )) && {
        s2_preprocess
    } 
}

main() {
    show_options "$@"
    parse_options "$@"
    run
}

main "$@"
