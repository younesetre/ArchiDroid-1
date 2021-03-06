#!/system/bin/sh

# Check if we're running as root
if [ `whoami 2>&1 | grep -i "root" | wc -l` -eq 0 ] && [ `whoami 2>&1 | grep -i "uid 0" | wc -l` -eq 0 ]; then
	echo "Sorry but you need to execute this script as root"
	exit 1
fi

ADDEV="/system/archidroid/dev"
sysrw

if [ -e $ADDEV/ADBLOCK_LOCAL_DNSES_ENABLED ]; then
	rm -f $ADDEV/ADBLOCK_LOCAL_DNSES_DAEMON_ENABLED
	touch $ADDEV/ADBLOCK_LOCAL_DNSES_DAEMON_DISABLED
	mv $ADDEV/ADBLOCK_LOCAL_DNSES_ENABLED $ADDEV/ADBLOCK_LOCAL_DNSES_DISABLED
	echo "Local DNSes are now ignored by Adblock"
elif [ -e $ADDEV/ADBLOCK_LOCAL_DNSES_DISABLED ]; then
	mv $ADDEV/ADBLOCK_LOCAL_DNSES_DISABLED $ADDEV/ADBLOCK_LOCAL_DNSES_ENABLED
	echo "Local DNSes are now being used by Adblock"
	echo "Keep in mind that they're not automatically updated, if you want them to be, don't forget to enable LocalDNSesDaemon as well"
else
	sysro
	echo "Could not find actual adblock DNSes status!"
	exit 1
fi

sysro
sh /system/etc/init.d/99ArchiDroid_Init "RELOAD" "ADBLOCK"
exit 0