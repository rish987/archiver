ROOT=`git rev-parse --show-toplevel | tr -d "\n"`
TYPE="$1"
NAME="$2"
PARENT_DIR=`realpath "$3"`
ARCHIVE="$4"
while ! scripts/is_root.sh $PARENT_DIR $ARCHIVE; do
    PARENT_DIR=`dirname $PARENT_DIR`
done

TEMPLATE="scripts/templates/$TYPE.tex"

if [[ ! -e "$TEMPLATE" ]]; then
    echo -n "No template found for type \"$TYPE\"."
    exit 1
fi

NEW_PATH="$PARENT_DIR/$TYPE/$NAME"

REF_FILENAME="$NEW_PATH/ref.tex"
DEFS_FILENAME="$NEW_PATH/defs.tex"
FILENAMES="$REF_FILENAME $DEFS_FILENAME"

if [[ ! -d "$NEW_PATH" ]]; then
    currref=`realpath --relative-to=$ROOT/archives $PARENT_DIR`
    scripts/new_ref.sh $currref $TYPE $NAME $ARCHIVE
fi

FILENAMES=`realpath --relative-to=$ROOT $FILENAMES`
echo -n $FILENAMES
