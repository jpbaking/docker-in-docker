#!/bin/bash
cd $(dirname $(readlink -f $0))

BASE_VERSION='bionic-20191010'
BASE_SHORT_VERSION='18.04'

TAG="jpbaking/docker-in-docker"

set -x
docker build \
    --build-arg "BASE_VERSION=${BASE_VERSION}" \
    --build-arg "APT_UBUNTU_ARCHIVE=http://192.168.56.107/repository/public-apt-proxy-archive.ubuntu.com" \
    --build-arg "APT_UBUNTU_SECURITY=http://192.168.56.107/repository/public-apt-proxy-security.ubuntu.com/" \
    --build-arg "APT_DOCKER_CE=http://192.168.56.107/repository/public-apt-proxy-download.docker.com" \
    --build-arg "PYPI_URL=http://192.168.56.107/repository/public-pypi-group" \
    -t ${TAG}:ubuntu-${BASE_VERSION} \
    -t ${TAG}:ubuntu-${BASE_SHORT_VERSION} \
    -t ${TAG}:ubuntu-latest \
    -t ${TAG}:latest \
    $(pwd -P)
set +x

if [ 'yes' = "$(read -p 'Do you want to push (yes/NO)? ' yesno && echo -n "${yesno}")" ]; then
    set -x
    docker push ${TAG}:ubuntu-${BASE_VERSION}
    docker push ${TAG}:ubuntu-${BASE_SHORT_VERSION}
    docker push ${TAG}:ubuntu-latest
    docker push ${TAG}:latest
    set +x
fi