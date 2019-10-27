#!/bin/bash

set -e

if [ -t 0 ] ; then
    sudo service ssh start > /dev/null 2>&1
    sudo service docker start > /dev/null 2>&1
    bash -l
else
    sudo service ssh start > /dev/null 2>&1
    sudo /usr/bin/dockerd
fi
