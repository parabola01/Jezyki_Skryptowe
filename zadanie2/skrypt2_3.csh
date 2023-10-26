#!/usr/bin/tcsh
# Aleksandra Jaroszek grupa nr 2

if ( $#argv < 3 ) then
   echo "Three arguments needed"
   exit 1
endif

set numeric_count = 0

foreach arg ( $argv[1] $argv[2] $argv[3] )
  set valid = `echo $arg | grep -E -w '^-?[0-9]+$|^0$'`
  if ( $valid || $valid == 0) then
    set numeric_count = `expr $numeric_count + 1`
  endif
end

if ( $numeric_count == 2 ) then
else
  echo "Two numeric arguments needed"
  exit 1
endif

if ( "$1" =~ [-+m/%^] ) then
  set operator = "$1"
  if ( "$2" > "$3" ) then
    set number1 = "$3"
    set number2 = "$2"
  else
    set number1 = "$2"
    set number2 = "$3"
  endif
else if ( "$2" =~ [-+m/%^] ) then
  set operator = "$2"
  if ( "$1" > "$3" ) then
    set number1 = "$3"
    set number2 = "$1"
  else
    set number1 = "$1"
    set number2 = "$3"
  endif
else if ( "$3" =~ [-+m/%^] ) then
  set operator = "$3"
  if ( "$1" > "$2" ) then
    set number1 = "$2"
    set number2 = "$1"
  else
    set number1 = "$1"
    set number2 = "$2"
  endif
else
  echo "Invalid operator"
  echo 'Avaliable operators:'
  echo '+, -, m (multiplication), /, %, ^ (exponentiation)'
  exit 2
endif


foreach NUM_1 (`seq "$number1" "$number2"`)
  foreach NUM_2 (`seq "$number1" "$number2"`)
    switch ( "$operator" )
      case "+":
        set result = `expr $NUM_1 + $NUM_2`
        echo -n "$result\t"
        breaksw
      case "-":
        set result = `expr $NUM_1 - $NUM_2`
        echo -n "$result\t"
        breaksw
      case "m":
        set result = `expr $NUM_1 \* $NUM_2`
        echo -n "$result\t"
        breaksw
      case "/":
        if ( "$NUM_2" == 0 ) then
          echo -n 'NaN\t'
        else
          set result = `echo "$NUM_1 / $NUM_2" | bc -l`
          printf "%.2f\t" "$result"
        endif
        breaksw
      case "%":
        if ( "$NUM_2" == 0 ) then
        echo -n 'NaN\t'
        else  
          set result = `expr $NUM_1 % $NUM_2`
          echo -n "$result\t"
        endif
        breaksw
      case "^":
        if ( "$NUM_1" < 0 || "$NUM_2" < 0 ) then
          echo -n 'NaN\t'
        else
          set result = `echo "$NUM_1 $NUM_2" | awk '{printf "%.2f \t", $1^$2}'`
          echo -n "$result\t"
        endif
        breaksw
      default:
        echo "Invalid operator: $operator"
        exit 2
    endsw
  end
  echo ''
end

exit 0
