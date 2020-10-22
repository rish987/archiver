set -e
REFPATH="archives/$1"
NUM_RPS=$(./scripts/get_num_rps.sh $1)
echo "$NUM_RPS reference parts found."

VIDEO_DIR="$REFPATH/metadata/video"

INDEX=$(( 1 ))
VLIST="/tmp/vlist"
>$VLIST
while [[ $(( INDEX < NUM_RPS + 1)) == 1 ]]; do
    part=$VIDEO_DIR/parts/$INDEX.mp4
    if [[ -f $part ]]; then
        echo "file $(realpath $part)" >> $VLIST
    else 
        echo "file $part NOT FOUND"
        exit 1
    fi
    (( INDEX++ ))
done

ffmpeg -f concat -safe 0 -i $VLIST -c copy $VIDEO_DIR/video.mp4 -y
