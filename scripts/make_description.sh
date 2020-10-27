set -e

REFPATH="archives/$1"

VIDEO_DIR="$REFPATH/metadata/video"

DESC_FILE="$VIDEO_DIR/desc"

REFNUM=$(cat $REFPATH/metadata/refnum)

RPS=$(./scripts/get_rps.sh $1)

>$DESC_FILE

{ TOTAL="0.0"
for rp in ${RPS[@]}; do
    echo "$(python -c "print(\"{}:{:02d}\".format(int($TOTAL)/60, int($TOTAL) % 60))") - [$REFNUM.$rp]"
    part=$VIDEO_DIR/parts/$rp.mp4
    if [[ -f $part ]]; then
        time=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $part)
        TOTAL=$(python -c "print($TOTAL + $time)")
    else
        exit 1
    fi
done; } > $DESC_FILE
