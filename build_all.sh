#!/bin/bash
set -e

source .env

echo "########## BUILD DOCKER IMAGES ##########"
for DIR in $(ls docker)
do
    echo "Building $DIR"
    pushd docker/$DIR
    source ./build.sh
    popd
    echo "$DIR build complete"
done
echo "########## FINISHED DOCKER BUILD ##########"

echo "########## BUILD GREENGRASS COMPONENTS ##########"
for DIR in $(ls components)
do
    echo "Building $DIR"
    pushd components/$DIR
    source ./build.sh
    popd
    echo "$DIR build complete"
done
echo "########## FINISHED GREENGRASS BUILD ##########"

echo "All builds complete. Run ./publish_all.sh to publish components and Docker images."
