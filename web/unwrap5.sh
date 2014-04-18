#!/bin/bash
echo Bad against *.ba.txt
echo Good against *.ga.txt
echo Good with *.gw.txt
filename=champs.txt
# alternate path from unwrap 3 (follows 3.5)
source=`cat more_facts.clp`
while read -r nombre && read -u 3 rnombre
do
	source=`sed -e "s/\"$nombre\"/\"$rnombre\"/g" <<< $source`
done < "$filename" 3< champs2.txt
sed -e "s/) (/)\n(/g" <<< $source > prioridad_facts.clp