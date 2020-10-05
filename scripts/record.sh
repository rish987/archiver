set -e
REFPATH="archives/$1"
NUM_RPS=$(( $(grep -Po '\\nrp' $REFPATH/ref.tex | wc -l) ))
echo "$NUM_RPS reference parts found."

INDEX=$(( 0 ))
while [[ ( $INDEX < 1 ) || ( $INDEX > $NUM_RPS ) ]]; do
    read -p "Select reference part ('enter' for 1): "
    INDEX=$(( REPLY ))
    if [[ $INDEX == 0 ]]; then
        INDEX=$(( 1 ))
    fi
done

VIDEO_DIR="$REFPATH/metadata/video/parts"
RECORD_SCRIPT="scripts/record_video.sh"

while true; do
    echo -e "Part [$INDEX]"

    select opt in "record" "next" "prev" "quit"
    do
        case $opt in
            "record")
                if [[ ! -f $RECORD_SCRIPT ]]; then
                    ls $RECORD_SCRIPT
                    echo "No record script ($RECORD_SCRIPT) found!"
                    break
                else
                    echo "recording in 3 seconds..."
                    sleep 3
                    echo "recording..."
                    mkdir -p $VIDEO_DIR
                    $RECORD_SCRIPT $VIDEO_DIR/$INDEX.mp4
                fi
                ;;
            "next")
                if [[ $(( INDEX + 1 <= NUM_RPS )) == 1 ]]; then
                    (( INDEX++ ))
                    break
                else
                    echo "Reached last part!"
                fi
                ;;
            "prev")
                if [[ $(( INDEX - 1 > 0 )) == 1 ]]; then
                    (( INDEX-- ))
                    break
                else
                    echo "Reached first part!"
                fi
                ;;
            "quit")
                exit 0
                ;;
            *) echo "invalid option $REPLY";;
        esac
    done
done
