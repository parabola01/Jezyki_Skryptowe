#!/bin/tcsh

set ip="${argv[1]}"
set valid = `echo "$ip" | grep -E -w '\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b'`
if ( ($valid != '') ) then
  exit 0
else
  exit 1
fi