#!/bin/bash

#	 walksplash - Set Unsplash images as KDE Plasma 5 wallpapers with colorscheme support
#	 Copyright (C) 2019 Guglya Gleb <gleb.gugl@gmail.com>
#
#	 This program is free software: you can redistribute it and/or modify
#	 it under the terms of the GNU General Public License as published by
#	 the Free Software Foundation, either version 3 of the License, or
#	 (at your option) any later version.
#
#	 This program is distributed in the hope that it will be useful,
#	 but WITHOUT ANY WARRANTY; without even the implied warranty of
#	 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	 GNU General Public License for more details.
#
#	 You should have received a copy of the GNU General Public License
#	 along with this program. If not, see <http://www.gnu.org/licenses/>.

VERSION="0.1"

usage() {
	echo "Usage: `basename $0` [OPTIONS]

Options:
	* wallpaper type:
		-r, random
		-d, daily
		-w, weekly
		-f, featured
		-q,--search	 Get a photo from a search query
	* colorscheme options:
		-c,--colors	 Set colorscheme with wal
		-o, specify output file name
		-v, show version
		-h/-?, show this help message
Example:
	wallsplash --featured -cs"
}

version() {
	echo "`basename $0` v${VERSION}"
}


DIR="${HOME}/Pictures/Autowallpaper"

'''
getopt --test > /dev/null
if [[ $? -ne 4 ]]; then
	echo "I’m sorry, `getopt --test` failed in this environment."
	exit 1
fi
'''

while getopts "rdfo:cqvh?" opt; do
	case "$opt" in
	h|\?)
		usage
		exit 0
		;;
	r)
		OPT="-r"
		TYPE="random"
		;;
	f)
		OPT="-f"
		TYPE="featured"
		;;
	d)
		#TIME=${OPTARG}
		OPT="-d"
		TYPE="daily"
		;;
	o)
		FILENAME=${OPTARG}
		exit 0
		;;
	v)
		version
		exit 0
		;;
	c)
		SET_COMMAND="wal -i"
		;;
	q)
		SEARCH="$2"
		;;
	esac
done

if [ -z "${OPT}" -a -z "${SEARCH}" ]; then
	usage
	exit 1
fi

if [ -z "${SET_COMMAND}" ]; then
	SET_COMMAND="feh --bg-scale"
fi

# Create dir
if [ ! -d ${DIR} ]; then
	echo "Creating directory..."
	mkdir -p ${DIR}
fi

# Clear directory
echo "Cleaning directory content..."
rm ${DIR}/*

# Get wallpaper
echo "Getting ${TYPE} wallpaper..."
unsplash-wallpaper -d ${DIR} ${OPT} ${SEARCH+-q} "${SEARCH}" #&> /dev/null

# Set it
echo "Updating wallpaper..."
WP_PATH=`ls -t ${DIR}/wallpaper*`
sh ${HOME}/.scripts/walksplash/ksetwallpaper.sh ${WP_PATH}

echo "Enjoy!"
