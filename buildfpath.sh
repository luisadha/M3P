#!/system/bin/sh
# buildfpath.sh for make folder fpath in system and adding example functions.

# version 1.1
# version 1.2


SCRIPTNAME=$(basename $0)
NEARME2=$(dirname $0)

if [[ "$(id | sed 's/(/ /g' | sed 's/ /\n/g' | grep uid | sed 's/uid=//g')" != 0 ]];
then echo "${SCRIPTNAME} : Permission denied, are you root?\n"; return 1; fi


. $NEARME2/'setups.sh'

printf "Build... Fpath folder.";
_mount
mkdir -p /system/etc/fpath 2>/dev/null;
chmod 0777 /system/etc/fpath 2>/dev/null;
sleep 2
echo "..done"
echo ' '
sleep 3

echo "adding minimal functions for fpath"
printf "adding al."
sleep 1




test -f ${NEARME2}/'al.f'
if [ $? -eq 0 ]; then
 cp -f ${NEARME2}/'al.f' /system/etc/fpath/al.f
 chmod 755 /system/etc/fpath/al.f
 sleep 1
  echo "..done"
echo ' '
exit 0
else
  echo "al.f not found in ${NEARME2}"
exit 1
fi
sleep 2
