#!/bin/bash
filename=champs.txt
i=0
mkdir ../t
while read -r line
do
	i=$(($i + 1))
    ls /home/david/tmp/campeones/$line.html 2> ../t/$line.err
done < "$filename"
echo $i