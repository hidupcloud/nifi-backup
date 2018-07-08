#!/bin/bash

exec &> /var/log/cron/cron.log

echo "$(date) ***Begin backup"
[[ -z ${NIFI_HOME} ]] && { echo "NIFI_HOME (${NIFI_HOME} not found. Bye!"; exit 1; }

BACKUP_DIR=${NIFI_BACKUP}/$(date "+%Y%m%d-%H%M%S") && mkdir -p ${BACKUP_DIR} || { echo "Error creatin backup dir"; exit 1; }

${NIFI_TOOLKIT}/bin/file-manager.sh -o backup -b ${BACKUP_DIR} -c ${NIFI_HOME}  -v

[[ "$?" == "0" ]] &&
  {
    echo "$(date) ***Cleaning old backups"
    deleteAt=${RETENTION-2}
    find ${NIFI_BACKUP} -mtime ${deleteAt} -exec rm {} \;
    echo "$(date) ***End clean"
  }

echo "$(date) ***End backup"
