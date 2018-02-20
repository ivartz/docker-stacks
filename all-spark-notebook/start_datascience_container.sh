#!/bin/bash

docker run --user root -e NB_UID=$(id -u $USER) -e NB_GID=$(id -g $USER) -e GRANT_SUDO=yes -v /home/loek/.jupyter:/etc/ssl/notebook -v $"pwd":/home/jovyan/work -p 8888:8888 -p 30000:3000 datascience_container start-notebook.sh --NotebookApp.keyfile=/etc/ssl/notebook/mycert.pem --NotebookApp.certfile=/etc/ssl/notebook/mycert.pem --NotebookApp.password='sha1:832eed7478e2:4f26774c296b0cb8fa950c11edc8a42e43ead533'
