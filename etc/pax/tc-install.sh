#!/bin/sh
# tc-install	the installation script for pax in TinyCore Linux
#
# created	2026/01/13 by Dave Henderson (support@cliquesoft.org)
# updated	2026/01/16 by Dave Henderson (support@cliquesoft.org)


# Usage syntax: getBootcode CODE
# Overview:	stores the value of a passed boot code in $VALUE, or blank otherwise
# Parameters:
# CODE		[string] the name of the boot code to return its value
getBootcode() {
	cat /proc/cmdline | grep -oE "${1}=[^ ]*" | sed 's/.*=//'
	return 0
}


# read in a global config file
[ -e "/etc/pax/config" ] && . "/etc/pax/config"

# obtain list values
eval LIST_BOOT="$LIST_BOOT"
eval LIST_LIVE="$LIST_LIVE"

# define variables
LIST_ORGL='onboot.lst'

echo
echo 'INSTALLING'

# if a package list exists -AND- it IS only 'pax', then this is already the default
if [ -e "${REPO_PREFIX}/${LIST_ORGL}" ] && [ "$(cat "${REPO_PREFIX}/${LIST_ORGL}")" = 'pax' ]; then
	echo
	echo "Pax appears to already be installed as the default package manager."
	echo
	exit
fi

# if a package list exists, move it to the new name
if [ -e "${REPO_PREFIX}/${LIST_ORGL}" ]; then
	echo
	echo "Pax can utilize two-stage package loading during bootup to reduce the"
	echo "time it takes to get into the OS. While this does increase the speed,"
	echo "it does prevent the ability to use optional software until the second"
	echo "stage has completed. Movement of a package from one list to the other"
	echo "allows users the flexibility to fine tune this process."
	echo
	echo "By default all kernel drivers are placed into the first stage list to"
	echo "ensure they are available for software loaded during the second stage"
	echo "of booting. Other important packages should be loaded first, with the"
	echo "less critical applications (such as your email or office suite) being"
	echo "processed last."
	echo
	echo "Unless a lot of additional software is being added to the device, the"
	echo "typical user should enable this feature. Likewise, advanced users and"
	echo "administrators should also take advantage of this option unless there"
	echo "is a specific need not to. Refer to the man pages for more info."
	echo
	echo -n "Do you want to implement dual stage loading? [Y/N] (N): "
	read

	# make a backup of the current list
	[ -e "${REPO_PREFIX}/${LIST_ORGL}.pax" ] && {
		# the default answer is to make sure we have the latest version of onboot.lst
		echo -n "An existing backup of the onboot.lst exists, overwrite? [Y/N] (Y): "
		read
		[ "$REPLY" != 'N' ] && [ "$REPLY" != 'n' ] && rm -f "${REPO_PREFIX}/${LIST_ORGL}.pax"
	}
	[ ! -e "${REPO_PREFIX}/${LIST_ORGL}.pax" ] && cp "${REPO_PREFIX}/${LIST_ORGL}" "${REPO_PREFIX}/${LIST_ORGL}.pax"

	if ( [ "$REPLY" = 'Y' ] || [ "$REPLY" = 'y' ] ); then
		# migrate kernel drivers to the first stage list
		( grep -q '\-tinycore' "${REPO_PREFIX}/${LIST_ORGL}" ) && grep '\-tinycore' "${REPO_PREFIX}/${LIST_ORGL}" >"${REPO_PREFIX}/${LIST_BOOT}" 2>/dev/null
		( grep -q '\-piCore' "${REPO_PREFIX}/${LIST_ORGL}" ) && grep '\-piCore' "${REPO_PREFIX}/${LIST_ORGL}" >"${REPO_PREFIX}/${LIST_BOOT}" 2>/dev/null
		# if nothing was copied over, create a blank list so pax will still operate dual stages
		[ ! -e "${REPO_PREFIX}/${LIST_BOOT}" ] && touch "${REPO_PREFIX}/${LIST_BOOT}"

		# move the current list to the second stage list (less any drivers)
		( grep -q '\-tinycore' "${REPO_PREFIX}/${LIST_ORGL}" ) && grep -vE '(\-tinycore|pax.tcz)' "${REPO_PREFIX}/${LIST_ORGL}" >"${REPO_PREFIX}/${LIST_LIVE}" 2>/dev/null
		( grep -q '\-piCore' "${REPO_PREFIX}/${LIST_ORGL}" ) && grep -vE '(\-piCore|pax.tcz)' "${REPO_PREFIX}/${LIST_ORGL}" >"${REPO_PREFIX}/${LIST_LIVE}" 2>/dev/null
	else
		# move the entire list to second stage loading (which will be processed as a stage one)
		# NOTE: we use LIST_LIVE here since pax will install to it by default in a live environment
		mv "${REPO_PREFIX}/${LIST_ORGL}" "${REPO_PREFIX}/${LIST_LIVE}"
	fi	
fi

# if no package list exists (or has been processed above), then put pax as its only value
echo 'pax.tcz' >"${REPO_PREFIX}/${LIST_ORGL}"

# make sure that pax is copied and not symlinked
echo 'pax.tcz' >"${REPO_PREFIX}/copy2fs.lst"

# update the package catalog to work with pax
echo
echo "Updating the installed software cache..."
pax -z

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

