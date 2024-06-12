#!/bin/bash

# Configure AWS CLI
aws configure

#AWS Access Key ID [None]: 767397690221
#AWS Secret Access Key [None]: AKIA3FLDXPNWYIUHAFKW
#Default region name [None]: us-east-1
#Default output format [None]: JSON

#Key Pair
aws ec2 create-key-pair --key-name abelkeypair --query 'KeyMaterial' --output text > abelkeypair.pem
chmod 400 abelkeypair.pem

#Allow SSH Access
aws ec2 authorize-security-group-ingress --group-id $SECURITY_GROUP_ID --protocol tcp --port 22 --cidr 0.0.0.0/0

#Create EBS Volume
VOLUME_ID=$(aws ec2 create-volume --volume-type gp2 --size 10 --availability-zone us-east-1a --query 'VolumeId' --output text)

#EC2 Instance ubuntu 24.04 LTS
INSTANCE_ID=$(aws ec2 run-instances --image-id ami-04b70fa74e45c3917 --count 1 --instance-type t2.micro --key-name abelkeypair --security-group-ids $SECURITY_GROUP_ID --query 'Instances[0]>

#Attach EBS Volume to EC2 Instance
aws ec2 attach-volume --volume-id $VOLUME_ID --instance-id $INSTANCE_ID --device /dev/sdb
