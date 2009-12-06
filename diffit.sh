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

    # onnv_80: 2007-12-11
    # onnv_81: 2008-01-08
    # onnv_82: 2008-01-23
    # onnv_83: 2008-02-01
    # onnv_84: 2008-02-19
    # onnv_85: 2008-03-03
    # onnv_86: 2008-03-12
    # onnv_87: 2008-03-28
    # onnv_88: 2008-04-15
    # onnv_89: 2008-04-28

    # onnv_90: 2008-05-12
    # onnv_91: 2008-05-28
    # onnv_92: 2008-06-07
    # onnv_93: 2008-06-19
    # onnv_94: 2008-07-08

    # onnv_95: 2008-07-22
    # onnv_96: 2008-08-05
    # onnv_97: 2008-08-19
    # onnv_98: 2008-09-03
    # onnv_99: 2008-09-15
    
    git log --since=2008-04-12 --until=2008-08-21 --pretty=oneline --date-order --reverse  > /tmp/log.txt
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

