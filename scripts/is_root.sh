roots=("src/archives")
roots+=(`find src -type d \( -name "proof" -o -name "note" -o -name "topic" -o -name "definition" \) | xargs -i find "{}" -maxdepth 1 -mindepth 1 -type d`)

roots=(`realpath ${roots[@]}`)

if [[ " ${roots[@]} " =~ " $1 " ]]; then
    exit 0
fi
exit 1
