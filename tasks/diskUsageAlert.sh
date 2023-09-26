#!/bin/sh
# this script was initially written for Redhat/CentOS
# file is /etc/cron.daily/diskAlert.cron
# requires enabling outgoing sendmail from localhost to a valid 
# smtp server, which is usually disabled by default
ADMIN="moayyad@severalbrands.com"
THRESHOLD=80
export APP_NAME="{APP_NAME}"
export APP_ENV="{APP_ENV}"

df -PkH | grep -vE '^Filesystem|tmpfs|cdrom|media' | awk '{ print $5 " " $6 }' | while read output;
do
    usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1 )
    partition=$(echo $output | awk '{print $2}' )
    if [ $usep -ge $THRESHOLD ]; then
    echo "Running out of space \"$partition ($usep%)\" on $(hostname) as on $(date)" |
    #mail -s "Alert: Almost out of disk space $usep%" $ADMIN
    AWS_ACCESS_KEY_ID="{AWS_ACCESS_KEY_ID}" AWS_SECRET_ACCESS_KEY="{AWS_SECRET_ACCESS_KEY}" aws sns publish --topic-arn arn:aws:sns:us-east-1:113686751618:DevTeamAlerts --subject "Alert ($APP_NAME - $APP_ENV) DiskSpace: $usep%" --message "Alert ($APP_NAME - $APP_ENV) : Almost out of disk space $usep%" --region us-east-1
    fi
done