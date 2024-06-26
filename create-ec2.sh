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
        INSTANCE_TYPE="t3.medium"
    else
        INSTANCE_TYPE="t2.micro"
    fi
    echo "creating $i instance"
    IP_ADDRESS=$(aws ec2 run-instances --image-id $IMAGE_ID  --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')
    echo "created $i instance: $IP_ADDRESS")

    aws route53 change-resource-record-sets --hosted-zone-id Z098285010FMU6PDV8O9P --change-batch '
    {
            "Changes": [{
            "Action": "CREATE",
                        "ResourceRecordSet": {
                            "Name": "'$i.$DOMAIN_NAME'",
                            "Type": "A",
                            "TTL": 300,
                            "ResourceRecords": [{ "Value": "'$IP_ADDRESS'"}]
                        }}]
    }
    '
done

# imporvement
# check instance is already created or not
# update route53 record
    
