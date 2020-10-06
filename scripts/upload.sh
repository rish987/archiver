set -e
./scripts/make_description.sh $1

#python3 ./scripts/upload.py $1 $2
./scripts/upload_manual.sh $1
