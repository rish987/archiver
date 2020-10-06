#!/bin/bash
REFPATH="src/$1"
VIDEO_DIR="$REFPATH/metadata/video"

STR=""
YT_FILE="$REFPATH/metadata/youtube"
if [[ -f $YT_FILE ]]; then
  YT_ID=$(cat $YT_FILE)

  PART_INDEX=$(( $2 ))
  INDEX=$(( 1 ))
  TOTAL="0.0"
  while [[ $(( INDEX <= PART_INDEX - 1 )) == 1 ]]; do
      part=$VIDEO_DIR/parts/$INDEX.mp4
      if [[ -f $part ]]; then
        time=$(cat $part)
        TOTAL=$(python -c "print($TOTAL + $time)")
      else
        TOTAL="-1"
        break
      fi
      (( INDEX++ ))
  done
  
  TOTAL=$(echo $TOTAL | sed "s/\..*//g")

  if [[ $(( TOTAL > -1 )) == 1 ]]; then
    STR="\\href{https://youtube.com/watch?v=${YT_ID}&feature=youtu.be&t=${TOTAL}}{\\color{red}>}"
  else
    STR="\\href{https://youtube.com/watch?v=${YT_ID}}{\\color{red}>}"
  fi
fi
echo "\\edef\\refpartname{\\currrefnum.\\therefpart}\\text{}\\hypertarget{\\refpartname}{}\\marginnote{\\colorbox{__gray}{\\tt \\scriptsize \\hyperlink{\\refpartname}{[\\refpartname]}}\\ \\colorbox{__gray}{\\tt \\scriptsize $STR}}"
