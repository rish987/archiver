python3 scripts/get_deps.py $1 $2
find projects/$1 -maxdepth 1 -mindepth 1 -type d -a \( -name proof -o -name note -o -name topic -o -name definition \) | xargs -i find "{}" -maxdepth 2 -mindepth 2 -name "defs.tex" | cut -f2- -d/ | xargs echo -n
find projects/$(echo $1 | cut -f1 -d/) -name "refnum" | cut -f2- -d/ | xargs echo -n " "
