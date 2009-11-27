#/bin/bash

(
    cd zfs-converted-git/
    git checkout master
    
    # onnv_61: 2007-03-18
    # onnv_62: 2007-04-03
    # onnv_63: 2007-04-14
    # onnv_64: 2007-04-25
    # onnv_65: 2007-05-14
    # onnv_66: 2007-05-29
    # onnv_67: 2007-06-09
    # onnv_68: 2007-06-24
    # onnv_69: 2007-07-10
    # onnv_70: 2007-07-24
    # onnv_71: 2007-08-07
    # original Apple branch: 2007-08-14
    # onnv_72: 2007-08-18
    # onnv_73: 2007-09-04
    # onnv_74: 2007-09-17
    # onnv_75: 2007-09-29
    # onnv_76: 2007-10-11
    # onnv_77: 2007-10-30
    # onnv_78: 2007-11-10
    # onnv_79: 2007-11-28
    
    git log --since=2007-08-14 --until=2007-10-11 --pretty=oneline --date-order --reverse  > /tmp/log.txt
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

