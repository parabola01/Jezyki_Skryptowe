#!/usr/bin/tcsh
# Aleksandra Jaroszek grupa nr 2

foreach number_1 (`seq 9`)
    foreach number_2 (`seq 9`)
        set result = `expr $number_1 \* $number_2`
        printf "%4d " "$result"
    end
    echo
end

exit 0
