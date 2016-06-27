#! /bin/bash
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