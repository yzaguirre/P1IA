#!/bin/bash
echo Bad against *.bad_against.txt
echo Good against *.good_against.txt
echo Good with *.good_with.txt
# alternate path of unwrap2.5.sh (follows 2)
filename=champs.txt
while read -r nombre
do
	name_nosuff=/VMs/tmp/P1/web/campeones/$nombre
	# ${name_nosuff}.html > ${name_nosuff}.1.html
	# sed -e 's/[ \t]*$/")/' aatrox.bad_against.txt | sed 's/^/(ba "aatrox" "/' | sed ':a;N;$!ba;s/\n/ /g'
	# sed -e 's/[ \t]*$/")/' aatrox.good_against.txt | sed 's/^/(ga "aatrox" "/'
	# sed -e 's/[ \t]*$/")/' aatrox.good_with.txt | sed 's/^/(gw "aatrox" "/'
	
	sed -e 's/[ \t]*$/")/' ${name_nosuff}.bad_against.txt | sed "s/^/(ba \"${nombre}\" \"/" | sed ':a;N;$!ba;s/\n/ /g' > ${name_nosuff}.ba.txt
	sed -e 's/[ \t]*$/")/' ${name_nosuff}.good_against.txt | sed "s/^/(ga \"${nombre}\" \"/" | sed ':a;N;$!ba;s/\n/ /g' > ${name_nosuff}.ga.txt
	sed -e 's/[ \t]*$/")/' ${name_nosuff}.good_with.txt | sed "s/^/(gw \"${nombre}\" \"/" | sed ':a;N;$!ba;s/\n/ /g' > ${name_nosuff}.gw.txt
	rm ${name_nosuff}.{bad_against,good_against,good_with}.txt
done < "$filename"