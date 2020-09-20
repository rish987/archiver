PARENT_DIR=`realpath "$1"`
ARCHIVE="$3"
while ! scripts/is_root.sh $PARENT_DIR $ARCHIVE; do
    PARENT_DIR=`dirname $PARENT_DIR`
done

pdfpath=`realpath --relative-to=archives $PARENT_DIR`
pdf=output/$2/$pdfpath/$2.pdf
echo $pdf
