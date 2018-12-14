#!/bin/bash

ARG_O=0
ARG_T=0
ARG_D=0

show_options() {
    # if no param is given, display a menu and then exit
    (( $# < 1 )) && {
        # display a menu of options
        echo " "
        echo "            MAIN MENU"
        echo
        echo "       -o                Preprocess of Sentinel-1"
        echo "       -t                Preprocess of Sentinel-2"
        echo "       -d  <option>      Download mode: local, sge or none"
        echo "       -u  <user>        User"
        echo "       -p  <psswd>       Password"
        echo "       -g  <path/file>   Geojson file"
        echo "       -s  <start-date>  Start date YYYYMMDD"
        echo "       -e  <end-date>    End date YYYYMMDD"
        echo "       -c  <max cloud>   Maximum coverage of clouds per scene [0-1]"
        exit 1
    }
}

parse_options() {
    while getopts :otd:u:p:g:s:e:c opt
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
        c)
          cloud="${15}"
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
        download_sentinel
    }
}

download_sentinel() {
    if [ $arg_d == 'local' ] || [ $arg_d == 'sge' ] ; then
      mkdir $SATELITE"_downloads"
    fi
    if [ $arg_d != 1 ]; then
      python -B download_sentinel.py -u $user -p $psswd -t $SATELITE -g $gfile -s $start -e $end -d $arg_d -c $cloud
    else
      python -B download_sentinel.py -u $user -p $psswd -t $SATELITE -g $gfile -s $start -e $end -d $arg_d
    fi

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

    if [ $ARG_O == 1 ] && [ ! -z $cloud ]
      then
        echo "    It is not necessary to specify maximum cloudiness with Sentinel-1"
        echo "    Input value will be ignored."
    fi

    if [ -z $cloud ];
      then
        cloud=${15:-1}
    fi

    if [ $ARG_O == 1 ] && [ $ARG_T == 1 ]
      then
        echo "Is not possible to operate both sensors at the same time"
        exit 1
    fi

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
    [ -e $SATELITE"_downloads" ] && rm -rf $SATELITE"_downloads"
    [ -e "scenes_found.txt" ] && rm "scenes_found.txt"
    run
}

main "$@"
