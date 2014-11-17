#/bin/bash

set -eo pipefail

confd -onetime

docker-registry &
confd &
CONFIG_FILE=`md5sum /docker-registry/config/registry-config.yml`
echo $CONFIG_FILE
while [ 1 ]
do     
    DOCKER_PID=`ps -ef | grep docker-registry | grep -v grep | awk '{ print $2 }'`
    NEW_FILE=`md5sum /docker-registyr/config/registry-config.yml`
    if [ "$NEW_FILE" != "$CONFIG_FILE" ]
    then
        kill $DOCKER_PID
        docker-registry &
    fi
    CONFIG_FILE="$NEW_FILE"
    sleep 60
