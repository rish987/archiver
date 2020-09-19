PARENT_DIR=`realpath "$1"`
while ! scripts/is_root.sh $PARENT_DIR; do
    PARENT_DIR=`dirname $PARENT_DIR`
done

PARENT_DIR=`realpath --relative-to=. $PARENT_DIR`
pdfpath=`echo $PARENT_DIR | cut -f2- -d/`
pdf=output/$pdfpath/$2.pdf
echo $pdf
