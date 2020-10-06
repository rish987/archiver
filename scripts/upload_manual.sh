REFPATH="archives/$1"

META_DIR="$REFPATH/metadata"
VIDEO_DIR="$META_DIR/video"

DESC_FILE="$VIDEO_DIR/desc"
YOUTUBE_FILE="$META_DIR/youtube"

REFNUM=$(cat $REFPATH/metadata/refnum)

pcmanfm $VIDEO_DIR

echo -n "[$REFNUM] $1" | xclip -sel c

read -p "Title copied to clipboard. Enter to continue."

cat $DESC_FILE | xclip -sel c

read -p "Description copied to clipboard. Enter to continue."

read -p "Enter video link: "
echo $REPLY | cut -f4 -d/ > $YOUTUBE_FILE
