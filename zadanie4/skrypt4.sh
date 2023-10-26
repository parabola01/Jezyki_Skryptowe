#!/usr/bin/bash
# Aleksandra Jaroszek grupa nr 2

function is_valid_ip() {
  pattern='\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b'
    if ! echo "$1" | grep -E -o -q "$pattern"; then
      return 1
    else
      return 0
    fi
}

function is_valid_port() {
  pattern='[-]?[0-9]+'
    if ! echo "$1" | grep -E -w -q "$pattern"; then
        return 1
    else 
        return 0
  fi
}

function ip_class() {
    ip_1="$1"
    ip_2="$2"
    ip1_part0=$(echo "$ip_1" | cut -d'.' -f1)
    ip2_part_0=$(echo "$ip_2" | cut -d'.' -f1)
    class1="$(get_ip_class "$ip1_part0")"
    class2="$(get_ip_class "$ip2_part_0")"
    [ "$class1" = "$class2" ]
}

function get_ip_class() {
    CLASS_A=(1 127)  
    CLASS_B=(128 191) 
    CLASS_C=(192 223) 
    CLASS_D=(224 239) 
    if [[ "$1" -ge ${CLASS_A[0]} && "$1" -le ${CLASS_A[1]} ]]; then
        echo "A"
    elif [[ "$1" -ge ${CLASS_B[0]} && "$1" -le ${CLASS_B[1]} ]]; then
        echo "B"
    elif [[ "$1" -ge ${CLASS_C[0]} && "$1" -le ${CLASS_C[1]} ]]; then
        echo "C"
    elif [[ "$1" -ge ${CLASS_D[0]} && "$1" -le ${CLASS_D[1]} ]]; then
        echo "D"
    else
        echo "E"
    fi
}

if [ $# -lt 3 ]; then
    echo "Three arguments needed"
  exit 1
fi

ip1="$1"
ip2="$2"

if ! ip_class "$ip1" "$ip2"; then
  echo "Start and end IPs are not from the same class."
  exit 1
fi

if ! is_valid_ip "$ip1" || ! is_valid_ip "$ip2"; then
  echo "Argument is not a valid IP4 address"
  exit 1
fi

if ! is_valid_port "$3"; then
    echo "Argument is not a valid port"
    exit 1
fi


args=()
for arg in "$@"; do
    args+=("${arg}")
done

ips=("${args[0]}" "${args[1]}")
sorted=$(
  for each in "${ips[@]}"; do
    echo "$each"
  done | sort -t . -k 3,3n -k 4,4n
)


addresses=()
for i in $(echo "$sorted" | tr " " "\n"); do
    addresses+=("$i")
done

ports=()
for i in $(echo "${args[2]}" | tr "," "\n"); do
  ports+=("$i")
done

ip_start="${addresses[0]}"
ip_end="${addresses[1]}"


for i in $(seq 1 4); do

  base_bottom="$(echo "$ip_start" | cut -d. -f "$i")"
  base_top="$(echo "$ip_end" | cut -d. -f "$i")"

  exp=$((256 ** (4 - i)))
  bottom=$((bottom + base_bottom * exp))
  top=$((top + base_top * exp))

done

for i in $(seq "$bottom" "$top"); do

  ip_part_1=$((i / (256 * 256 * 256)))
  ip_part_2=$(((i / (256 * 256)) % 256))
  ip_part_3=$(((i % (256 * 256)) / 256))
  ip_part_4=$((i % 256))

  ip_result=$ip_part_1.$ip_part_2.$ip_part_3.$ip_part_4

  for j in "${ports[@]}"; do

    s=$(printf 'GET /get HTTP/1.1\r\n\r\n' | timeout 1 nc $ip_result "$j")

    pattern_http='http|HTTP'
    pattern_ssh='ssh|SSH'
    if echo "$s" | grep -E "$pattern_http" >/dev/null; then
      echo -n "$ip_result:$j protocol: http, "
      echo "$s" | grep -E '^Server*'
    elif echo "$s" | grep -E "$pattern_ssh"; then
      echo -n "$ip_result:$j protocol: ssh, "
      echo "$s"
    else
      timeout 2 bash -c "nc -w 1 -n -v $ip_result $j"
      if [ $? == 0 ]; then
        echo "$ip_result:$j is open!"
      else
        echo "$ip_result:$j is closed!"
      fi
    fi
  done
done

exit 0
