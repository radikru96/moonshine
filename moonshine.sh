#!/bin/bash
myhelp="Moonshine calculator v1.0
Help page

-h	this page
-ev	total volume in ml
-ea	total strength in %
-bv	alcohol volume in ml
-ba	alcohol strenth in %

Default total strength is 40%
Minimum of arguments is 2

For example:
"$0" -ev 1000 -ba 80
"$0" -ev 1000 -bv 500
"$0" -bv 500 -ba 80"
argerr="Arguments error!"
manyargs="Too many arguments"
fewargs="Too few arguments"
endvol=0
isev=0
endalc=40
isea=0
begvol=0
isbv=0
begalc=0
isba=0
args=0

if [ -z "$1" ]
then
	echo "$myhelp"
	exit
fi
while [ -n "$1" ]
do
	if [[ "$1" = "-h" ]]
	then
		echo "$myhelp"
		exit
	elif [[ "$1" = "-ev" ]]
	then
		if [[ "$isev" = 0 && "$2" != "-ev" && "$2" != "-ea" && "$2" != "-bv" && "$2" != "-ba" && "$2" != "-h"  ]]
		then
			shift
			args=$(($args+1))
			endvol="$1"
			isev=1
		else
			echo "$argerr"
			exit
		fi
	elif [[ "$1" = "-ea" ]]
	then
		if [[ "$isea" = 0 && "$2" != "-ev" && "$2" != "-ea" && "$2" != "-bv" && "$2" != "-ba" && "$2" != "-h"  ]]
		then
			shift
			args=$(($args+1))
			endalc="$1"
			isea=1
		else
			echo "$argerr"
			exit
		fi
	elif [[ "$1" = "-bv" ]]
	then
		if [[ "$isbv" = 0 && "$2" != "-ev" && "$2" != "-ea" && "$2" != "-bv" && "$2" != "-ba" && "$2" != "-h"  ]]
		then
			shift
			args=$(($args+1))
			begvol="$1"
			isbv=1
		else
			echo "$argerr"
			exit
		fi
	elif [[ "$1" = "-ba" ]]
	then
		if [[ "$isba" = 0 && "$2" != "-ev" && "$2" != "-ea" && "$2" != "-bv" && "$2" != "-ba" && "$2" != "-h"  ]]
		then
			shift
			args=$(($args+1))
			begalc="$1"
			isba=1
		else
			echo "$argerr"
			exit
		fi
	fi
	shift
done

if [[ "$args" > 3 ]]
then
	echo "$manyargs"
	exit
elif [[ "$args" < 2 || "$args" = 2 && "$isea" = 1 ]]
then
	echo "$fewargs"
	exit
elif [[ "$args" = 2 && "$isea" = 0 ]]
then
	isea=1
fi
if [[ "$isea" = 0 ]]
then
	water=$( bc <<< " "$endvol" - "$begvol" " )
	endalc=$( bc <<< " "$begvol" * "$begalc" / "$endvol" " ) 
elif [[ "$isba" = 0 ]]
then
	water=$( bc <<< " "$endvol" - "$begvol" " )
	begalc=$( bc <<< " "$endvol" * "$endalc" / "$begvol" " )
elif [[ "$isbv" = 0 ]]
then
	begvol=$( bc <<< " "$endvol" * "$endalc" / "$begalc" " )
	water=$( bc <<< " "$endvol" - "$begvol" " )
elif [[ "$isev" = 0 ]]
then
	endvol=$( bc <<< " "$begvol" * "$begalc" / "$endalc" " )
	water=$( bc <<< " "$endvol" - "$begvol" " )
fi

echo "end volume	$endvol
end alcohol	$endalc
begin volume	$begvol
begin alcohol	$begalc
water		$water"
