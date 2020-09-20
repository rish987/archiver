ARCHIVE=$2
ARCHIVE_PATH="archives/$ARCHIVE"
roots=("$ARCHIVE_PATH")
roots+=(`find $ARCHIVE_PATH -type d \( -name "proof" -o -name "note" -o -name "topic" -o -name "definition" \) | xargs -i find "{}" -maxdepth 1 -mindepth 1 -type d`)

roots=(`realpath ${roots[@]}`)

if [[ " ${roots[@]} " =~ " $1 " ]]; then
    exit 0
fi
exit 1
