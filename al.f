# al autoload like motd on termux!
# al is minimal functions for /etc/fpath/, written by @adharudin14 and inspired name 'al' aliases by @7175 XDA
# version 1.1 #12/04/22
#- feature "pasting snippet code by quickly"



function al() {
local my_terminal="$(ps | grep 'term' | awk '{print $9}' )"
ENV="${ENV:-"/system/etc/mkshrc" }"
test $ENV;
if [ $? -eq 0 ]; then

echo "
Welcome to:
${my_terminal:-"Unknown Terminal!"}
$(printf %"$COLUMNS"s |tr " " "-")
| os >> $(uname -so)
| env >> ${ENV}
| arch >> $(uname -m)
| date >> $(date)
| shell >> ${SHELL:-$0}
| kernel >> $(uname -r)
| uptime >> $(busybox uptime -s)
| battery >> $(toybox acpi -b | awk '/Battery / { print $3 }'  )
| packages >> $(ls /system/bin | wc -l) / $(ls /system/bin/.ext | wc -l) (in bin & .ext)
$(printf %"$COLUMNS"s |tr " " "-") ";
fi

printf "$(whence -v al), version 1.1 \n, anywhy you can paste yours snippet in this row"
return 0
: place customisations above this line

}
al

