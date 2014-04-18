#!/bin/bash
echo Bad against *.ba.txt
echo Good against *.ga.txt
echo Good with *.gw.txt
filename=champs.txt
# alternate path from unwrap 3 (follows 3.5)
while read -r nombre
do
	name_nosuff=/VMs/tmp/P1/web/campeones/$nombre
	while read ba && read -u 3 ga && read -u 4 gw; do
		echo ${ba}$'\n'${ga}$'\n'${gw} | sed "s/) (/)\n(/g" >> more_facts.clp
	done < ${name_nosuff}.ba.txt 3< ${name_nosuff}.ga.txt 4< ${name_nosuff}.gw.txt
done < "$filename"