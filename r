#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m' # No Color

if [ -z "$TOP" ]; then
	echo "Please set TOP"
	exit 1
fi

if [[ "$1" == "r-add" ]]; then
	folder=$(pwd)
	folder=${folder#$TOP}
	echo "Saving $folder"
	echo $folder >> $TOP/r-helper
	exit 0
fi

while read FOLDER
do
	printf "${GREEN}$FOLDER ${NC}\n"

	cd $TOP/$FOLDER
	git $@

	echo ""
done < "$TOP/r-helper"
