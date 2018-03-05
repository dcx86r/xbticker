#!/bin/bash

GET() {
	net_check=$(curl -s -I -1 https://google.com)
	if [[ -n $net_check ]]; then
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

[[ -z $1 ]] && echo -e "\tusage: $0 <currency_code>\n\texample: $0 USD" && exit;
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
