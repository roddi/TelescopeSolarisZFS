#/bin/bash

(
    cd zfs-converted-git/
    git checkout master
    #git log --since=2007-06-24 --until=2007-10-31 --pretty=oneline --date-order --reverse  > /tmp/log.txt
    git log --since=2007-08-09 --until=2007-09-17 --pretty=oneline --date-order --reverse  > /tmp/log.txt
)

xcodebuild -configuration Release clean
xcodebuild -configuration Release build | egrep 'warning:|error:|==='

(
    cd zfs-converted-git/

    DIFFCOUNTSCRIPT="diffcount.sh"
    
    ../build/Release/parselog -d /tmp/log.txt > $DIFFCOUNTSCRIPT
    
    chmod u+x $DIFFCOUNTSCRIPT
    
    ./$DIFFCOUNTSCRIPT
    
    ../build/Release/parselog -a /tmp/log.txt > analysis.csv   
)

