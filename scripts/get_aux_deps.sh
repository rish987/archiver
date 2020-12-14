find archives/$(echo $1 | cut -f1 -d/) -name "refnum" | cut -f2- -d/ | xargs echo -n " "
