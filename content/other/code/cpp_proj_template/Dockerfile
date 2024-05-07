FROM alpine:latest

# Install build dependencies
RUN apk update && apk add --no-cache \
    g++ \
    && rm -rf /var/cache/apk/*

# Copy the source code
COPY main.cpp /app/

# Set the working directory
WORKDIR /app/

# Compile the C++ code
RUN g++ -o hello main.cpp

# Run the compiled binary
CMD ["./hello"]
