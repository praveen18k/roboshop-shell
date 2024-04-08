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

yum install maven -y &>>$LOGFILE

Validation $? "Installing maven"

useradd roboshop &>>$LOGFILE

mkdir /app &>>$LOGFILE

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>>$LOGFILE

Validation $? "Downloading shipping artifacts"

cd /app &>>$LOGFILE

Validation $? "Moving to app directory"

unzip /tmp/shipping.zip &>>$LOGFILE

Validation $? "Unzipping shipping"

mvn clean package &>>$LOGFILE

Validation $? "Packaging shipping app"

mv target/shipping-1.0.jar shipping.jar &>>$LOGFILE

Validation $? "Renaming shipping jar"

cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service &>>$LOGFILE

Validation $? "Copying shipping.service"

systemctl daemon-reload &>>$LOGFILE

Validation $? "deamon-reload"

systemctl start shipping &>>$LOGFILE

Validation $? "Starting shipping"

yum install mysql -y &>>$LOGFILE

Validation $? "Installing mysql client"

mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>$LOGFILE

Validation $? "Loading countries and cities info"

systemctl restart shipping &>>$LOGFILE

Validation $? "Restart shipping"