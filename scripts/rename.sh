set -e
old_name="$2"
new_name="$(dirname $2)/$3"

old_path="archives/$old_name"
new_path="archives/$new_name"

mv $old_path $new_path

TYPE="$(basename $(dirname $2))"

for ref in $(./scripts/get_refs.sh $new_name); do
    temp_path="archives/$ref"
    if [[ -f $temp_path/metadata/youtube ]]; then
        temp_refnum=$(cat $temp_path/metadata/refnum)

        temp_id=$(cat $temp_path/metadata/youtube)
        temp_desc_file="$temp_path/metadata/video/desc"
        python3 scripts/update_title.py $1 $temp_id "[$temp_refnum] $ref" "$temp_desc_file"
    fi
done

old_basename=$(basename $2)

for file in $(grep -Irl "\/$old_basename\>" archives); do
    vim $file -c "%s/\/$old_basename/\/$3/c"
done

sed -i "s/refln{$TYPE}{$old_basename}/refln{$TYPE}{$3}/" $(dirname $(dirname $new_path))/ref.tex
sed -i "s/reflnenv{$TYPE}{$old_basename}/reflnenv{$TYPE}{$3}/" $(dirname $(dirname $new_path))/ref.tex
