TEMP=( $(echo $1 && find archives/$1 -type d -a \( -name proof -o -name note -o -name topic -o -name definition \) | xargs -i find "{}" -maxdepth 1 -mindepth 1 | cut -f2- -d/ | xargs echo -n) )
for path in ${TEMP[@]}; do
    echo output/tree/$path/tree.pdf
done
