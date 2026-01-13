#!/bin/sh
# tc-install	the installation script for pax in TinyCore Linux
#
# created	2026/01/13 by Dave Henderson (support@cliquesoft.org)
# updated	2026/01/13 by Dave Henderson (support@cliquesoft.org)


# define variables
DIR='/etc/sysconfig/tcedir'
OLD='onboot.lst'
ONE='bootup.lst'
TWO='option.lst'

echo
echo 'INSTALLING'

# if a package list exists -AND- it's not only 'pax', move it to the new name
if [ -e "${DIR}/${OLD}" ] && [ "$(cat "${DIR}/${OLD}")" != 'pax' ]; then
	echo
	echo "Pax can utilize two-stage package loading during bootup to reduce the"
	echo "time it takes to get into the OS. While this does increase the speed,"
	echo "it does prevent the ability to use software until the second stage is"
	echo "finished (which depends on how much extra software you are installing"
	echo "of course). Which list a package is placed will designate which stage"
	echo "it will be processed, giving you flexibility to fine tune your device"
	echo "during its bootup."
	echo
	echo "The pax installation automatically moves kernel drivers into the list"
	echo "for first stage loading to ensure they are available for software. It"
	echo "is recommended to move any other necessary packages into this list so"
	echo "they will also be available beforehand.  By default the two lists are"
	echo "defined by the following names, but can be altered via the pax config"
	echo "file in /etc/pax."
	echo "   Stage 1 (LIST_BOOT): $ONE"
	echo "   Stage 2 (LIST_LIVE): $TWO"
	echo
	echo -n "Do you want to implement dual stage loading? [Y/N] (N): "
	read

	# make a backup of the current list
	[ -e "${DIR}/${OLD}.pax" ] && {
		# the default answer is to make sure we have the latest version of onboot.lst
		echo -n "An existing backup of the onboot.lst exists, overwrite? [Y/N] (Y): "
		read
		[ "$REPLY" != 'N' ] && [ "$REPLY" != 'n' ] ) && rm -f "${DIR}/${OLD}.pax"
	}
	[ ! -e "${DIR}/${OLD}.pax" ] && cp "${DIR}/${OLD}" "${DIR}/${OLD}.pax"

	if ( [ "$REPLY" = 'Y' ] || [ "$REPLY" = 'y' ] ); then
		# migrate kernel drivers to the first stage list
		( grep -q '\-tinycore' "${DIR}/${OLD}" ) && grep '\-tinycore' "${DIR}/${OLD}" >"${DIR}/${ONE}" 2>/dev/null
		( grep -q '\-piCore' "${DIR}/${OLD}" ) && grep '\-piCore' "${DIR}/${OLD}" >"${DIR}/${ONE}" 2>/dev/null

		# move the current list to the second stage list (less any drivers)
		( grep -q '\-tinycore' "${DIR}/${OLD}" ) && grep -v '\-tinycore' "${DIR}/${OLD}" >"${DIR}/${TWO}" 2>/dev/null
		( grep -q '\-piCore' "${DIR}/${OLD}" ) && grep -v '\-piCore' "${DIR}/${OLD}" >"${DIR}/${TWO}" 2>/dev/null
	else
		# move the entire list to first stage loading
		mv "${DIR}/${OLD}" "${DIR}/${ONE}"
	fi	
fi

# if no package list exists (or has been processed above), then put pax as its only value
( [ ! -e "${DIR}/${OLD}" ] ) && echo 'pax.tcz' >"${DIR}/${OLD}"

# inform the user of a successful installation
echo
echo "CONGRATS!"
echo
echo "Pax is now the default package manager for your OS!"
echo
echo "While the prior package manager is still present, do *NOT* use it! Any"
echo "usage of it will likely interfere with the operation of pax due to the"
echo "way booting and file placement differ between the two.  If you wish to"
echo "discontinue using pax, simply issue the following command to remove it"
echo "from being your default:    pax --uninstall"
echo
echo "We hope you enjoy our product and look forward to hearing any feedback"
echo "you may have.  Please report any bugs you happen to find.  If we don't"
echo "know they exist, we can't fix them. Email us at support@cliquesoft.org"
echo

