#!/system/bin/sh
# buildfpath.sh for make folder fpath in system and adding example functions.

# version 1.0

SCRIPTNAME=$(basename $0)
if [[ "$(id | sed 's/(/ /g' | sed 's/ /\n/g' | grep uid | sed 's/uid=//g')" != 0 ]];
then echo "${SCRIPTNAME} : Permission denied, are you root?\n"; return 1; fi

echo "build... Fpath folder";
mount -o rw,remount -t yaffs2 /dev/block/mtdblock4 /system
mkdir -p /system/etc/fpath 2>/dev/null;
chmod 0777 /system/etc/fpath 2>/dev/null;
sleep 2
echo "...done"
sleep 3

echo "adding minimal functions for fpath"
echo "adding al..."
sleep 1


NEARME2=$(dirname $0)
test -f ${NEARME2}/'al.f'
if [ $? -eq 0 ]; then
 cp -f ${NEARME2}/'al.f' /system/etc/fpath/al.f
 chmod 755 /system/etc/fpath/al.f
 sleep 1
  echo "...done"
exit 0
else
  echo "al.f not found in ${NEARME2}"
exit 1
fi
sleep 2
mount -o ro,remount -t yaffs2 /dev/block/mtdblock4 /system
