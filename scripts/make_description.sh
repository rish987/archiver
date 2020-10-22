set -e

REFPATH="archives/$1"

VIDEO_DIR="$REFPATH/metadata/video"

DESC_FILE="$VIDEO_DIR/desc"

REFNUM=$(cat $REFPATH/metadata/refnum)

NUM_RPS=$(./scripts/get_num_rps.sh $1)
echo "$NUM_RPS reference parts found."

>$DESC_FILE

{ INDEX=$(( 1 ))
TOTAL="0.0"
while [[ $(( INDEX <= NUM_RPS )) == 1 ]]; do
    echo "$(python -c "print(\"{}:{:02d}\".format(int($TOTAL)/60, int($TOTAL) % 60))") - [$REFNUM.$INDEX]"
    part=$VIDEO_DIR/parts/$INDEX.mp4
    if [[ -f $part ]]; then
        time=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $part)
        TOTAL=$(python -c "print($TOTAL + $time)")
    else
        exit 1
    fi
    (( INDEX++ ))
done; } > $DESC_FILE
