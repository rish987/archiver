REFPATH="archives/$1"
NUM_RPS=$(( $(grep -Po '\\nrp' $REFPATH/ref.tex | wc -l) ))
if [[ -d $REFPATH/parts ]]; then 
    NUM_RPS=$(( NUM_RPS + $(grep -Po '\\nrp' $REFPATH/parts/*.tex | wc -l) ))
fi
echo $NUM_RPS
