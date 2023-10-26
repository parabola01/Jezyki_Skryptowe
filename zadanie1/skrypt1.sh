#!/usr/bin/bash
#Aleksandra Jaroszek grupa nr 2

help() {
        echo 'Usage: ./skrypt1.sh [OPTIONS]'
        echo 'Prints login, firstname and lastname.'
        echo 'Avaliable options:'
        echo '-h, --help program help'
        echo '-q, --quiet quiet mode'
}



HELP=false
QUIET=false

for arg in "$@";do
        case $arg in
        -h | --help)
                HELP=true
                ;;
        -q | --quiet)
                QUIET=true
                ;;
        -*)
                echo "Invalid options"
                help
                exit 1
                ;;
        esac
done

if [ "$HELP" == true ]; then
        help
        exit 0
fi

if [ "$QUIET" == true ]; then
        exit 0
fi


USERNAME=$(getent passwd "$USER" | awk -F: '{print $5}' | awk -F, '{print $1}')
echo "$USER" "$USERNAME"

exit 0
