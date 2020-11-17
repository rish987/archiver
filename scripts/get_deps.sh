python3 scripts/get_deps.py $1 $2
find archives/$1 -maxdepth 1 -mindepth 1 -type d -a \( -name proof -o -name note -o -name topic -o -name definition \) | xargs -i find "{}" -maxdepth 2 -mindepth 2 -name "defs.tex" | cut -f2- -d/ | xargs echo -n
echo -n " "
find archives/$1 -maxdepth 1 -mindepth 1 -type d -a \( -name proof -o -name note -o -name topic -o -name definition \) | xargs -i find "{}" -maxdepth 3 -mindepth 3 -name "refnum" | cut -f2- -d/ | xargs echo -n
echo -n " $1/metadata/refnum "
find archives/$1/metadata -type f \( -name 'timestamps' -o -name 'youtube' \) | cut -f2- -d/ | xargs echo -n
#find archives/$(echo $1 | cut -f1 -d/) -name "refnum" | cut -f2- -d/ | xargs echo -n " "
