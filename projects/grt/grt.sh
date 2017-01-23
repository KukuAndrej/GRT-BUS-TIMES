#!/bin/bash
if [ $# -ne 1 ]
then
	echo "error: Only takes one bus stop number" >&2; exit 1
fi
mystop="$1"
re='^[0-9]+$'
if ! [[ ${mystop} =~ $re ]] 
then
	echo "error: Not a number" >&2; exit 2 
fi
site="https://grtapp.ca/stop.asp?stop="
mystop="$1"
append1=${mystop}
site+=${append1}
tmpfile=$(mktemp /tmp/bus.XXXXXX)
tmp=$(mktemp /tmp/bustmp.XXXXXX)
info=$(curl -s  ${site} | egrep "<table" | cat > ${tmpfile})
if (( $(cat ${tmpfile} | wc -l ) == 0 ))
then
	echo "error: Stop not found" >&2; exit 3
fi 
sed -e 's/<[^>]*>/\\\n/g' ${tmpfile} > ${tmp} 
egrep "^[^\\]" ${tmp} > ${tmpfile}
count=0
currentline=""
while IFS= read -r line; do
	if (( ${count} % 2 == 0 ))
	then
  		currentline="${line//\\}"
		currentline+=" \t "
	else
		currentline+=${line//\\}
		echo -e "$currentline"
	fi
	count=$((count+1))
done < "${tmpfile}"

rm "${tmpfile}"
rm "${tmp}"

