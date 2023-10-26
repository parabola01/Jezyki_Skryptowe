#!/usr/bin/bash
#Aleksandra Jaroszek grupa nr 2

for number_1 in $(seq 9); do
	for number_2 in $(seq 9); do
	result=$[ number_1 * number_2 ]
	printf "%4d " "$result"
	done
	echo 
done

exit 0
