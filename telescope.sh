#!/bin/sh

hg convert --filemap convert-file-map onnv-gate zfs-converted-hg

mkdir zfs-converted-git
cd zfs-converted-git
git init
../fast-export/hg-fast-export.sh -r ../zfs-converted-hg
git reset --hard
git gc

rm -rf zfs-converted-hg
