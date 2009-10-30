#!/bin/bash

DMGPATH="OpenSolaris"
VOLNAME="SolarisSource"

echo "creating dmg..."
hdiutil create -size 10g "$DMGPATH" -type SPARSEBUNDLE -fs HFSX -volname "$VOLNAME"

echo "attaching dmg..."
hdiutil attach "$DMGPATH.sparsebundle"

(
    cd "/Volumes/$VOLNAME"
    
    echo "checking out Solaris hg repo"
    hg clone ssh://anon@hg.opensolaris.org/hg/onnv/onnv-gate
)

echo "detaching dmg..."
hdiutil detach "/Volumes/$VOLNAME"

