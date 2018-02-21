# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
FROM jupyter/pyspark-notebook

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

USER root

# RSpark config
ENV R_LIBS_USER $SPARK_HOME/R/lib
RUN fix-permissions $R_LIBS_USER

# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fonts-dejavu \
    tzdata \
    gfortran \
    gcc 

# custom settings
# various useful tools
RUN apt-get install -y tmux htop rsync git curl

# install dependencies for SHODAN: jdk, nodejs, SBT, scala
ENV SBT_VERSION 1.1.0
RUN apt-get install -y openjdk-8-jdk && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install -y nodejs && \
    curl -L -o sbt-$SBT_VERSION.deb \
    http://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
    dpkg -i sbt-$SBT_VERSION.deb && \
    rm sbt-$SBT_VERSION.deb && \
    apt-get install -y sbt scala

# install postgres and dependencies
RUN apt-get install -y imagemagick \
    postgresql \
    postgresql-contrib

# install lightning-server dependencies
RUN apt-get install -y libpq-dev \
    g++ \
    make && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# create postgres user and database for lightning-server
USER postgres

RUN /etc/init.d/postgresql start && \
    psql --command "create user jovyan with superuser password 'password'" && \
    psql --command 'create database "lightning-viz"' && \
    psql --command 'create database jovyan'

USER $NB_UID

# install high performance native bindings between node.js and PostgreSQL via libpq with a simple API
RUN npm i pg-native

# tell the installation to use postgres server (production mode)
ENV NODE_ENV production

# clone lightning-server source files, lock version to commit SHA
RUN git clone https://github.com/lightning-viz/lightning && \
    cd lightning && \
    git reset --hard d4d2d5fc6971a660df587950852d0384d459128d

# hacking in jovyan username and password settings by replacing modified database.js
ADD database.js lightning/config/database.js

# install the server
RUN cd lightning && npm install

# communication with ligthning plotting server
#EXPOSE 3000

# R packages
RUN conda install --quiet --yes \
    'r-base=3.3.2' \
    'r-irkernel=0.7*' \
    'r-ggplot2=2.2*' \
    'r-sparklyr=0.5*' \
    'r-rcurl=1.95*' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Apache Toree kernel
RUN pip install --no-cache-dir \
    https://dist.apache.org/repos/dist/dev/incubator/toree/0.2.0/snapshots/dev1/toree-pip/toree-0.2.0.dev1.tar.gz \
    && \
    jupyter toree install --sys-prefix && \
    rm -rf /home/$NB_USER/.local && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Spylon-kernel
RUN conda install --quiet --yes 'spylon-kernel=0.4*' && \
    conda clean -tipsy && \
    python -m spylon_kernel install --sys-prefix && \
    rm -rf /home/$NB_USER/.local && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER
