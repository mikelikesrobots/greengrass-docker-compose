#!/bin/bash
set -e

REGION=$(echo $ECR_REPO | cut -d'.' -f4)
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_REPO
docker push $ECR_REPO/python-hello-world:latest
