#!/bin/bash

STR=""
YT_FILE="src/$1/metadata/youtube"
if [[ -f $YT_FILE ]]; then
  YT_ID=$(cat $YT_FILE)
  STR="\\ \\colorbox{__gray}{\\tt \\href{https://youtube.com/watch?v=${YT_ID}}{\\color{red}>[${YT_ID/_/\\_}]}}"
fi
echo "\\colorbox{__gray}{\\tt [\\currrefnum]}$STR"
