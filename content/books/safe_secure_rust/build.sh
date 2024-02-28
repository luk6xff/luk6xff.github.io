#!/bin/sh

cargo install mdbook
mdbook build
mdbook serve
