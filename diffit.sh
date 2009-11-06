#/bin/bash

(
    cd ../parselog/zfs-converted-git/
    git log --since=2007-06-24 --until=2007-10-31 --pretty=format:%H > /tmp/log.txt
)

xcodebuild -configuration Release clean
xcodebuild -configuration Release build

build/Release/parselog /tmp/log.txt > "$HGSOURCEROOT/transmogrify.sh"
