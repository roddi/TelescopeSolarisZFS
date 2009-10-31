#!/bin/bash

DMGPATH="OpenSolaris"
VOLNAME="SolarisSource"

SRC=ssh://anon@hg.opensolaris.org/hg/onnv/onnv-gate

if [ $# -gt 0 ]
then
    SRC=$1
fi

echo "creating dmg..."
hdiutil create -size 10g "$DMGPATH" -type SPARSEBUNDLE -fs HFSX -volname "$VOLNAME"

echo "attaching dmg..."
hdiutil attach "$DMGPATH.sparsebundle"

(
    cd "/Volumes/$VOLNAME"

    echo "checking out Solaris from $SRC"
    hg clone $SRC
)

echo "detaching dmg..."
hdiutil detach "/Volumes/$VOLNAME"
