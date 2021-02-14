#!/bin/bash

#for merging dir1 into dir2
maindir=$(pwd)
dir1="$1"
d1checkfilename="dir1.flatchecksum"
dir2="$2"
d2checkfilename="dir2.flatchecksum"

resultfile="result.txt"

create_flat_checksum () {

	local currentdir="$1"
	local checksumfile="$2" # input needs a leading ./

	touch "$checksumfile"
	echo "now checksumming $currentdir"


	local subdirs=$(find "$currentdir" -type d)
	#  echo "$subdirs"

	while read -r line; do
		echo "$line" 
		cd "$line"
		#run the checksum and redirect errors to stderr (ignoring them)
		local result=$(md5sum * 2> /dev/null)
		# append the results of this directories checksum to the main file
		echo "$result" >> "$maindir/$checksumfile"
		# cd back up to current dir for next iteration
		# echo "$maindir/${currentdir:2}"
		
		
		# pwd
		# echo "$maindir/${currentdir:2}"
		cd "$maindir"

	done <<< "$subdirs"
}

# create flat checksum files for both directories 
create_flat_checksum "$dir1" "$d1checkfilename"
create_flat_checksum "$dir2" "$d2checkfilename"


# cp "$d1checkfilename" "$resultfile"
# https://unix.stackexchange.com/questions/408644/remove-lines-in-file-1-from-file-2
# grep -Fxv -f "$resultfile" "$d2checkfilename"


comm -23 <(sort $d1checkfilename) <(sort $d2checkfilename) > "$resultfile"

# rm "$d1checkfilename"
# rm "$d2checkfilename"