#!/bin/bash
REFPATH="src/$1"
YT_FILE="$REFPATH/metadata/youtube"
TIMESTAMP_FILE="$REFPATH/metadata/timestamps"
STR=""
if [[ -f $YT_FILE ]]; then
    YT_ID=$(cat $YT_FILE)
    TOTAL=$(sed "${2}q;d" $TIMESTAMP_FILE)
    STR="\\ \\colorbox{__gray}{\\tt \\scriptsize \\href{https://youtube.com/watch?v=${YT_ID}&feature=youtu.be&t=${TOTAL}}{\\color{red}>}}"
fi
echo "\\edef\\refpartname{\\currrefnum x\\therefpart}\\text{}\\hypertarget{\\refpartname}{}\\marginnote{\\colorbox{__gray}{\\tt \\scriptsize \\hyperlink{\\refpartname}{[\\currrefnum.\\therefpart]}}$STR}"
