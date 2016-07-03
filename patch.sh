#! /bin/bash
#
# this file is run by cronjob
#

# determine pwd
PWD="`dirname \"$0\"`"                                                      
PWD="`(cd \"$PWD\" && pwd )`"                                               


# local versions are stored here
VERSION_CURRENT="$PWD/patch.version"
VERSION_TARGET="$PWD/patch.target"

# get current version
if [ ! -f "$VERSION_CURRENT" ]; then
	echo "VERSION_CURRENT=0" > $VERSION_CURRENT
fi

. "$PWD/$VERSION_CURRENT"
echo "Current version is $VERSION_CURRENT"

# get target version
. "$PWD/$VERSION_TARGET"
NEXT_VERSION=$VERSION_CURRENT
echo "Target version is $VERSION_TARGET"

# while we are behind VERSION_TARGET
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

	# save the last version
	echo "VERSION_CURRENT=$NEXT_VERSION" > $VERSION_CURRENT
done

echo "DONE"
exit 0;
