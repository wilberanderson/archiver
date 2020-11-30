#!/bin/sh

echo "Fetching history:"
cp --force `find ~/.mozilla/firefox/ -name "places.sqlite"|sort|head -1` ~/
echo "Getting video IDs:"
sqlite3 -batch ~/places.sqlite "SELECT url FROM moz_places, moz_historyvisits \
                       WHERE moz_places.id = moz_historyvisits.place_id and \
                       visit_date > strftime('%s','now','-9 day')*1000000 ORDER by \
                       visit_date;" | grep 'https\:\/\/www.youtube.com\/watch?v=' | \
                       sed 's/https\:\/\/www.youtube.com\/watch?v=//;s/&.*//' >> tmp.txt

echo "Updating queue:"
cat tmp.txt | while read line
do
	if grep -Fxq "$line" queue.txt
	then
		echo " $line already in queue"
	else
		echo " adding $line to queue"
		echo "$line" >> queue.txt
	fi
done

cat queue.txt > tmp.txt

echo "Paring duplicates from queue:"
cat queue.txt | while read line
do
	if grep -Fxq "$line" master.txt
	then
		echo " $line already local"
		gawk -i inplace "!/$line/" tmp.txt
	fi
done

cat tmp.txt > queue.txt

echo "Cleaning up:"
echo " Deleting files:"
rm ~/places.sqlite
rm tmp.txt