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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$LOGFILE

Validation $? "Run script to repo"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$LOGFILE

Validation $? "Configure repo for RabbitMQ"

yum install rabbitmq-server -y &>>$LOGFILE

Validation $? "Install RabbitMQ"

systemctl enable rabbitmq-server &>>$LOGFILE

Validation $? "Enable RabbitMQ"

systemctl start rabbitmq-server &>>$LOGFILE

Validation $? "Starting RabbitMQ"

rabbitmqctl add_user roboshop roboshop123 &>>$LOGFILE

Validation $? "Adding user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGFILE

Validation $? "Setting up permissions for user"