#!/bin/bash
if [ $# -gt 2 ]
then
	echo -e "Either takes a bus stop number as an argument\nOR\nTakes a bus stop number AND a bus number as an argument" >&2
	exit 1
fi
mystop="$1"
bus="$2"
default="^[0-9]"
re='^[0-9]+$'
if ! [[ ${mystop} =~ $re ]] 
then
	echo "error: Not a number" >&2; exit 2 
fi
if [ -z "${bus}" ]
then
	:
elif [[ ${bus} =~ ${re} ]]
then
	default="${bus}"
else
        echo "error: Not a number" >&2; exit 3
fi
site="https://grtapp.ca/stop.asp?stop="
mystop="$1"
append1=${mystop}
site+=${append1}
tmpfile=$(mktemp /tmp/bus.XXXXXX)
tmp=$(mktemp /tmp/bustmp.XXXXXX)
#final=$(mktemp /tmp/busfinal.XXXXXX)
info=$(curl -s  ${site} | egrep "<table" | cat > ${tmpfile})
if (( $(cat ${tmpfile} | wc -l ) == 0 ))
then
	echo "error: Stop not found" >&2; exit 4
fi 
sed -e 's/<[^>]*>/\\\
/g' ${tmpfile} > ${tmp} 
egrep "^[0-9]" ${tmp} > ${tmpfile}
count=0
currentline=""
echo -e "Time \t Route"
while IFS= read -r line; do
	if (( ${count} % 2 == 0 ))
	then
  		currentline="${line//\\}"
		currentline+=" \t "
	else
		currentline+=${line//\\}
		if [ $# -eq 2 ] 
		then
			if (( $(egrep ":[0-9][0-9][^0-9]*${bus}[^0-9]" <<< ${currentline} | wc -l) > 0))
			then	
			echo -e "$currentline"
			fi
		else
			echo -e "$currentline"
		fi
	fi
	count=$((count+1))
done < "${tmpfile}"
rm "${tmpfile}"
rm "${tmp}"

