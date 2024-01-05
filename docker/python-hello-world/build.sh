#!/bin/bash
set -e

docker build -t $ECR_REPO/python-hello-world:latest .
