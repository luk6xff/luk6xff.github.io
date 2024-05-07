#!/bin/bash

#docker load < hello-world_linux_arm64.tar.gz
docker load < hello_world_linux_arm64.tar.gz
docker run hello-world:latest

