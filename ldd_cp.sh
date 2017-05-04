#!/bin/bash

if [ $# != 2 ] ; then
	echo "Usage: $0 PATH_TO_BINARY TARGET_FOLDER"
	exit 1
fi

PATH_TO_BINARY="$1"
TARGET_FOLDER="$2"

if [ ! -f "$PATH_TO_BINARY" ] ; then
	echo "The file '$PATH_TO_BINARY' was not found. Aborting!"
	exit 1
fi

if [ ! -d "$TARGET_FOLDER" ] ; then
	echo "No such directory '$TARGET_FOLDER'. Aborting!"
	exit 1
fi


copy_link_and_file ()
{
	local file=$1
	local dir=$2
	cp -dv --parents "$file" "$dir"

	local link="$file"
	while [ -h "$link" ] ; do
		link=`readlink -f $link`
		cp -dv --parents "$link" "$dir";
	done
}

echo "---> copy binary itself"
copy_link_and_file "$PATH_TO_BINARY" "$TARGET_FOLDER"

echo "---> copy libraries"
for lib in `ldd "$PATH_TO_BINARY" | cut -d'>' -f2 | awk '{print $1}'` ; do
	if [[ $lib =~ .*lib.* ]] ; then
		copy_link_and_file "$lib" "$TARGET_FOLDER"
	fi
done
