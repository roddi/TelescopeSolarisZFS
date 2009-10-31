#!/bin/bash

##############################################################################
#
# usage: logRevisionsOfDir $subdir $template $outputFile
#
#
logRevisionsOfDir()
{
	subdir=$1
	template=$2
	outputFile=$3

    echo "# will log ${subdir}"
    echo "# will log ${subdir}" >>  ${outputFile}
    hg log ${subdir} --template ${template} >> ${outputFile}
}


##############################################################################
#
#   MAIN
#
#

HGSOURCEROOT="/Volumes/SolarisSource/onnv-gate/"
echo "HGSOURCEROOT: $HGSOURCEROOT"
TEMPLATE="{rev}:::{node}:::{desc|firstline}\n"
OUTPUTPATH="/tmp/log.txt"
(
cd $HGSOURCEROOT

echo "# revisions" > $OUTPUTPATH

logRevisionsOfDir "usr/src/uts/common/fs/zfs/" $TEMPLATE $OUTPUTPATH
logRevisionsOfDir "usr/src/common/zfs/" $TEMPLATE $OUTPUTPATH
logRevisionsOfDir "usr/src/uts/common/sys/fs/zfs.h" $TEMPLATE $OUTPUTPATH
logRevisionsOfDir "usr/src/uts/common/sys/fm/fs/zfs.h" $TEMPLATE $OUTPUTPATH
logRevisionsOfDir "usr/src/lib/libzfs/common/" $TEMPLATE $OUTPUTPATH
logRevisionsOfDir "usr/src/cmd/zfs/" $TEMPLATE $OUTPUTPATH
logRevisionsOfDir "usr/src/cmd/zpool/" $TEMPLATE $OUTPUTPATH

# this is -sort of- part of zfs (but will lead to many non-important changes)
#logRevisionsOfDir "$HGSOURCEROOT/usr/src/uts/common/sys/" $TEMPLATE $OUTPUTPATH

)

# clean and build parselog
xcodebuild -configuration Release clean
xcodebuild -configuration Release build

# call parselog
build/Release/parselog /tmp/log.txt > "$HGSOURCEROOT/transmogrify.sh"

echo "transmogrify.sh" > "$HGSOURCEROOT/.gitignore"

# make executable
chmod u+x "$HGSOURCEROOT/transmogrify.sh"