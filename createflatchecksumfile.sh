#!/bin/bash

currentdir=$(pwd)
checksumfile="flatchecksum.chk"

touch "$checksumfile"
# echo "$currentdir"

subdirs=$(find -type d)

#  echo "$subdirs"



while read -r line; do
    cd "${line:2}"
	#run the checksum and redirect errors to stderr (ignoring them)
	result=$(md5sum .* 2> /dev/null)

	# append the results of this directories checksum to the main file
	echo "$result" >> "$currentdir/$checksumfile"
	# cd back up to working dir for next iteration
	cd "$currentdir"

done <<< "$subdirs"