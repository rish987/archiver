set -e

REFPATH="archives/$1"

META_DIR="$REFPATH/metadata"

DESC_FILE="$META_DIR/desc"
YOUTUBE_FILE="$META_DIR/youtube"

REFNUM=$(cat $REFPATH/metadata/refnum)

if [[ -f $YOUTUBE_FILE ]]; then
    ID=$(cat $YOUTUBE_FILE)
    python3 scripts/update_title.py $2 $ID "[OLD] [$REFNUM] $1" $DESC_FILE
fi

./scripts/timestamps.sh $1

./scripts/make_description.sh $1

#python3 ./scripts/upload.py $1 $2
./scripts/upload_manual.sh $1
