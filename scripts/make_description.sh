set -e

REFPATH="archives/$1"

META_DIR="$REFPATH/metadata"

TIMESTAMP_FILE="$META_DIR/timestamps"
DESC_FILE="$META_DIR/desc"

REFNUM=$(cat $META_DIR/refnum)

RPS=$(./scripts/get_rps.sh $1)
echo $RPS

>$DESC_FILE

TOTAL="0.0"
{ for rp in ${RPS[@]}; do
    TOTAL=$(grep -Po "(?<=^$rp ).*" $TIMESTAMP_FILE)
    echo "$(python -c "print(\"{}:{:02d}\".format(int($TOTAL)/60, int($TOTAL) % 60))") - [$REFNUM.$rp]"
done; } > $DESC_FILE
