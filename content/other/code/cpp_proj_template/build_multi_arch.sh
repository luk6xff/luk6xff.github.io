#!/bin/bash

# Define the output folder
output_folder="output"

# Create the builder (if not already created)
docker buildx create --name my_builder

# Use the builder for subsequent builds
docker buildx use my_builder

# Build the multi-architecture image and load it into local Docker daemon
docker buildx build --platform linux/amd64,linux/arm64 -t hello-world --output "type=local,dest=${output_folder}" .
#docker buildx build --load -t hello-world:latest .
docker save -o hello-world_latest.tar.gz hello-world:latest


# # Iterate through the subfolders in the output folder
# for subfolder in "$output_folder"/*/; do
#     # Extract the subfolder name
#     subfolder_name=$(basename "$subfolder")
#     # Define the output filename
#     output_file="hello_world_$subfolder_name.tar.gz"
#     # Create the .tar.gz archive
#     tar -czf "$output_folder/$output_file" -C "$output_folder" "$subfolder_name"
#     echo "Archive created: $output_file"
# done
