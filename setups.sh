#!/system/xbin/env sh
# This script is a shortcut for customization like Replacing and Patching the system mkshrc with additional mkshrc of your own code.
# feature
# - Mkshrc as alloy included
# - Build environment fpath
# fix issue #2110 " mount: not '/system' not in /proc/mounts"
# Copyright (c) 2021 adharudin14@gmail.com

DELAY=2
NEARME="`readlink -f $(pwd)`"
PROC_ARRAY=( "Checking" "Mounting system" "Creating" "Patching" );
SUCC_ARRAY=( "Done" "Fail" );
MISC_ARRAY=( "Try \`--help'" );
FAIL_ARRAY=( "${TARGET}: /sdcard/etc/mkshrc: no such file or directory" "mkshrc.bak Not Found" );
SCRIPTNAME=$(basename $0)

if [[ "$(id | sed 's/(/ /g' | sed 's/ /\n/g' | grep uid | sed 's/uid=//g')" != 0 ]];
then echo "${SCRIPTNAME} : Permission denied, are you root?\n"; return 1; fi
clear

##-Function
# Changes the title of the terminal window
function _set_title ()
{
    echo -en "\e]2;$@\007"
}

function _usage() {
echo "${SCRIPTNAME}: [OPTION]
Available options:
\t--patch , -p\t\tPatching and backup mkshrc in same location.
\t--delete-cache , -d\t\tDelete temp. folder in sdcard.
\t--restore , -r\t\tRestore old mkshrc, if available.
\t--overwrite , -o\t\tOveride and change mkshrc.
\t--help , -h\t\t Print this help messages.        ";
exit ${1:-1}
}

function _mount()
{
busybox mount -o rw,remount /
mount -o bind /system /system
}

function _patch()
{
printf "Checking the system's mkshrc maybe it can be patched."
sleep $DELAY
_mount
tail -n 1 /system/etc/mkshrc | grep -o ': place customisations above this line' >/dev/null 2>&1;
###### don't pasting anything code by this line
if [ $? -eq 0 ];
then echo "..Great!, Your system mkshrc already can patch\n"
else
echo "..Failed!"
exit 1
fi

printf "${PROC_ARRAY[0]} my position "
sleep $DELAY
echo "..${SUCC_ARRAY[0]}."
echo "$(pwd)\n"
sleep $DELAY
printf "${PROC_ARRAY[1]}."
_mount

sleep $DELAY
echo "..${SUCC_ARRAY[0]}.\n"
printf "${PROC_ARRAY[2]}... bak file for '/etc/mkshrc'"
MKSHRC="/system/etc/mkshrc";
TARGET="${MKSHRC}";
busybox cp ${MKSHRC} /system/etc/mkshrc.bak
sleep $DELAY
echo "..${SUCC_ARRAY[0]}."
echo ' '
printf "${PROC_ARRAY[3]}...'${MKSHRC}'";
BODY=$(busybox cat "${MKSHRC}")
ORIGINAL=": place customisations above this line"
PATCH=$(printf "if [ -f /sdcard/etc/mkshrc ]; then\n env ENV=\"/sdcard/etc/mkshrc\" sh\nelse\n  return 0\nfi\n${ORIGINAL}")
BODY=$(echo "${BODY/${PATCH}/${ORIGINAL}}")
BODY=$(echo "${BODY/${ORIGINAL}/${PATCH}}")
echo "${BODY}" > "${MKSHRC}"
busybox chmod 755 "${MKSHRC}"
sleep $DELAY
echo "..${SUCC_ARRAY[0]}.\n"
}

local options="$1"
if [ -z "$options" ]; then
NEARME2=$(dirname $0)
test -f /sdcard/etc/mkshrc;
  if [ $? -eq 0 ];
  then _patch;
  else test -f ${NEARME2}/'mkshrc' || test -f ${NEARME2}/'mkshrc'
   if [ $? -eq 0 ];
   then
   
   printf "prepare patch \n"
echo
sleep $DELAY

printf "create temp. folder \"etc\" ($NEARME2/sdcard) "
sleep $DELAY
mkdir -p /sdcard/etc; echo "...${SUCC_ARRAY[0]}\n"

  
printf "copying file to temp. folder (${NEARME2}/sdcard/etc) "
sleep $DELAY
cd ${NEARME2};
busybox cp -f mkshrc /sdcard/etc/mkshrc;
sleep $DELAY; echo "...${SUCC_ARRAY[0]}\n"
sleep $DELAY;

printf "Type \`r\' or type again name this script to proced patch mkshrc system. \n !!\nif this process any error try another options! \n !!\n";
sleep $DELAY;
exit 0;
      else echo "not found file named \"mkshrc\" within this script!"; 
exit 2; fi  fi
elif [ "$options" == "--help" ] || [ "$options" == "-h" ]; then _usage 0;
elif [ "$options" == "--delete-cache" ] || [ "$options" == "-d" ]; then
echo Deleting tmp folder...
rm -rf /sdcard/etc/'mkshrc'
rmdir /sdcard/etc
sleep 2
echo ..done

exit 0;
elif [ "$options" == "--patch" ] || [ "$options" == "-p" ]; then
echo "${NEARME2}/etc/mkshrc";
test -f ${NEARME2}/etc/mkshrc;
   if [ $? -eq 0 ];
   then _patch; #exit 0
   else echo "${SCRIPTNAME}${FAIL_ARRAY[0]}"; exit 1; fi
elif [ "$options" == "--overwrite" ] || [ "$options" == "-o" ]; then TARGET="/system/etc/mkshrc";
test -f /sdcard/etc/mkshrc;
    if [ $? -eq 0 ];
    then _mount

busybox cp -f /sdcard/etc/mkshrc $TARGET; busybox chmod 755 $TARGET; sleep $DELAY; echo "Mkshrc changed!"; exit 0;

    else echo "${SCRIPTNAME}${FAIL_ARRAY[0]}"; exit 1; fi
    elif [ "$options" == "--restore" ] || [ "$options" == "-r" ]; then _mount

cd /system/etc; mv /system/etc/mkshrc.bak /system/etc/mkshrc >/dev/null 2>&1;
     if [ $? -eq 0 ];
     then chmod 755 /system/etc/mkshrc; echo "Mkshrc restored!"; cd - >/dev/null 2>&1; exit 0;
     else echo "${FAIL_ARRAY[1]}"; exit 1; fi
else echo "${SCRIPTNAME}: option not recognized ${1} "; exit 1; fi
#eof
