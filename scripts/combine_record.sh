set -e
REFPATH="archives/$1"
NUM_RPS=$(( $(grep -Po '\\nrp' $REFPATH/ref.tex | wc -l) ))
echo "$NUM_RPS reference parts found."

VIDEO_DIR="$REFPATH/metadata/video"

INDEX=$(( 1 ))
VLIST="/tmp/vlist"
>$VLIST
while [[ $(( INDEX < NUM_RPS + 1)) == 1 ]]; do
    part=$VIDEO_DIR/parts/$INDEX.mp4
    if [[ -f $part ]]; then
        echo "file $(realpath $part)" >> $VLIST
    fi
    (( INDEX++ ))
done

ffmpeg -f concat -safe 0 -i $VLIST -c copy $VIDEO_DIR/video.mp4 -y
