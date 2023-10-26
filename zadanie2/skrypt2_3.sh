#!/usr/bin/bash
# Aleksandra Jaroszek grupa nr 2


if [ $# -lt 3 ]; then  
   echo "Three arguments needed"
   exit 1
fi

REGEX_OPERATOR="[+\-m/\^%]"

if [[ $1 == $REGEX_OPERATOR ]]; then
  operator="$1"
    number1="$2"
    number2="$3"
elif [[ $2 == $REGEX_OPERATOR ]]; then
  operator="$2"
    number1="$1"
    number2="$3"
elif [[ $3 == $REGEX_OPERATOR ]]; then
  operator="$3"
    number1="$1"
    number2="$2"
else
  echo "Invalid operator"
  echo 'Avaliable operators:'
  echo '+, -, m (multiplication), /, %, ^ (exponentiation)'
  exit 2
fi

if [[ $number1 -gt $number2 ]]; then
  tmp="$number1"
  number1="$number2"
  number2="$tmp"
fi

REGEX_NUMBERS="^-?[0-9]+$"

if ! [[ $number1 =~ $REGEX_NUMBERS ]] || ! [[ $number2 =~ $REGEX_NUMBERS ]]; then
  echo "Two numeric arguments needed"
  exit 1
fi


for NUM_1 in $(seq "$number1" "$number2"); do

  for NUM_2 in $(seq "$number1" "$number2"); do

    case "$operator" in
    +)
        result=$((NUM_1 + NUM_2))
        echo -ne "$result\t"
        ;;
    -)
        result=$((NUM_1 - NUM_2))
        echo -ne "$result\t"
        ;;
    m)
        result=$((NUM_1 * NUM_2))
        echo -ne "$result\t"
        ;;
    /)
        if [[ "$NUM_2" == 0 ]]; then
            echo -ne "NaN\t"
        else
             echo "$NUM_1 $NUM_2" | awk '{printf "%.2f \t", $1/$2}'
        fi
        ;;
    %)
        if [[ "NUM_2" -eq 0 ]]; then
            echo -ne "NaN\t"
        else
            result=$((NUM_1 % NUM_2))
            echo -ne "$result\t"
        fi
        ;;
    ^)
        if [[ "NUM_1" -lt 0 || "NUM_2" -lt 0 ]]; then
            echo -ne "NaN\t"
        else
            result=$((NUM_1 ** NUM_2))
            echo "$NUM_1 $NUM_2" | awk '{printf "%.2f \t", $1^$2}'
        fi
        ;;
    *)
        echo "Invalid operator: $operator"
        exit 2
        ;;
    esac
    done
    echo ''
done

exit 0