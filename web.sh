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

yum install nginx -y &>>$LOGFILE

Validation $? "Instaling nginx"

systemctl enable nginx &>>$LOGFILE

Validation $? "Enabling nginx"

systemctl start nginx &>>$LOGFILE

Validation $? "Starting nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE

Validation $? "Removing default content"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>$LOGFILE

Validation $? "Downloading web artifacts"

cd /usr/share/nginx/html &>>$LOGFILE

Validation $? "Moving to default HTML directory"

unzip /tmp/web.zip &>>$LOGFILE

Validation $? "Unzipping web artifacts"

cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$LOGFILE

Validation $? "Copying roboshop.conf into default.d"

systemctl restart nginx &>>$LOGFILE

Validation $? "Restarting nginx"


