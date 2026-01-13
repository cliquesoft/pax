#!/bin/sh
# tc-uninstall	the uninstallation script for pax in TinyCore Linux
#
# created	2026/01/13 by Dave Henderson (support@cliquesoft.org)
# updated	2026/01/13 by Dave Henderson (support@cliquesoft.org)


# define variables
DIR='/etc/sysconfig/tcedir'
ORG='onboot.lst'
ONE='bootup.lst'
TWO='option.lst'
TMP='temp.lst'

echo
echo 'UNINSTALLING'
echo
echo -n 'Building the package list:'

# first lets verify that all the packages in the original list are still desired
echo -n ' [original]'
for PACK in $(cat "${DIR}/${ORG}"); do
	# if the iterated package in the original list is in either the first or second stage pax list, then copy it to the new list
	( ( grep -q "$PACK" "${DIR}/${ONE}" ) || ( grep -q "$PACK" "${DIR}/${TWO}" ) ) && echo "$PACK" >>"${DIR}/${TMP}"
done

# next lets migrate any packages from the first stage list that isn't present
echo -n ' [first stage]'
for PACK in $(cat "${DIR}/${ONE}"); do
	# if the iterated package is NOT in the new list, then copy it
	( ! grep -q "$PACK" "${DIR}/${TMP}" ) && echo "$PACK" >>"${DIR}/${TMP}"
done

# finally lets migrate any packages from the second stage list that isn't present
echo -n ' [second stage]'
for PACK in $(cat "${DIR}/${TWO}"); do
	# if the iterated package is NOT in the new list, then copy it
	( ! grep -q "$PACK" "${DIR}/${TMP}" ) && echo "$PACK" >>"${DIR}/${TMP}"
done

echo -n ' [done]'
echo
echo "Your package manager has been returned to the default of the OS. We're"
echo "sad to see you go, but look forward to a potential future return! Feel"
echo "free to contact us about your experience using this product:"
echo "    service@cliquesoft.org"
echo

