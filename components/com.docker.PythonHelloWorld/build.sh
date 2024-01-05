#!/bin/bash

set +e
find . -maxdepth 1 -type f -not -name "*.sh" -exec sed -i "s/{ECR_REPO}/$ECR_REPO/g" {} \;
gdk component build
find . -maxdepth 1 -type f -not -name "*.sh" -exec sed -i "s/$ECR_REPO/{ECR_REPO}/g" {} \;
set -e
