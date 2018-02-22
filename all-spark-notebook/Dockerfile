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
# passwordless sudo access for jovyan
RUN apt-get install -y tmux \
    htop \
    rsync \
    git \
    curl \
    sudo && \
    usermod -aG sudo jovyan && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# install dependencies for SHODAN: jdk, SBT, scala
ENV SBT_VERSION 1.1.0
ENV SCALA_VERSION 2.11.8
RUN apt-get install -y openjdk-8-jdk && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install -y nodejs && \
    curl -L -o sbt-$SBT_VERSION.deb \
    http://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
    dpkg -i sbt-$SBT_VERSION.deb && \
    rm sbt-$SBT_VERSION.deb && \
    apt-get install -y sbt && \
    curl -L -O https://downloads.lightbend.com/scala/2.11.8/scala-2.11.8.deb && \
    dpkg -i scala-2.11.8.deb && \
    rm scala-2.11.8.deb

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

# hacking in jovyan username and password settings by modifying database.js
ADD lightning-server-database.js database_temp.js

# cat in order to avoid permission errors
# that would have resulted from copying the file
RUN cat database_temp.js > lightning/config/database.js && \
    rm database_temp.js

# install lightning-server. postgresql has to run in order for it to pass a test (not important)
RUN sudo /etc/init.d/postgresql start && \
    cd lightning && \
    npm install

# add launch script for lightning-server
ADD start-lightning-server.sh start-lightning-server.sh
RUN sudo chmod +x start-lightning-server.sh

# lightning scala client
# build the lightning-scala jar in target folder inside lightning-scala repository
# make a copy of the jar for easier later use.

# temporarily start postgresql server in order
# to temporarily start lightning server in order
# to have lightning-scala pass its tests
RUN bash start-lightning-server.sh && \
    git clone https://github.com/ivartz/lightning-scala && \
    cd lightning-scala && \
    git reset --hard 82fc384d331589f9835c81cbeb2abd27142efa33 && \
    sbt assembly && \
    cp target/scala-2.11/lightning-scala-assembly-0.1.0-SNAPSHOT.jar target/scala-2.11/lsa.jar

# lightning python client
RUN pip install lightning-python

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

# jupyter-scala kernel https://github.com/jupyter-scala/jupyter-scala
RUN git clone https://github.com/jupyter-scala/jupyter-scala && \
    cd jupyter-scala && \
    git reset --hard 98bac7034f07e3e51d101846953aecbdb7a4bb5d && \
    bash jupyter-scala

# add SSL certificate that will be used by jupyter in start-notebook-custom.sh
ADD mycert.pem mycert.pem
RUN sudo chown jovyan mycert.pem

# add custom jupuyter launch script
ADD start-notebook-custom.sh start-notebook-custom.sh
RUN sudo chown jovyan start-notebook-custom.sh && \
    chmod +x start-notebook-custom.sh

