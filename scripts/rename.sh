REFPATH="archives/$2"
REFNUM=$(cat $REFPATH/metadata/refnum)

DESC_FILE="$REFPATH/metadata/video/desc"
ID=$(cat $REFPATH/metadata/youtube)

TYPE="$(basename $(dirname $2))"

new_name="$(dirname $2)/$3"

python3 scripts/update_title.py $1 $ID "[$REFNUM] $new_name" "$DESC_FILE"

old_basename=$(basename $2)

for file in $(grep -Irl "\/$old_basename\>" archives); do
    vim $file -c "%s/\/$old_basename/\/$3/c"
done

sed -i "s/refln{$TYPE}{$old_basename}/refln{$TYPE}{$3}/" $(dirname $(dirname $REFPATH))/ref.tex
sed -i "s/reflnenv{$TYPE}{$old_basename}/reflnenv{$TYPE}{$3}/" $(dirname $(dirname $REFPATH))/ref.tex

mv $REFPATH "archives/$new_name"
