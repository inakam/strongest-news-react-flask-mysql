#!/bin/sh
pwd
ls
TMP=$(aws ecs describe-task-definition --task-definition $1 | jq '.taskDefinition | .taskDefinitionArn ')
TASK=$(echo $TMP | sed 's/\"//g')
cat ./appspec.yaml | awk -v TASK=${TASK} '{ if (gsub(/_TASK_DEF_ARN/, TASK)){ print $0 > "./appspec.yaml" } else { print $0 > "./appspec.yaml" }  }'
cat ./appspec.yaml