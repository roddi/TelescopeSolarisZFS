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

    echo "# will log ${subdir}" >>  ${outputFile}
    hg log ${subdir} --template ${template} >> ${outputFile}
}	


##############################################################################
#
#   MAIN
#
#

HGSOURCEROOT="/Volumes/SolarisSource/onnv-gate/usr"
TEMPLATE="{rev}:::{node}:::{desc|firstline}\n" 
OUTPUTFILE="log.txt"

echo "# revisions" > $OUTPUTFILE

logRevisionsOfDir "$HGSOURCEROOT/src/uts/common/fs/zfs/" $TEMPLATE $OUTPUTFILE
logRevisionsOfDir "$HGSOURCEROOT/src/common/zfs/" $TEMPLATE $OUTPUTFILE
logRevisionsOfDir "$HGSOURCEROOT/src/uts/common/sys/fs/zfs.h" $TEMPLATE $OUTPUTFILE
logRevisionsOfDir "$HGSOURCEROOT/src/uts/common/sys/fm/fs/zfs.h" $TEMPLATE $OUTPUTFILE
logRevisionsOfDir "$HGSOURCEROOT/src/lib/libzfs/common/" $TEMPLATE $OUTPUTFILE
logRevisionsOfDir "$HGSOURCEROOT/src/cmd/zfs/" $TEMPLATE $OUTPUTFILE
logRevisionsOfDir "$HGSOURCEROOT/src/cmd/zpool/" $TEMPLATE $OUTPUTFILE

# this is -sort of- part of zfs (but will lead to many non-important changes)
#logRevisionsOfDir "$HGSOURCEROOT/src/uts/common/sys/" $TEMPLATE $OUTPUTFILE
