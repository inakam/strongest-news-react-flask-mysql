#!/bin/sh
pwd
ls
echo $1
cat ./docker-compose_codepipeline.yml | awk -v FLASKID=$1 '{ if (gsub(/_FLASK/, FLASKID)){ print $0 > "./docker-compose_codepipeline.yml" } else { print $0 > "./docker-compose_codepipeline.yml" }  }'
cat ./docker-compose_codepipeline.yml | awk -v REACTID=$2 '{ if (gsub(/_REACT/, REACTID)){ print $0 > "./docker-compose_codepipeline.yml" } else { print $0 > "./docker-compose_codepipeline.yml" }  }'
cat ./docker-compose_codepipeline.yml | awk -v NGINXID=$3 '{ if (gsub(/_NGINX/, NGINXID)){ print $0 > "./docker-compose_codepipeline.yml" } else { print $0 > "./docker-compose_codepipeline.yml" }  }'
cat ./docker-compose_codepipeline.yml | awk -v MYSQLID=$4 '{ if (gsub(/_MYSQL/, MYSQLID)){ print $0 > "./docker-compose_codepipeline.yml" } else { print $0 > "./docker-compose_codepipeline.yml" }  }'
cat ./docker-compose_codepipeline.yml