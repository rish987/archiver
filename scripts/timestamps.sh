#!/bin/bash
REFPATH="archives/$1"
VIDEO_DIR="$REFPATH/metadata/video"

STR=""
TIMESTAMP_FILE="$REFPATH/metadata/timestamps"

RPS=$(./scripts/get_rps.sh $1)
TOTAL="0.0"

>$TIMESTAMP_FILE
{ for rp in ${RPS[@]}; do
    echo $rp $TOTAL | sed "s/\..*//g"
    part=$VIDEO_DIR/parts/$rp.mp4
    time=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $part)
    TOTAL=$(python -c "print($TOTAL + $time)")
done; } > $TIMESTAMP_FILE
