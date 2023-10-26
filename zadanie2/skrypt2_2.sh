#!/usr/bin/bash
# Aleksandra Jaroszek grupa nr 2

regex="^-?[0-9]+$"


if [ $# -eq 1 ]; then 
  if [[ $1 =~ $regex ]]; then
    if [ "$1" -gt 0 ]; then
      number_1=1
      number_2="$1"
    else
      number_1="$1"
      number_2=1
    fi
  else
    echo "Please give numeric argument"
    exit 1
  fi
elif [ $# -eq 2 ]; then
  if [[ $1 =~ $regex ]] && [[ $2 =~ $regex ]]; then
    if [[ "$1" -gt "$2" ]]; then
    number_1="$2"
    number_2="$1"
    else
    number_1="$1"
    number_2="$2"
    fi
  else
    echo "Please give numeric arguments"
    exit 1
  fi
elif [ $# -eq 0 ]; then
    number_1=1
    number_2=9

fi


for NUMBER_1 in $(seq "$number_1" "$number_2"); do
        for NUMBER_2 in $(seq "$number_1" "$number_2"); do
        result=$[ NUMBER_1 * NUMBER_2 ]
        printf "%4d" "$result"
        done
        echo
done

exit 0