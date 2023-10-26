#!/usr/bin/tcsh
#Aleksandra Jaroszek grupa nr 2

set HELP = false
set QUIET = false

alias help \
  'echo "Usage: ./skrypt1.tcsh [OPTIONS]"; \
   echo "Prints login, firstname and lastname."; \
   echo "Available options:"; \
   echo "-h, --help program help"; \
   echo "-q, --quiet quiet mode"'

foreach arg ($*)
  switch ($arg)
    case -h:
    case --help:
      set HELP = true
      breaksw
    case -q:
    case --quiet:
      set QUIET = true
      breaksw
    default:
      echo "Invalid options"
      help
      exit 1
  endsw
end

if ($HELP == true) then
  help
  exit 0
endif

if ($QUIET == true) then
  exit 0
endif

set USERNAME = `getent passwd $USER | awk -F: '{print $5}' | awk -F, '{print $1}'`
echo "$USER $USERNAME"

exit 0
