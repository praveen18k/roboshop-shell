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

yum install python36 gcc python3-devel -y &>>$LOGFILE

Validation $? "Installing python"

useradd roboshop &>>$LOGFILE

mkdir /app &>>$LOGFILE

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>>$LOGFILE

Validation $? " Downloading payment artifacts"

cd /app &>>$LOGFILE

Validation $? "Moving into app directory"

#unzip /tmp/payment.zip &>>$LOGFILE

Validation $? "Unzipping payment"

pip3.6 install -r requirements.txt &>>$LOGFILE

Validation $? "Insalling dependencies" 

cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service &>>$LOGFILE

Validation $? "Copying payment service"

systemctl daemon-reload &>>$LOGFILE

Validation $? "daemon reload"

systemctl enable payment &>>$LOGFILE

Validation $? "Enabling payment"

systemctl start payment &>>$LOGFILE

Validation $? "Starting payment"

