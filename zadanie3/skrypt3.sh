#!/usr/bin/bash
# Aleksandra Jaroszek grupa nr 2

is_valid_ip() {
  pattern='\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b'
    if ! echo "$1" | grep -E -o -q "$pattern"; then
      return 1
    else
      return 0
    fi
}

ping_ip(){
    local ip="$1"

    ping -W 1 -c 1 "$ip" >/dev/null

    if [ $? == 0 ]; then
        echo $ip "is alive!"
    else
        echo $ip "is dead!"
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


if [ $# -lt 2 ]; then
    echo "Two arguments needed"
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

args=()
for arg in "$@"; do
    args+=("${arg}")
done

sorted=$(
    for each in "${args[@]}"; do
        echo "$each"
    done | sort -t . -k 3,3n -k 4,4n
)

addresses=()
for i in $(echo "$sorted" | tr " " "\n"); do
    addresses+=("$i")
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
  ping_ip "$ip_result"
done

exit 0
