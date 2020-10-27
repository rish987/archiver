REFPATH="archives/$1"
RPS=$(grep -Po '(?<=\\nrp )\w+' $REFPATH/ref.tex)
echo ${RPS[@]}
