#!/bin/bash
# https://stackoverflow.com/questions/14256917/bash-select-all-code-between-a-multiline-div
echo Bad against *.bad_against.txt
echo Good against *.good_against.txt
echo Good with *.good_with.txt
filename=champs.txt
while read -r nombre
do
	name_nosuff=/home/david/tmp/campeones/$nombre
	# ${name_nosuff}.html > ${name_nosuff}.1.html
	# sed -e 's/[ \t]*$//' aatrox.bad_against.txt | sed ':a;N;$!ba;s/\n/" "/g' | sed '1s/^/"/' | sed '$s/$/"/'
	# sed -e 's/[ \t]*$//' aatrox.good_against.txt | sed ':a;N;$!ba;s/\n/" "/g' | sed '1s/^/"/' | sed '$s/$/"/'
	# sed -e 's/[ \t]*$//' aatrox.good_with.txt | sed ':a;N;$!ba;s/\n/" "/g' | sed '1s/^/"/' | sed '$s/$/"/'

	sed -e 's/[ \t]*$//' ${name_nosuff}.bad_against.txt | sed ':a;N;$!ba;s/\n/" "/g' | sed '1s/^/"/' | sed '$s/$/"/' > ${name_nosuff}.ba.txt
	sed -e 's/[ \t]*$//' ${name_nosuff}.good_against.txt | sed ':a;N;$!ba;s/\n/" "/g' | sed '1s/^/"/' | sed '$s/$/"/' > ${name_nosuff}.ga.txt
	sed -e 's/[ \t]*$//' ${name_nosuff}.good_with.txt | sed ':a;N;$!ba;s/\n/" "/g' | sed '1s/^/"/' | sed '$s/$/"/' > ${name_nosuff}.gw.txt
	rm ${name_nosuff}.{bad_against,good_against,good_with}.txt
done < "$filename"