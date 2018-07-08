#!/bin/sh
set -e

rm -rf /var/spool/cron/crontabs && mkdir -m 0644 -p /var/spool/cron/crontabs

[ "$(ls -A /etc/cron.d)" ] && cp -f /etc/cron.d/* /var/spool/cron/crontabs/ || true

[ ! -z "$CRON_STRINGS" ] && echo -e "$CRON_STRINGS /backup.sh\n" > /var/spool/cron/crontabs/CRON_STRINGS

chmod -R 0644 /var/spool/cron/crontabs

#if [ ! -z "$CRON_TAIL" ]
#then
	# crond running in background and log file reading every second by tail to STDOUT
	crond -s /var/spool/cron/crontabs -b -L /var/log/cron/cron.log "$@" && tail -f /var/log/cron/cron.log
#else
	# crond running in foreground. log files can be retrive from /var/log/cron mount point
#	crond -s /var/spool/cron/crontabs -f -L /var/log/cron/cron.log "$@"
#fi
