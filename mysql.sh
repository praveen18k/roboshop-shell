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

yum module disable mysql -y &>>$LOGFILE

Validation $? "Disabling default version"

cp /home/centos/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo &>>$LOGFILE

Validation $? "Copying mysql repo"

yum install mysql-community-server -y &>>$LOGFILE

Validation $? "Installing mysql"

systemctl enable mysql &>>$LOGFILE

Validation $? "Enabling mysql"

systemctl start mysql &>>$LOGFILE

Validation $? "Starting mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOGFILE

Validation $? Root user password setup"

