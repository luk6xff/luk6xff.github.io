#!/bin/bash

# Script: run.sh
# Description: This script builds and runs the blog static site generation.
#              It's used by .github/workflows/main.yml to build and serve the site
#              where docker is not needed
# Usage: ./run_no_docker.sh
# Author: luk6xxf
# Date: 2024-03-07


# Set permissions
chmod a+x build.sh

# Install needed packages
curl https://sh.rustup.rs -sSf | sh
cargo install mdbook
snap install --edge zola

# Run the build script
./build.sh -b
