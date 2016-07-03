#! /bin/bash
#
# this file is run by cronjob

# get pwd
PWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $PWD
ONEUP=${PWD%"/gitupdater"}
echo $ONEUP

LAST_RUN_FILE="$PWD/repo-autoupdate.run"
cd $ONEUP

if [ $(git rev-parse HEAD) = $(git ls-remote $(git rev-parse --abbrev-ref @{u} | sed 's/\// /g') | cut -f1) ]; then
    echo up to date
else
    git pull origin
	echo `date` >> $LAST_RUN_FILE
	"$PWD/patch.sh"
fi

exit 0
