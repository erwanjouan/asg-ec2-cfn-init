#!/bin/bash

getLatestInstanceId(){
  aws ec2 describe-instances  \
    --query 'Reservations[].Instances[].{id: InstanceId, ip: PublicIpAddress, tm: LaunchTime}' \
    | jq -r 'sort_by(.tm) | reverse | .[0].id'
}

getStatus(){
  local instance_id=$1
  aws ec2 describe-instances \
          --instance-ids $instance_id \
          --query "Reservations[0].Instances[0].State.Name" \
          --output text
}

getPublicIp(){
  local instance_id=$1
  aws ec2 describe-instances \
          --instance-ids $instance_id \
          --query "Reservations[0].Instances[0].PublicIpAddress" \
          --output text
}

latest_instance_id=$(getLatestInstanceId)
echo ec2 instance ${latest_instance_id}

status=$(getStatus ${latest_instance_id})
echo status $status

if [ "${status}" != "terminated" ]
then
  while [ "${status}" != "running" ]
  do
          status=$(getStatus ${latest_instance_id})
          printf "|||"
          sleep 5
  done
  publicIp=$(getPublicIp ${latest_instance_id})
  ssh -i ../k2.pem $publicIp
fi
