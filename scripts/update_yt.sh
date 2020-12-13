set -e
for ref in $(./scripts/get_refs.sh $2); do
    temp_path="archives/$ref"
    if [[ -f $temp_path/metadata/youtube ]]; then
        ./scripts/make_description.sh $ref

        temp_refnum=$(cat $temp_path/metadata/refnum)
        temp_id=$(cat $temp_path/metadata/youtube)
        temp_desc_file="$temp_path/metadata/desc"

        python3 scripts/update_title.py $1 $temp_id "[$temp_refnum] $ref" "$temp_desc_file"
    fi
done
