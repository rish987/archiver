ROOT=`git rev-parse --show-toplevel`/build/src
python $ROOT/scripts/defs_inheritance.py `realpath $1` $ROOT
