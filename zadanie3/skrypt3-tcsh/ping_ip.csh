#!/bin/tcsh
set ip="${argv[1]}"

ping -W 1 -c 1 "$ip" >/dev/null
if (( "$?" == 0 )) then 
    echo $ip "is alive!" 
else 
    echo $ip "is dead!" 
endif