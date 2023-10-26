#!/usr/bin/tcsh
# Aleksandra Jaroszek grupa nr 2


if ( $#argv == 1 ) then
  set arg = "$argv[1]"
  set is_numeric = `expr "$arg" : '[-]\?[0-9]\+'`
  if ( $is_numeric ) then
    if ( "$argv[1]" > 0 ) then
      set number_1 = 1
      set number_2 = $argv[1]
    else
      set number_1 = $argv[1]
      set number_2 = 1
    endif
  else
    echo "Please give a numeric argument"
    exit 1
  endif
else if ( $#argv >= 2 ) then
  set arg1 = "$argv[1]"
  set arg2 = "$argv[2]"
  set is_numeric1 = `expr "$arg1" : '[-]\?[0-9]\+'`
  set is_numeric2 = `expr "$arg2" : '[-]\?[0-9]\+'`
  if ( $is_numeric1 && $is_numeric2 ) then
    if ( "$argv[1]" > "$argv[2]" ) then
      set number_1 = $argv[2]
      set number_2 = $argv[1]
    else
      set number_1 = $argv[1]
      set number_2 = $argv[2]
    endif
  else
    echo "Please give numeric arguments"
    exit 1
  endif
  else if ( $#argv == 0) then
    set number_1 = 1
    set number_2 = 9
  
endif

foreach num_1 ( `seq $number_1 $number_2` )
  foreach num_2 ( `seq $number_1 $number_2` )
    set result = `expr $num_1 \* $num_2`
    printf "%4d" "$result"
  end
  echo
end

exit 0
