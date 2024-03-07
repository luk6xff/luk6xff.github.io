#!/bin/bash

# Script: run.sh
# Description: This script builds and runs a Docker container for the blog static site generation.
#              It checks if the Docker image exists, builds it if not, and then runs the container
#              with options to mount the current directory and execute build.sh script.
# Usage: ./run.sh [-b|-s]
#        -b: Build the luk6xff's blog site
#        -s: Serve the luk6xff's blog site
# Author: luk6xxf
# Date: 2024-03-07


################################################################################
###  NOTE!!! Modify this only when a new image has been created!
################################################################################
DOCKER_TAG="0.1"
DOCKER_IMG="luk6xxf_blog_builder"
DOCKER_IMG_TO_RUN="${DOCKER_IMG}:${DOCKER_TAG}"

# Search for docker image
image_query=$( docker images -q "${DOCKER_IMG_TO_RUN}" )

if [[ -n "${image_query}" ]]; then
    echo "Docker image: ["${DOCKER_IMG_TO_RUN}"] exists"
else
    echo "Docker image not found, attempting to build image from Dockerfile"
    # Build the Docker image
    docker build -t ${DOCKER_IMG_TO_RUN} \
                    -f Dockerfile . || { echo "Error: Failed to build ${DOCKER_IMG_TO_RUN} image."; exit 1; }
    echo ">>> Docker image: ${DOCKER_IMG_TO_RUN} has been built successfully! <<<"
fi

# Run docker container
echo >&2 "Running ${DOCKER_IMG_TO_RUN} docker container..."

# Run the Docker image
chmod a+x build.sh
docker rm -f $(docker ps -a -q) || true
docker run -u "$(id -u):$(id -g)" -v $PWD:/app --workdir /app -p 8080:8080 -p 1024:1024 ${DOCKER_IMG_TO_RUN} $@
