set -e

REF=$1
REFPATH="archives/$REF"
REFNUM=`cat $REFPATH/metadata/refnum`

RPS=($(./scripts/get_rps.sh $1))
NUM_RPS=${#RPS[@]}

get_index () {
    list=($1)
    for i in "${!list[@]}"; do
        if [[ "${list[$i]}" = "$2" ]]; then
            echo "$i"
            return
        fi
    done
    echo 0
}

INDEX=$(( -1 ))
while [[ $(( ( $INDEX < 0 ) || ( $INDEX > $NUM_RPS ) )) == 1 ]]; do
    read -p "Select reference part ('enter' for first): "
    INDEX=$(get_index "${RPS[*]}" "$REPLY")
done

VIDEO_DIR="$REFPATH/metadata/video/parts"
RECORD_SCRIPT="scripts/record_video.sh"
PLAY_SCRIPT="scripts/play_video.sh"

while true; do
    RP=${RPS[$INDEX]}
    echo -e "Part [$RP]"

    select opt in "record" "play" "prev" "next" "quit" 
    do
        case $opt in
            "record")
                if [[ ! -f $RECORD_SCRIPT ]]; then
                    ls $RECORD_SCRIPT
                    echo "No record script ($RECORD_SCRIPT) found!"
                    break
                else
                    mkdir -p $VIDEO_DIR
                    $RECORD_SCRIPT "$REF" "${REFNUM}x$RP" "$VIDEO_DIR/$RP.mp4"
                fi
                ;;
            "next")
                if [[ $(( INDEX + 1 <= NUM_RPS )) == 1 ]]; then
                    INDEX=$(( INDEX + 1 ))
                    break
                else
                    echo "Reached last part!"
                fi
                ;;
            "prev")
                if [[ $(( INDEX - 1 > 0 )) == 1 ]]; then
                    INDEX=$(( INDEX - 1 ))
                    break
                else
                    echo "Reached first part!"
                fi
                ;;
            "play")
                $PLAY_SCRIPT $VIDEO_DIR/$RP.mp4
                ;;
            "quit")
                exit 0
                ;;
            *) echo "invalid option $REPLY";;
        esac
    done
done
