#!/bin/sh

GET() {
	net_check=$(curl -s -I -1 https://google.com)
	if [ -n "$net_check" ]; then
		fiat=$1
		export fiat
		echo $(curl -s --tlsv1.2 https://blockchain.info/ticker |\
			perl -MJSON -n0e 'my $json = decode_json $_;
				print $json->{$ENV{fiat}}->{"15m"}' )
	else
		echo "NaN"
	fi
}

PRINT() {
	printf "%.*f" 2 $1
	printf "%*s\r" 4
}

QUIT() {
	tput cnorm
	exit
}

[ -z "$1" ] && printf "\tusage: %s <currency_code>\n\texample: %s USD\n" $0 $0 && exit;
trap QUIT INT
count=1
tput civis

while true; do
	[ $count -eq 1 ] \
		&& price=$(GET $1)
	if [ $count -lt 60 ]; then
		printf "%s " $1
		PRINT $price
		count=$((count+1))
	else
		count=1
	fi
	sleep 30
done
