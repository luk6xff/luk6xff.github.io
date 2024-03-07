# Use the official Zola image as a base
FROM ghcr.io/getzola/zola:v0.18.0 as zola

FROM rust:slim-bookworm
COPY --from=zola /bin/zola /bin/zola

# Set working directory
WORKDIR /app


# Install mdbook
RUN cargo install mdbook

# Set the entrypoint to the build script
ENTRYPOINT ["/app/build.sh"]
