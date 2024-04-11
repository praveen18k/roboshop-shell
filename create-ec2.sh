#!/bin/bash

NAMES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "cart" "user" "shipping" "payments" " "web")
INSTANCE_TYPE=""
IMAGE=ami-0f3c7d07486cad139
SECURITY_GROUP_ID=sg-0fe71a2fcfe383dcc
DOMAIN_NAME=awsdevops.site

#if mysql or mongodb instance_type should be t3.medium, for all others it is t2.micro

 for i in "${NAMES[@]}"
 do
    if [[ $i == "mongodb" || $i == "mysql" ]]
    then
        INSTANCE_TYPE="t3.micro"