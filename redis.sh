#!/bin/bash

DATE=$(date +%F)
LOGDIR=/tmp
SCRIPT_NAME=$0
LOGFILE=$LOGDIR/$SCRIPT_NAME-$DATE.log
Userid=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $Userid -ne 0 ]
then
    echo -e "$R Error:: run this with root access $N"
    exit 1
fi

Validation() {
    if [ $1 -ne 0 ]
    then 
        echo -e "$2...$R Failure $N"
        exit 1
    else
        echo -e "$2...$G Success $N"
    fi
}

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOGFILE

Validation $? "Installing redis repo"

yum module enable redis:remi-6.2 -y &>>$LOGFILE

Validation $? "Enabling redis 6.2 version"

yum install redis -y &>>$LOGFILE

Validation $? "Installing redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf /etc/redis/redis.conf &>>$LOGFILE

Validation $? "Edited redis.conf file to allow remote connection to redis"

systemctl enable redis &>>$LOGFILE

Validation $? "Enabling redis"

systemctl start redis &>>$LOGFILE

Validation $? "Starting redis"

