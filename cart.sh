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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE

validations $? "Setting up NPM source"

yum install nodjs -y &>>$LOGFILE

validations $? "Installing nodejs"

#once the user is created, if you run this script 2nd time this command will defnitly fail
#IMPROVMENT - first check the user already exist or not, if not exist then create.
useradd roboshop &>>$LOGFILE

#validations $? "Adding user"

#Write a condition to check directory already exist or not
mkdir /app &>>$LOGFILE

#validations $? "App directory creation"

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>>$LOGFILE

validations $? "Downloading cart artifact files"

cd /app &>>$LOGFILE

validations $? "Moving to app"

unzip /tmp/cart.zip &>>$LOGFILE

validations $? "Unzipping cart files"

npm install &>>$LOGFILE

validations $? "Installing dependencies"

#give full path of cart.service because we are inside /app
cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service &>>$LOGFILE

validations $? "Copied cart.service into systemd"

systemctl daemon-reload &>>$LOGFILE

validations $? "Reloading cart service"

systemctl enable cart &>>$LOGFILE

validations $? " Enableing cart"

systemctl start cart &>>$LOGFILE

validations $? "Starting cart"
