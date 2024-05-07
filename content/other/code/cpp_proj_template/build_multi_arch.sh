#!/bin/bash

# Define the output folder
output_folder="output"
mkdir -p ${output_folder}

# Create the builder (if not already created)
docker buildx create --name my_builder --driver=docker-container --use

# Start the builder instance
docker buildx inspect --bootstrap

# Build the multi-architecture images and load it into local Docker daemon
image_tag="latest"

# Build for amd64
image_name="hello-world-amd64"
docker buildx build --builder=my_builder --platform linux/amd64 -t ${image_name}:${image_tag} --output="type=docker,push=false,dest=${output_folder}/${image_name}.tar" .
docker load --input ${output_folder}/${image_name}.tar

# # Build for arm64
image_name="hello-world-arm64"
docker buildx build --builder=my_builder --platform linux/arm64 -t ${image_name}:${image_tag} --output="type=docker,push=false,dest=${output_folder}/${image_name}.tar" .
docker load --input ${output_folder}/${image_name}.tar
