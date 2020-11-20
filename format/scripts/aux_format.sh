#!/bin/bash

STR=""
YT_FILE="src/$1/metadata/youtube"
if [[ -f $YT_FILE ]]; then
  YT_ID=$(cat $YT_FILE)
  STR="\\ \\colorbox{___gray}{\\tt \\href{https://youtube.com/watch?v=${YT_ID}}{\\color{red!80}>[${YT_ID/_/\\_}]}}"
fi

time_1=$(cat src/$1/ref.tex.time)
time_2=$(cat src/$1/defs.tex.time)
time=$time_1
if [[ $(( $time_1 < $time_2 )) == 1 ]]; then time=$time_2; fi
timestamp=$(date -d@$time '+%m/%d/%Y %H:%M')
echo "\\colorbox{___gray}{\\color{gray}\\tt [$timestamp]}$STR"
