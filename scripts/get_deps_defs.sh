python3 scripts/get_deps_defs.py $1
find projects/$(echo $1 | cut -f1 -d/) -name "refnum" | cut -f2- -d/ | xargs echo -n " "
