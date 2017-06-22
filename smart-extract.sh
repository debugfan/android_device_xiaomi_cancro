#!/bin/bash
#
# Extract MIUI 7 and CyanogenMod 13 ROM, then run in order as follow with responding directory:
#
# source build/envsetup.sh
# cd device/xiaomi/cancro
# ./extract-files.sh /mnt/CM13
# ./smart-extract.sh /mnt/CM13
# ./smart-extract.sh /mnt/MIUI7
# ./smart-extract.sh astray
# croot
# breakfast cancro
#

indir="$1"
outdir="../../../vendor/xiaomi/cancro/proprietary"

echo "-------------------- find and copy files --------------------"

function smart_copy() {
    srcname=$1
    destname=$2
    postpath=`dirname system/$srcname`
    filename=`basename $srcname`
    fulldest=$outdir/$destname
    while [[ ! -f "$fulldest" ]]; do
        searchpath=$indir/$postpath
        if [[ -a "$searchpath" ]]; then
            echo "find \"$searchpath\" -name \"$filename\" -type f -exec cp {} \"$fulldest\" \\;"
            find "$searchpath" -name "$filename" -type f -exec cp {} "$fulldest" \;
        else
	    echo "path not exist: $searchpath"
        fi
        postpath=`dirname $postpath`
        if [[ $postpath = "." || $postpath = ".." ]]; then
           break
        fi
    done
}

while IFS='' read -r line || [[ -n "$line" ]]; do
   smart_copy $line $line
done < "proprietary-files.txt"

smart_copy "vendor/lib/libdrmdecrypt.so" "vendor/lib/libdrmdecrypt.2.so"
smart_copy "vendor/lib/libc2d30-a3xx.so" "vendor/lib/libc2d30.so"

echo "-------------------- check files --------------------"
while IFS='' read -r line || [[ -n "$line" ]]; do
    fulldest=$outdir/$line
    if [[ ! -f "$fulldest" ]]; then
        echo "file not found: $line"
    fi
done < "proprietary-files.txt"
