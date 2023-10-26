#!/usr/bin/tcsh
# Aleksandra Jaroszek grupa nr 2

#!/bin/tcsh

# Aleksandra Jaroszek grupa nr 2

if ($#argv < 2) then
  echo "Two arguments needed"
  exit 1
endif

set start_ip = "$argv[1]"
set end_ip = "$argv[2]"

./validate.csh $start_ip
set result1 = $status

./validate.csh $end_ip
set result2 = $status

if ($result1 != 0 || $result2 != 0) then
  echo "Invalid IP addresses provided."
  exit 1
endif

./validate_class.csh $start_ip $end_ip
set result_class = $status

if  ($result_class != 0) then
  echo "Start and end IPs are not from the same class."
  exit 1
endif

set arguments = ( "${argv[1]}" "${argv[2]}" )
set not_sorted = `echo $arguments`
set sorted = `echo $arguments | fmt -1 | sort -n`

if ( ("$sorted" == "$not_sorted") ) then
  set ip_start = "${argv[1]}"
  set ip_end = "${argv[2]}"
else
  set ip_start = "${argv[2]}"
  set ip_end = "${argv[1]}"
endif

set s = ${argv[3]}
set ports = `echo $s:q | sed 's/,/ /g'`

@ bottom = 0
@ top = 0

foreach i (`seq 1 4`)
	@ bottom_base = "`echo "$ip_start" | cut -d. -f"$i"`"
	@ top_base = "`echo "$ip_end" | cut -d. -f"$i"`"

    @ pow = 4 - $i
	set exp = `echo "256 $pow" | awk '{printf "%d", $1^$2}'`
	@ bottom = $bottom + $bottom_base * $exp
	@ top = $top + $top_base * $exp
end


foreach i (`seq "$bottom" "$top"`)

	@ ip_part_1 = $i / (256 * 256 * 256)
	@ ip_part_2 = ($i / (256 * 256)) % 256
	@ ip_part_3 = ($i % (256 * 256)) / 256
	@ ip_part_4 = $i % 256

	set ip_result = $ip_part_1.$ip_part_2.$ip_part_3.$ip_part_4
  
	foreach j ($ports)
    set command=`printf 'GET /get HTTP/1.1\r\n\r\n' | timeout 1 nc $ip_result "$j"`

    set pattern_http='http|HTTP'
    set pattern_ssh='ssh|SSH'

    echo "$command" | grep -E "$pattern_http" >/dev/null
    if ( $? == 0) then
      echo "$ip_result":"$j"' protocol: http, '
      echo "$command" | grep -E '^Server*'
    else
      echo "$command" | grep -E "$pattern_ssh"
      if ( $? == 0 ) then
        echo "$ip_result":"$j"' protocol: ssh, '
        echo "$command"
      else
        nc -w 1 -n -v $ip_result $j
        if ( $? == 0) then
          echo "$ip_result":"$j" is opened!
        else
          echo "$ip_result":"$j" is closed!
        endif
      endif
    endif
  end
end

exit 0

