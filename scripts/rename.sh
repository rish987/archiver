set -e
old_name="$2"
new_name="$(dirname $2)/$3"

old_path="archives/$old_name"
new_path="archives/$new_name"

mv $old_path $new_path

TYPE="$(basename $(dirname $2))"

./scripts/update_ytnames.sh "$new_name"

old_basename=$(basename $2)

for file in $(grep -Irl "\/$old_basename\>" archives); do
    vim $file -c "%s/\/$old_basename\\>/\/$3/c"
done

sed -i "s/refln{$TYPE}{$old_basename}/refln{$TYPE}{$3}/" $(dirname $(dirname $new_path))/ref.tex
sed -i "s/reflnenv{$TYPE}{$old_basename}/reflnenv{$TYPE}{$3}/" $(dirname $(dirname $new_path))/ref.tex
