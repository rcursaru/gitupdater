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

	# is there any point in this
	chmod -x ./"updates/update-$NEXT_VERSION.sh"

	# go to the next version
	NEXT_VERSION=$((NEXT_VERSION+1))
done

# save the last version
NEXT_VERSION=$((NEXT_VERSION-1))
echo "VERSION_CURRENT=$NEXT_VERSION" > $VERSION_FILE

echo "done"
exit 0;
echo "done?"







VERSION_NEW="9"
VERSION_FILE="patch.version"

cd /git/server_management

if [ ! -f "$VERSION_FILE" ]; then
	echo "VERSION_CURRENT=\"0\"" > $VERSION_FILE
fi

. ./"$VERSION_FILE"

if [[ "$VERSION_NEW" -le "$VERSION_CURRENT" ]]; then
	echo "Nothing to do, new version ($VERSION_NEW) isn't newer then current version ($VERSION_CURRENT)"
	exit 0;
else
	echo "Running patch to update from version $VERSION_CURRENT to version $VERSION_NEW"
fi




function PATCH_INCREMENTAL {
	echo "patch level: $1"
	case $1 in
		8)
			sed -i '/user/s/www-data/appuser/g' /etc/php5/fpm/pool.d/www.conf
			sed -i '/group/s/www-data/appuser/g' /etc/php5/fpm/pool.d/www.conf
			sed -i '/fastcgi_pass/s/127\.0\.0\.1\:9000/\/var\/run\/php5\-fpm\.sock/g' /etc/nginx/conf.d/*.bsoftce.com.conf
			service php5-fpm restart
			service nginx reload
			echo "VERSION_CURRENT=\"$1\"" > $VERSION_FILE
			;;
		9)
			sed -i '/fastcgi_pass/s/\/var\/run\/php5\-fpm\.sock/127\.0\.0\.1\:9000/g' /etc/nginx/conf.d/*.bsoftce.com.conf
			sed -i '/listen/s/\/var\/run\/php5\-fpm\.sock/9000/g' /etc/php5/fpm/pool.d/www.conf
			service php5-fpm restart
			service nginx reload
			echo "VERSION_CURRENT=\"$1\"" > $VERSION_FILE
			;;
		10)
			sed -i '/user/s/appuser/appuser3/g' /etc/php5/fpm/pool.d/www.conf
			sed -i '/group/s/appuser/appuser3/g' /etc/php5/fpm/pool.d/www.conf
			sed -i '/fastcgi_pass/s/127\.0\.0\.1\:9000/\/var\/run\/php5\-fpm\.sock/g' /etc/nginx/conf.d/*.bsoftce.com.conf
			service php5-fpm restart
			service nginx reload
			echo "VERSION_CURRENT=\"$1\"" > $VERSION_FILE
			;;
		11)
			echo "VERSION_CURRENT=\"$1\"" > $VERSION_FILE
			;;
		12)
			echo "VERSION_CURRENT=\"$1\"" > $VERSION_FILE
			;;
		13)
			echo "VERSION_CURRENT=\"$1\"" > $VERSION_FILE
			;;
		14)
			echo "VERSION_CURRENT=\"$1\"" > $VERSION_FILE
			;;
		15)
			echo "VERSION_CURRENT=\"$1\"" > $VERSION_FILE
			;;
		16)
			echo "VERSION_CURRENT=\"$1\"" > $VERSION_FILE
			;;
		17)
			echo "VERSION_CURRENT=\"$1\"" > $VERSION_FILE
			;;
		18)
			echo "VERSION_CURRENT=\"$1\"" > $VERSION_FILE
			;;
		19)
			echo "VERSION_CURRENT=\"$1\"" > $VERSION_FILE
			;;
		*)
  			Message="I seem to be running with a nonexistent patch increment..."
  			;;
  	esac
}




for PATCH_LEVEL in $(seq "$VERSION_CURRENT" "$VERSION_NEW"); do
	echo "running incremental patching"
	PATCH_INCREMENTAL "$PATCH_LEVEL"
done


exit 0
