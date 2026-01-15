#!/bin/sh
# tc-uninstall	the uninstallation script for pax in TinyCore Linux
#
# created	2026/01/13 by Dave Henderson (support@cliquesoft.org)
# updated	2026/01/15 by Dave Henderson (support@cliquesoft.org)


# read in a global config file
[ -e "/etc/pax/config" ] && . "/etc/pax/config"

# define variables
DIR='/etc/sysconfig/tcedir'
ORG='onboot.lst.pax'
ONE='bootup.lst'
TWO='option.lst'
TMP='temp.lst'

echo
echo 'UNINSTALLING'
echo
echo -n 'Cleaning up the catalog directory:'
rm -f "${DIR_LIST}/"*.${EXT_CORE} 2>/dev/null
rm -f "${DIR_LIST}/"*.${EXT_DEPS} 2>/dev/null
rm -f "${DIR_LIST}/"*.${EXT_HASH} 2>/dev/null
rm -f "${DIR_LIST}/"*.${EXT_INFO} 2>/dev/null
echo ' [done]'
echo -n 'Building the package list:'

# first lets verify that all the packages in the original list are still in the dual-stage lists
echo -n ' [original]'
for PACK in $(cat "${DIR}/${ORG}" 2>/dev/null); do
	# if the iterated package in the original list is in either the first or second stage pax list, then copy it to the new list
	( ( grep -q "$PACK" "${DIR}/${ONE}" 2>/dev/null ) || ( grep -q "$PACK" "${DIR}/${TWO}" 2>/dev/null ) ) && echo "$PACK" >>"${DIR}/${TMP}"
done

# next lets migrate any packages from the first stage list that isn't present
echo -n ' [first stage]'
for PACK in $(cat "${DIR}/${ONE}" 2>/dev/null); do
	# if the iterated package is NOT in the new list, then copy it
	( ! grep -q "$PACK" "${DIR}/${TMP}" ) && echo "$PACK" >>"${DIR}/${TMP}"
done

# finally lets migrate any packages from the second stage list that isn't present
echo -n ' [second stage]'
for PACK in $(cat "${DIR}/${TWO}" 2>/dev/null); do
	# if the iterated package is NOT in the new list, then copy it
	( ! grep -q "$PACK" "${DIR}/${TMP}" ) && echo "$PACK" >>"${DIR}/${TMP}"
done

echo ' [done]'
echo
echo "Your package manager has been returned to the default of the OS. We're"
echo "sad to see you go, but look forward to a potential future return! Feel"
echo "free to contact us about your experience using this product:"
echo "    service@cliquesoft.org"
echo

