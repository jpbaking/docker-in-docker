#!/bin/bash
cd $(dirname $(readlink -f $0))

BASE_VERSION='bionic-20191010'
BASE_SHORT_VERSION='18.04'
TAG="jpbaking/docker-in-docker"

set -x
docker build \
    --build-arg "BASE_VERSION=${BASE_VERSION}" \
    -t ${TAG} $(pwd -P)
docker tag ${TAG} ${TAG}:ubuntu-${BASE_VERSION}
docker tag ${TAG} ${TAG}:ubuntu-${BASE_SHORT_VERSION}
docker tag ${TAG} ${TAG}:ubuntu-latest
set +x

if [ 'yes' = "$(read -p 'Do you want to push (yes/NO)? ' yesno && echo -n "${yesno}")" ]; then
    set -x
    docker push ${TAG}:ubuntu-${BASE_VERSION}
    docker push ${TAG}:ubuntu-${BASE_SHORT_VERSION}
    docker push ${TAG}:ubuntu-latest
    docker push ${TAG}:latest
    set +x
fi