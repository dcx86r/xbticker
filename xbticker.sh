#!/bin/bash

#pass relevant ISO 4217 currency code to program as argument

GET() {
	net=$(curl -s -I -1 https://google.com | sed -n 1p | awk '{ print $2 }')
	if [[ $net =~ (2|3)[0-9][0-9] ]]; then
		echo $(curl -s --tlsv1.2 https://blockchain.info/ticker | sed -n /$1/p \
			| awk -F ':' '{ print $6 }' | cut -d ',' -f 1 | sed -n 's/^ //p')
	else
		echo "NaN"
	fi
}

PRINT() {
	printf "%.*f" 2 $1
	printf "%*s" 4
	echo -en "\r"
}

QUIT() {
	tput cnorm
	exit
}

trap QUIT INT
count=1
tput civis

while true; do
	[[ $count -eq 1 ]] \
		&& price=$(GET $1)
	if [[ $count -lt 60 ]]; then
		echo -n "$1 "
		PRINT $price
		((count++))
	else
		count=1
	fi
	sleep 30
done
