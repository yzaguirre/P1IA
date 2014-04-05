#!/bin/bash
echo Gonna download all data from LOL
# https://stackoverflow.com/questions/10929453/bash-scripting-read-file-line-by-line
#filename="$1"
filename=campeones.txt
mkdir campeones
mv $filename campeones
cd campeones
while read -r line
do
    wget $line --adjust-extension
done < "$filename"
rm $filename
cd -
tar cfz campeones.tar.gz campeones
rm -rf campeones get-campeones.sh
sudo mv campeones.tar.gz /var/www