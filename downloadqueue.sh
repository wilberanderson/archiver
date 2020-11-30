#!/bin/sh

echo "Reading queue:"
cat queue.txt | while read id
do
	echo " Downloading $id"
	# download using configuration file:
	youtube-dl --config-location ~/Documents/Media/Archive/archiver/youtube-dl.conf "$id"
	# add to master list:
	echo "$id" >> master.txt
done