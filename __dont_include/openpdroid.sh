#!/bin/bash
cd ..

# Let's make it more universal (also benefit temasek's users) because I'm not using updater-script anyway
cp META-INF/com/google/android/updater-script updater-script-archi
cp __dont_include/_updater-scripts/temasek/updater-script META-INF/com/google/android/updater-script
zip -0 -r rom.zip system META-INF
cp updater-script-archi META-INF/com/google/android/updater-script
rm -f updater-script-archi
# That was easy, eh? ;)

# Cleanup, updates and patching
cd /root/git/auto-patcher
rm -rf tmp* adpatch*
rm -f log*.txt *.zip
rm -f *.tgz
mv ../../shared/git/ArchiDroid/rom.zip rom.zip
git pull origin 3.1
./batch.sh
./auto_patcher rom.zip openpdroid cm

# Not a good way to check that but we can have maximum of 1 file so it's acceptable
if [ ! `ls | grep "update-openpdroid" | wc -l` -eq 1 ]; then
	echo "Patch Failed"
	rm -rf tmp* adpatch*
	rm -f *.tgz
	rm -f log*.txt *.zip
	sleep 30
	exit 1
fi

# Let's keep flashable zips for temasek's users
rm -f ../../shared/git/ArchiDroid/__dont_include/temasek-openpdroid/*.zip
cp update-openpdroid*.zip restore-from-openpdroid*.zip ../../shared/git/ArchiDroid/__dont_include/temasek-openpdroid/

# And let's finally patch ArchiDroid
unzip update-openpdroid*.zip -d adpatch
rm -rf ../../shared/git/ArchiDroid/_archidroid/tweaks/openpdroid/system
cp -R adpatch/system ../../shared/git/ArchiDroid/_archidroid/tweaks/openpdroid

# Cleanup
rm -rf tmp* adpatch*
rm -f log*.txt *.zip
rm -f *.tgz
exit 0