#!/bin/bash
REFPATH="src/$1"
YT_FILE="$REFPATH/metadata/youtube"
TIMESTAMP_FILE="$REFPATH/metadata/timestamps"
STR=""
if [[ -f $YT_FILE ]]; then
    YT_ID=$(cat $YT_FILE)
    TOTAL=$(grep -Po "(?<=^$2 ).*" $TIMESTAMP_FILE)
    STR="\\ \\colorbox{___gray}{\\tt \\scriptsize \\href{https://youtube.com/watch?v=${YT_ID}&feature=youtu.be&t=${TOTAL}}{\\color{red!80}>}}"
fi
echo "\\edef\\refpartname{\\currrefnum x${2}}\\text{}\\hypertarget{\\refpartname}{}\\marginnote{\\colorbox{__gray}{\\tt \\scriptsize \\hyperlink{\\refpartname}{[\\currrefnum.${2}]}}$STR}"
