#! /bin/bash
#
# this file is run by cronjob
#

VERSION_FILE="patch.version"

if [ ! -f "$VERSION_FILE" ]; then
	# create a new file and write VERSION_CURRENT=0 in it
	echo "VERSION_CURRENT=0" > $VERSION_FILE
fi

# get current version
. ./"$VERSION_FILE"
echo "Current version is $VERSION_CURRENT"
NEXT_VERSION=$((VERSION_CURRENT+1))

# maximum 5 updates per batch to avoid infinit loop
for i in {1..5}
do
	# increment version
   	if [ ! -f "updates/update-$NEXT_VERSION.sh" ]; then
		echo "No more updates available."
		break
   	fi
	echo "Running updates update-$NEXT_VERSION.sh"
	chmod +x ./"updates/update-$NEXT_VERSION.sh"
	./"updates/update-$NEXT_VERSION.sh"

	# is there any point in this?
	chmod -x ./"updates/update-$NEXT_VERSION.sh"

	# go to the next version
	NEXT_VERSION=$((NEXT_VERSION+1))
done

# save the last version
NEXT_VERSION=$((NEXT_VERSION-1))
echo "VERSION_CURRENT=$NEXT_VERSION" > $VERSION_FILE

echo "DONE"
exit 0;
