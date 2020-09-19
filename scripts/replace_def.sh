PARENT_DIR=`realpath "$1"`
while ! scripts/is_root.sh $PARENT_DIR; do
    PARENT_DIR=`dirname $PARENT_DIR`
done

for file in `find $PARENT_DIR -name '*.tex'`
do
    sed -i "s/\\\\${2}\([^a-zA-Z]\)/\\\\${3}\1/g" $file
    sed -i "s/\\\\${2}$/\\\\${3}/g" $file
done 
