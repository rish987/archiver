cd archives/$1
find ./ -type d \( -name "proof" -o -name "note" -o -name "topic" -o -name "definition" \) | xargs -i find "{}" -maxdepth 1 -mindepth 1 | cut -f2- -d/; 
