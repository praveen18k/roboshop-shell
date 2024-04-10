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

validations() {
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

yum install nodejs -y &>>$LOGFILE

validations $? "Installing nodejs"

#once the user is created, if you run this script 2nd time this command will defnitly fail
#IMPROVMENT - first check the user already exist or not, if not exist then create.
useradd roboshop &>>$LOGFILE

#validations $? "Adding user"

#Write a condition to check directory already exist or not
mkdir /app &>>$LOGFILE

validations $? "App directory creation"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOGFILE

validations $? "Downloading catalogue artifact files"

cd /app &>>$LOGFILE

validations $? "Moving to app"

unzip -o /tmp/catalogue.zip &>>$LOGFILE

validations $? "Unzipping catalogue files"

npm install -y &>>$LOGFILE

validations $? "Installing dependencies"

#give full path of catalogue.service because we are inside /app
cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>>$LOGFILE

validations $? "Copied catalogue.service into systemd"

systemctl daemon-reload &>>$LOGFILE

validations $? "Reloading catalogue service"

systemctl enable catalogue &>>$LOGFILE

validations $? " Enableing catalogue"

systemctl start catalogue &>>$LOGFILE

validations $? "Starting catalogue"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

validations $? " Copying mongo repo into yum.repos.d"

yum install mongodb-org-shell -y &>>$LOGFILE

validations $?" Installing mongodb client"

mongo --host mongodb.awsdevops.site </app/schema/catalogue.js &>>$LOGFILE 

validations $? "Loading catalogue data into mongodb" 
