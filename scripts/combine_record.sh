set -e
REFPATH="archives/$1"
RPS=($(./scripts/get_rps.sh $1))

VIDEO_DIR="$REFPATH/metadata/video"

VLIST="/tmp/vlist"
>$VLIST
for rp in ${RPS[@]}; do
    part=$VIDEO_DIR/parts/$rp.mp4
    if [[ -f $part ]]; then
        echo "file $(realpath $part)" >> $VLIST
    else 
        echo "file $part NOT FOUND"
        exit 1
    fi
done

ffmpeg -f concat -safe 0 -i $VLIST -c copy $VIDEO_DIR/video.mp4 -y
