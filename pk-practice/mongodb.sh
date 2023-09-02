#!/bin/bash

#user should have root access if not display warning message in terminal 
#while installing store the logs
##implement colors for user experience
#before installing it is always good to check whether package is already installed or not
#if installed skip, otherwise proceed for installation
#check successfully installed or not

DATE=$(date +%F)
SCRIPT_NAME=$0
LOGSDIR=/tmp
LOGFILE=$LOGSDIR/$0-$DATE.log
USERID=$(id -u)

R="\e[31m"
G="\e[32m"
N="\e[0"
Y="\e[33"


if [ $USERID -ne 0 ];
then
    echo -e "$Y ERROR: Install with root access $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ];
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

yum install git -y &>> $LOGFILE

VALIDATE $? "Installation of Git"

    
