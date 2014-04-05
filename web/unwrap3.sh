#!/bin/bash
# https://stackoverflow.com/questions/14256917/bash-select-all-code-between-a-multiline-div
echo Bad against *.ba.txt
echo Good against *.ga.txt
echo Good with *.gw.txt
filename=champs.txt
x=0
while read -r nombre
do
	name_nosuff=/home/david/tmp/campeones/$nombre
	x=$(($x + 13))
	
	while read ba && read -u 3 ga && read -u 4 gw; do
		# sed 's/^  )$/  \t(good_against ${ga})\n  \t(good_against ${ga})\n  \t(good_against ${ga})\n  )/' ../src/hechos.clp
		# sed 's/^  )$/  \t(bad_against ${ba})\n  )/' ../src/hechos.clp
		# sed 's/^  )$/  \t(good_with ${gw})\n  )/' ../src/hechos.clp
		# sed 's/^  )$/  \t(good_against ${ga})\n  )/' ../src/hechos.clp | sed 's/^  )$/  \t(bad_against ${ba})\n  )/' | sed 's/^  )$/  \t(good_with ${gw})\n  )/' > ../src/hechos2.clp
		# sed -i "s/^  )$/  \t(good_against $ga)\n  \t(bad_against $ba)\n  \t(good_with $gw)\n  )/" ../src/hechos.clp
		sed -i "${x}s/.*$/  \t(good_against $ga)\n  \t(bad_against $ba)\n  \t(good_with $gw)\n  )/" ../src/hechos2.clp
		x=$(($x + 3))
	done < ${name_nosuff}.ba.txt 3< ${name_nosuff}.ga.txt 4< ${name_nosuff}.gw.txt
done < "$filename"