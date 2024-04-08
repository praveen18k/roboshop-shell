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

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

Validation $? "Copied mongo repo into yum.repos.d"

yum install mongodb-org -y &>>$LOGFILE

Validation $? "Installing mongodb"

systemctl enable mongod &>>$LOGFILE

Validation $? "Enabling mongodb"

systemctl start mongod &>>$LOGFILE

Validation $? "Starting mongodb"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOGFILE

Validation $? "Editing mongod.conf file"

systemctl restart mongod

Validation $? "Restarting mongodb"
