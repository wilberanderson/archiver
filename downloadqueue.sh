#!/bin/sh

echo "Reading queue:"
cat queue.txt | while read id
do
	echo " Downloading $id"
	# download using configuration file:
	youtube-dl --config-location ~/Documents/Media/Archive/archiver/youtube-dl.conf "$id"
	# add to master list, if downloaded:
	if [ $? -eq 0 ]
	then
		echo "$id" >> master.txt 
	else
		echo "  Failed to download."
		sleep .25
	fi
done

cat queue.txt > tmp.txt

echo "Removing downloaded files:"
cat queue.txt | while read line
do
	if grep -Fxq "$line" master.txt
	then
		echo " $line has been downloaded"
		gawk -i inplace "!/$line/" tmp.txt
	fi
done

cat tmp.txt > queue.txt

echo "Cleaning up:"
rm tmp.txt