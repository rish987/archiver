set -e -o pipefail
REFPATH="archives/$1"

META_DIR="$REFPATH/metadata"
VIDEO_DIR="$META_DIR/video"

DESC_FILE="$META_DIR/desc"
YOUTUBE_FILE="$META_DIR/youtube"

REFNUM=$(cat $REFPATH/metadata/refnum)

if [[ -f $HOME/work/scripts/mouse_up.sh ]]; then
    $HOME/work/scripts/mouse_up.sh
fi

pcmanfm $VIDEO_DIR
sleep 2

echo -n "[$REFNUM] $1" | xclip -sel c

WINID=`wmctrl -lG | grep -Po "(?<=^)\S*(?=.*Channel content)"`
echo WINID: $WINID

xdotool windowactivate $WINID && xdotool scripts/upload_pre.xdt
read -p "Drag video to browser. Enter to continue."
#read -p "Title copied to clipboard. Enter to continue."
xdotool windowactivate $WINID && xdotool key ctrl+v

sleep 1

cat $DESC_FILE | xclip -sel c

xdotool windowactivate $WINID && xdotool scripts/upload_post.xdt 

#read -p "Description copied to clipboard. Enter to continue."

#read -p "Enter video link: "
REPLY=`xclip -sel c -o`
echo $REPLY | cut -f4 -d/ > $YOUTUBE_FILE
echo $REPLY | cut -f4 -d/
sleep 2
