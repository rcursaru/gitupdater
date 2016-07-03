#! /bin/bash
#
# this file is run by cronjob
#

VERSION_CURRENT="patch.version"
VERSION_TARGET="patch.target"

if [ ! -f "$VERSION_CURRENT" ]; then
	# create a new file and write VERSION_CURRENT=0 in it
	echo "VERSION_CURRENT=0" > $VERSION_CURRENT
fi

# get current version
. ./"$VERSION_CURRENT"
echo "Current version is $VERSION_CURRENT"

# get target version
. ./"$VERSION_TARGET"

NEXT_VERSION=$VERSION_CURRENT

# maximum 5 updates per batch to avoid infinit loop
while [ $VERSION_CURRENT -lt $VERSION_TARGET ]
do
	# go to the next version
	NEXT_VERSION=$((NEXT_VERSION+1))

	# increment version
   	if [ ! -f "updates/update-$NEXT_VERSION.sh" ]; then
		echo "Update $NEXT_VERSION not available."
		break
   	fi
	echo "Running updates update-$NEXT_VERSION.sh"
	chmod +x ./"updates/update-$NEXT_VERSION.sh"
	./"updates/update-$NEXT_VERSION.sh"

	# is there any point in this?
	chmod -x ./"updates/update-$NEXT_VERSION.sh"
	
done

# save the last version
echo "VERSION_CURRENT=$NEXT_VERSION" > $VERSION_CURRENT

echo "DONE"
exit 0;
