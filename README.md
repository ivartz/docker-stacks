# docker-stacks
A fork from:
https://github.com/jupyter/docker-stacks/tree/master/all-spark-notebook
with a modified all-spark-notebook for cooperating with SHODAN, Software from NTNU Cyborg
https://github.com/PeterAaser/SHODAN

[![Build Status](https://travis-ci.org/jupyter/docker-stacks.svg?branch=master)](https://travis-ci.org/jupyter/docker-stacks)
[![Join the chat at https://gitter.im/jupyter/jupyter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/jupyter/jupyter?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Opinionated stacks of ready-to-run Jupyter applications in Docker.

## Quick Start

If you're familiar with Docker, have it configured, and know exactly what you'd like to run, one of these commands should get you up and running:

```
# Run an ephemeral Jupyter Notebook server in a Docker container in the terminal foreground.
# Note that any work saved in the container will be lost when it is destroyed with this config.
# -ti: pseudo-TTY+STDIN open.
# -rm: remove the container on exit.
# -p: publish port to the host
docker run -ti --rm -p 8888:8888 jupyter/<your desired stack>:<git-sha-tag>

# Run a Jupyter Notebook server in a Docker container in the terminal foreground.
# Any files written to ~/work in the container will be saved to the current working
# directory on the host.
docker run -ti --rm -p 8888:8888 -v "$PWD":/home/jovyan/work jupyter/<your desired stack>:<git-sha-tag>

# Run an ephemeral Jupyter Notebook server in a Docker container in the background.
# Note that any work saved in the container will be lost when it is destroyed with this config.
# -d: detach, run container in background.
# -P: Publish all exposed ports to random ports
docker run -d -P jupyter/<your desired stack>:<git-sha-tag>
```

## Getting Started

If this is your first time using Docker or any of the Jupyter projects, do the following to get started.

1. [Install Docker](https://docs.docker.com/installation/) on your host of choice.
Preferably Docker CE.

Since docker binds to a Unix socket, 
it needs to run as root.
The easiest is to run docker with sudo.

(start, Optional)
For running docker as non root,
your user needs to be added to the
docker group:
```bash
# Create a group called docker:
sudo groupadd docker

# add your user to the group docker
sudo usermod -aG docker $USER
# a log out and log in is necessary to re-evaluate user memberships.
# Since you don't want to do this, a workaround is 
(https://superuser.com/questions/272061/reload-a-linux-users-group-assignments-without-logging-out)
# Get the id of your current group, remember it
id -g
# switch to the docker group as primary for your user
newgrp docker
# switch back to the original group, using the group id 
# previously returned by id -g. In my case, it was
newgrp 1001
# Now you can finally run docker as non root without a re-login
```
(end, optional)

2. Open the README in one of the folders in this git repository.
3. Follow the README for that stack.

For running the modified all-spark-notebook:
- Clone the repository and cd to the all-spark-notebook directory
```bash
git clone https://github.com/ivartz/docker-stacks
cd all-spark-notebook
```
- Build a docker image called datascience_container
based on the file Dockerfile
```bash
docker build -t datascience_container .
# run the container
docker run --user root -e NB_UID=$(id -u $USER) -e NB_GID=$(id -g $USER) -e GRANT_SUDO=yes -v /home/loek/.jupyter:/etc/ssl/notebook -v $"pwd":/home/jovyan/work -p 8888:8888 -p 30000:30000 datascience_container start-notebook.sh --NotebookApp.keyfile=/etc/ssl/notebook/mycert.pem --NotebookApp.certfile=/etc/ssl/notebook/mycert.pem --NotebookApp.password='sha1:832eed7478e2:4f26774c296b0cb8fa950c11edc8a42e43ead533'
```

## Visual Overview

Here's a diagram of the `FROM` relationships between all of the images defined in this project:

[![Image inheritance diagram](internal/inherit-diagram.svg)](http://interactive.blockdiag.com/?compression=deflate&src=eJyFzTEPgjAQhuHdX9Gws5sQjGzujsaYKxzmQrlr2msMGv-71K0srO_3XGud9NNA8DSfgzESCFlBSdi0xkvQAKTNugw4QnL6GIU10hvX-Zh7Z24OLLq2SjaxpvP10lX35vCf6pOxELFmUbQiUz4oQhYzMc3gCrRt2cWe_FKosmSjyFHC6OS1AwdQWCtyj7sfh523_BI9hKlQ25YdOFdv5fcH0kiEMA)

[Click here for a commented build history of each image, with references to tag/SHA values.](https://github.com/jupyter/docker-stacks/wiki/Docker-build-history)

The following are quick-links to READMEs about each image and their Docker image tags on Docker Cloud:

* base-notebook: [README](https://github.com/jupyter/docker-stacks/tree/master/base-notebook), [SHA list](https://hub.docker.com/r/jupyter/base-notebook/tags/)
* minimal-notebook: [README](https://github.com/jupyter/docker-stacks/tree/master/minimal-notebook), [SHA list](https://hub.docker.com/r/jupyter/minimal-notebook/tags/)
* scipy-notebook: [README](https://github.com/jupyter/docker-stacks/tree/master/scipy-notebook), [SHA list](https://hub.docker.com/r/jupyter/scipy-notebook/tags/)
* r-notebook: [README](https://github.com/jupyter/docker-stacks/tree/master/r-notebook), [SHA list](https://hub.docker.com/r/jupyter/r-notebook/tags/)
* tensorflow-notebook: [README](https://github.com/jupyter/docker-stacks/tree/master/tensorflow-notebook), [SHA list](https://hub.docker.com/r/jupyter/tensorflow-notebook/tags/)
* datascience-notebook: [README](https://github.com/jupyter/docker-stacks/tree/master/datascience-notebook), [SHA list](https://hub.docker.com/r/jupyter/datascience-notebook/tags/)
* pyspark-notebook: [README](https://github.com/jupyter/docker-stacks/tree/master/pyspark-notebook), [SHA list](https://hub.docker.com/r/jupyter/pyspark-notebook/tags/)
* all-spark-notebook: [README](https://github.com/jupyter/docker-stacks/tree/master/all-spark-notebook), [SHA list](https://hub.docker.com/r/jupyter/all-spark-notebook/tags/)

## Stacks, Tags, Versioning, and Progress

Starting with [git commit SHA 9bd33dcc8688](https://github.com/jupyter/docker-stacks/tree/9bd33dcc8688):

* Nearly every folder here on GitHub has an equivalent `jupyter/<stack name>` on Docker Hub (e.g., all-spark-notebook &rarr; jupyter/all-spark-notebook).
* The `latest` tag in each Docker Hub repository tracks the `master` branch `HEAD` reference on GitHub.
  This is a moving target and will make backward-incompatible changes regularly.
* Any 12-character image tag on Docker Hub refers to a git commit SHA here on GitHub. See the [Docker build history wiki page](https://github.com/jupyter/docker-stacks/wiki/Docker-build-history) for a table of build details.
* Stack contents (e.g., new library versions) will be updated upon request via PRs against this project.
* Users looking for reproducibility or stability should always refer to specific git SHA tagged images in their work, not `latest`.
* For legacy reasons, there are two additional tags named `3.2` and `4.0` on Docker Hub which point to images prior to our versioning scheme switch.

## Other Tips and Known Issues

- If you haven't already, pin your image to a tag, e.g. `FROM jupyter/scipy-notebook:7c45ec67c8e7`.
  `latest` is a moving target which can change in backward-incompatible ways as packages and operating systems are updated.
* Python 2.x was [removed from all images](https://github.com/jupyter/docker-stacks/pull/433) on August 10th, 2017, starting in tag `cc9feab481f7`. If you wish to continue using Python 2.x, pin to tag `82b978b3ceeb`.
* `tini -- start-notebook.sh` is the default Docker entrypoint-plus-command in every notebook stack. If you plan to modify it in any way, be sure to check the *Notebook Options* section of your stack's README to understand the consequences.
* Every notebook stack is compatible with [JupyterHub](https://jupyterhub.readthedocs.io) 0.5 or higher.  When running with JupyterHub, you must override the Docker run command to point to the [start-singleuser.sh](base-notebook/start-singleuser.sh) script, which starts a single-user instance of the Notebook server.  See each stack's README for instructions on running with JupyterHub.
* Check the [Docker recipes wiki page](https://github.com/jupyter/docker-stacks/wiki/Docker-Recipes) attached to this project for information about extending and deploying the Docker images defined here. Add to the wiki if you have relevant information.
* The pyspark-notebook and all-spark-notebook stacks will fail to submit Spark jobs to a Mesos cluster when run on Mac OSX due to https://github.com/docker/for-mac/issues/68.

## Maintainer Workflow

**To build new images on Docker Cloud and publish them to the Docker Hub registry, do the following:**

1. Make sure Travis is green for a PR.
2. Merge the PR.
3. Monitor the Docker Cloud build status for each of the stacks, starting with [jupyter/base-notebook](https://cloud.docker.com/app/jupyter/repository/docker/jupyter/base-notebook/general) and ending with [jupyter/all-spark-notebook](https://cloud.docker.com/app/jupyter/repository/docker/jupyter/all-spark-notebook/general).
    * See the stack hierarchy diagram for the current, complete build order.
4. Manually click the retry button next to any build that fails to resume that build and any dependent builds.
5. Avoid merging another PR to master until all outstanding builds complete.
    * There's no way at present to propagate the git SHA to build through the Docker Cloud build trigger API. Every build trigger works off of master HEAD.

**When there's a security fix in the Ubuntu base image, do the following in place of the last command:**

Update the `ubuntu:16.04` SHA in the most-base images (e.g., base-notebook). Submit it as a regular PR and go through the build process. Expect the build to take a while to complete: every image layer will rebuild.

**When there's a new stack definition, do the following before merging the PR with the new stack:**

1. Ensure the PR includes an update to the stack overview diagram in the top-level README.
    * The source of the diagram is included in the alt-text of the image. Visit that URL to make edits.
2. Ensure the PR updates the Makefile which is used to build the stacks in order on Travis CI.
3. Create a new repoistory in the `jupyter` org on Docker Cloud named after the stack folder in the git repo.
4. Grant the `stacks` team permission to write to the repo.
5. Click *Builds* and then *Configure Automated Builds* for the repository.
6. Select `jupyter/docker-stacks` as the source repository.
7. Choose *Build on Docker Cloud's infrastructure using a Small node* unless you have reason to believe a bigger host is required.
8. Update the *Build Context* in the default build rule to be `/<name-of-the-stack>`.
9. Toggle *Autobuild* to disabled unless the stack is a new root stack (e.g., like `jupyter/base-notebook`).
10. If the new stack depends on the build of another stack in the hierarchy:
    1. Hit *Save* and then click *Configure Automated Builds*.
    2. At the very bottom, add a build trigger named *Stack hierarchy trigger*.
    3. Copy the build trigger URL.
    4. Visit the parent repository *Builds* page and click *Configure Automated Builds*.
    5. Add the URL you copied to the *NEXT_BUILD_TRIGGERS* environment variable comma separated list of URLs, creating that environment variable if it does not already exist.
    6. Hit *Save*.
11. If the new stack should trigger other dependent builds:
    1. Add an environment variable named *NEXT_BUILD_TRIGGERS*.
    2. Copy the build trigger URLs from the dependent builds into the *NEXT_BUILD_TRIGGERS* comma separated list of URLs.
    3. Hit *Save*.
12. Adjust other *NEXT_BUILD_TRIGGERS* values as needed so that the build order matches that in the stack hierarchy diagram.

**When there's a new maintainer, do the following:**

1. Visit https://cloud.docker.com/app/jupyter/team/stacks/users
2. Add the new maintainer user name.

**If automated builds have got you down, do the following:**

1. Clone this repository.
2. Check out the git SHA you want to build and publish.
3. `docker login` with your Docker Hub/Cloud credentials.
4. Run `make retry/release-all`.

When `make retry/release-all` successfully pushes the last of its images to Docker Hub (currently `jupyter/all-spark-notebook`), Docker Hub invokes [the webhook](https://github.com/jupyter/docker-stacks/blob/master/internal/docker-stacks-webhook/) which updates the [Docker build history](https://github.com/jupyter/docker-stacks/wiki/Docker-build-history) wiki page.
