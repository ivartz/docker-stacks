#!/bin/bash

workdir=/media/loek/HD/Cyborg

# buiild it
docker build -t datascience_container .

# run it
docker run -ti --rm --user root -e NB_UID=$(id -u $USER) -e NB_GID=$(id -g $USER) -e GRANT_SUDO=yes -v $workdir:/home/jovyan/work -p 20000:8888 -p 3000:3000 datascience_container start.sh bash

