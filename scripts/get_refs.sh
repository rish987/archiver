cd archives
echo $1
find $1 -type d \( -name "proof" -o -name "note" -o -name "topic" -o -name "definition" \) | xargs -i find "{}" -maxdepth 1 -mindepth 1
