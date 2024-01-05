#!/bin/bash
set -e

source .env

echo "########## PUBLISH DOCKER IMAGES ##########"
for DIR in $(ls docker)
do
    echo "Publishing $DIR"
    pushd docker/$DIR
    source ./publish.sh
    popd
    echo "$DIR publish complete"
done
echo "########## FINISHED DOCKER PUBLISH ##########"

echo "########## PUBLISH GREENGRASS COMPONENTS ##########"
for DIR in $(ls components)
do
    echo "Publishing $DIR"
    pushd components/$DIR
    gdk component publish
    popd
    echo "$DIR publish complete"
done
echo "########## FINISHED GREENGRASS PUBLISH ##########"

echo "All publishing complete!"
