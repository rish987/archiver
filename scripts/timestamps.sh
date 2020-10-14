#!/bin/bash
REFPATH="archives/$1"
VIDEO_DIR="$REFPATH/metadata/video"

STR=""
TIMESTAMP_FILE="$REFPATH/metadata/timestamps"

NUM_PARTS=$(( `ls -l archives/archive/metadata/video/parts | wc -l` - 1 ))
INDEX=$(( 1 ))
TOTAL="0.0"

>$TIMESTAMP_FILE
{ echo 0; while [[ $(( INDEX <= NUM_PARTS - 1 )) == 1 ]]; do
    part=$VIDEO_DIR/parts/$INDEX.mp4
    time=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $part)
    TOTAL=$(python -c "print($TOTAL + $time)")
    echo $TOTAL | sed "s/\..*//g"
    (( INDEX++ ))
done; } > $TIMESTAMP_FILE
