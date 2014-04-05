#!/bin/bash
# https://stackoverflow.com/questions/14256917/bash-select-all-code-between-a-multiline-div
echo Bad against DIV#counterpicks-list.picks-list
echo Good against DIV#goodagainst-list.picks-list
echo Good with DIV#duopicks-list.picks-list
filename=champs.txt
while read -r nombre
do
	name_nosuff=/home/david/tmp/campeones/$nombre
	# ${name_nosuff}.html > ${name_nosuff}.1.html
	# xidel aatrox.html -e 'css("#counterpicks-list.picks-list")'| sed 's/[ \t\n]*//' | sed '/^$/d' | tail -n +2 | head -n -1 | awk 'NR%7==1{print $0}' | less
	# xidel aatrox.html -e 'css("#goodagainst-list.picks-list")'| sed 's/[ \t\n]*//' | sed '/^$/d' | tail -n +2 | head -n -1 | awk 'NR%7==1{print $0}' | less
	# xidel aatrox.html -e 'css("#duopicks-list.picks-list")'| sed 's/[ \t\n]*//' | sed '/^$/d' | tail -n +2 | head -n -1 | awk 'NR%5==1{print $0}' | less
	xidel ${name_nosuff}.html -e 'css("#counterpicks-list.picks-list")' | sed 's/[ \t\n]*//' | sed '/^$/d' | tail -n +2 | head -n -1 | awk 'NR%7==1{print $0}' > ${name_nosuff}.bad_against.txt
	xidel ${name_nosuff}.html -e 'css("#goodagainst-list.picks-list")' | sed 's/[ \t\n]*//' | sed '/^$/d' | tail -n +2 | head -n -1 | awk 'NR%7==1{print $0}'   > ${name_nosuff}.good_against.txt
	xidel ${name_nosuff}.html -e 'css("#duopicks-list.picks-list")' | sed 's/[ \t\n]*//' | sed '/^$/d' | tail -n +2 | head -n -1 | awk 'NR%5==1{print $0}'  > ${name_nosuff}.good_with.txt
	rm ${name_nosuff}.html
done < "$filename"