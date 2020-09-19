get_defs(){
    grep -Po '(?<=^\\def)\\[a-zA-Z]+(#\d)*' $1/defs.tex
}

{ for i in $(seq 1 $(get_defs $1 | wc -l)); do echo '\defvisualizer'; done; } > temp1
{ get_defs $1 | sed 's/\\\(\w\+.*\)/{\1}/;s/#/\\#/g'; } > temp2
{ get_defs $1 | sed 's/#\([1-9]\)/{\\placeholder{\\#\1}}/g;s/\(.*\)/{\1}/'; } > temp3
paste -d "\n" temp1 temp2 temp3
