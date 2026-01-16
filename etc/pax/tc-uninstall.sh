#!/bin/sh
# tc-uninstall	the uninstallation script for pax in TinyCore Linux
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
LIST_TEMP='temp.lst'

echo
echo 'UNINSTALLING' | tee -a "$LOG_ERRS"
echo

echo -n 'Building the package list:' | tee -a "$LOG_ERRS"
# first lets verify that all the packages in the original list are still in the dual-stage lists
echo -n ' [original]' | tee -a "$LOG_ERRS"
for PACK in $(cat "${REPO_PREFIX}/${LIST_ORGL}.pax" 2>/dev/null); do
	# if the iterated package in the original list is in either the first or second stage pax list, then copy it to the new list
	( ( grep -q "$PACK" "${REPO_PREFIX}/${LIST_BOOT}" 2>/dev/null ) || ( grep -q "$PACK" "${REPO_PREFIX}/${LIST_LIVE}" 2>/dev/null ) ) && echo "$PACK" >>"${REPO_PREFIX}/${LIST_TEMP}"
done

# next lets migrate any packages from the first stage list that isn't present
echo -n ' [stage1]' | tee -a "$LOG_ERRS"
for PACK in $(cat "${REPO_PREFIX}/${LIST_BOOT}" 2>/dev/null); do
	# if the iterated package is NOT in the new list, then copy it
	( ! grep -q "$PACK" "${REPO_PREFIX}/${LIST_TEMP}" ) && echo "$PACK" >>"${REPO_PREFIX}/${LIST_TEMP}"
done

# finally lets migrate any packages from the second stage list that isn't present
echo -n ' [stage2]' | tee -a "$LOG_ERRS"
for PACK in $(cat "${REPO_PREFIX}/${LIST_LIVE}" 2>/dev/null); do
	# if the iterated package is NOT in the new list, then copy it
	( ! grep -q "$PACK" "${REPO_PREFIX}/${LIST_TEMP}" ) && echo "$PACK" >>"${REPO_PREFIX}/${LIST_TEMP}"
done

# make the temp list the actual list now
echo -n ' [implementing]' | tee -a "$LOG_ERRS"
mv -f "${REPO_PREFIX}/${LIST_TEMP}" "${REPO_PREFIX}/${LIST_ORGL}" 2>>"$LOG_ERRS" 2>&1
echo ' [done]' | tee -a "$LOG_ERRS"

# NOTE: this step can't be done because it is in use while uninstalling itself
#echo -n 'Uninstalling the package manager :' | tee -a "$LOG_ERRS"
#pax -D none -F -Q none -u delete pax
#echo ' [done]' | tee -a "$LOG_ERRS"

echo -n 'Cleaning up the storage directory:' | tee -a "$LOG_ERRS"
[ -e "${REPO_PREFIX}/${LIST_BOOT}" ] && rm -f "${REPO_PREFIX}/${LIST_BOOT}"
[ -e "${REPO_PREFIX}/${LIST_LIVE}" ] && rm -f "${REPO_PREFIX}/${LIST_LIVE}"
[ -e "${REPO_PREFIX}/${LIST_ORGL}.pax" ] && rm -f "${REPO_PREFIX}/${LIST_ORGL}.pax"
if [ "$(cat "${REPO_PREFIX}/copy2fs.lst")" = 'pax.tcz' ]; then	# if pax is the only package in the file, then...
	rm -f "${REPO_PREFIX}/copy2fs.lst"			#    delete the entire file
else								# otherwise just remove pax from the file
	grep -v 'pax.tcz' "${REPO_PREFIX}/copy2fs.lst" >"${REPO_PREFIX}/copy2fs.lst" 2>/dev/null
fi
echo ' [done]' | tee -a "$LOG_ERRS"

echo -n 'Cleaning up the catalog directory:' | tee -a "$LOG_ERRS"
rm -f "${DIR_LIST}/"*.${EXT_CORE} 2>/dev/null
rm -f "${DIR_LIST}/"*.${EXT_DEPS} 2>/dev/null
rm -f "${DIR_LIST}/"*.${EXT_HASH} 2>/dev/null
rm -f "${DIR_LIST}/"*.${EXT_INFO} 2>/dev/null
echo ' [done]' | tee -a "$LOG_ERRS"

echo
echo "Your package manager has been returned to the default of the OS. We're"
echo "sad to see you go, but look forward to a potential future return! Feel"
echo "free to contact us about your experience using this product:"
echo "    service@cliquesoft.org"
echo

