#!/bin/bash

CURRREF="$1"
TYPE="$2"
NAME="$3"
ARCHIVE="$4"

TEMPLATE="scripts/templates/$TYPE.tex"
newpath=archives/$CURRREF/$TYPE/$NAME
REF_FILENAME="$newpath/ref.tex"
DEFS_FILENAME="$newpath/defs.tex"

max_i=0
for ref in $(echo $ARCHIVE && cd archives && find ${ARCHIVE} -type d -a \( -name src -o -name proof -o -name note -o -name topic -o -name definition \) | xargs -i find "{}" -maxdepth 1 -mindepth 1); do 
    i=`cat archives/$ref/metadata/refnum`
    if (( $i > $max_i )); then 
        max_i=$i
    fi;
done; 
(( max_i++ ))

mkdir -p $newpath
mkdir -p $newpath/metadata

echo $max_i > $newpath/metadata/refnum
cp "$TEMPLATE" "$REF_FILENAME"
touch "$DEFS_FILENAME"
