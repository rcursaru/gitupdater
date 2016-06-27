#! /bin/bash
#
# this file is run by cronjob
#
LAST_RUN_FILE="repo-autoupdate.run"
cd /git/server_management

if [ $(git rev-parse HEAD) = $(git ls-remote $(git rev-parse --abbrev-ref @{u} | sed 's/\// /g') | cut -f1) ]; then
    echo up to date
else
    git pull origin
	chmod -R g-rwx /git/server_management
	chmod -R o-rwx /git/server_management
	echo `date` >> $LAST_RUN_FILE
	./patch.sh
fi

exit 0
