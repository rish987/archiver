#!/bin/bash
REFPATH="archives/$1"

RPS=$(./scripts/get_rps.sh $1)
MAX=$(( 0 ))

for rp in ${RPS[@]}; do
    if [[ $(( rp > MAX )) == 1 ]]; then
        MAX=$rp
    fi
done;
echo $(( MAX + 1 ))
