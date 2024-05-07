+++
title="My C/C++ project template"
date=2022-12-19

[taxonomies]
categories = ["cpp"]
tags = ["cpp","docker"]
+++


## Intro
Today I'll explore how Docker facilitates the creation of reproducible and isolated Linux environments, accelerating the testing, debugging, and deployment phases of C++ applications. By harnessing the capabilities of Docker, C++ programmers can ensure consistency across development, testing, and production environments, ultimately enhancing productivity and software reliability. My complete environment containing example application available as always on [my github](https://github.com/luk6xff/cpp-project-template).

## Understanding Docker

Docker is a platform that uses containerization to package and run applications in isolated environments called containers. These containers are lightweight and portable, containing everything needed to run the application, including code, runtime, system tools, libraries, and settings. Under the hood, Docker leverages several Linux kernel features, such as cgroups (control groups) for resource isolation, namespaces for process isolation, and UnionFS (Union File System) for layering file systems.

**Key Components of Docker:**

1. **Docker Daemon (`dockerd`):** This is the persistent background process running on the host machine. It listens for Docker API requests and manages Docker objects such as images, containers, networks, and volumes.

2. **Docker Client (`docker`):** The primary interface through which users interact with Docker. It sends commands to the Docker daemon using the Docker API.

3. **Docker Images:** Immutable snapshots containing the application, its dependencies, and configurations. These images are built using Dockerfiles and stored in a local registry or a remote repository like Docker Hub.

4. **Docker Containers:** Instances of Docker images that run as isolated processes on the host machine. Each container operates in its own isolated environment, providing security and preventing conflicts between applications and their dependencies.

**Linux Mechanisms Leveraged by Docker:**

- **cgroups (Control Groups):** Used for resource isolation, allowing Docker to limit and prioritize CPU, memory, disk I/O, and other resources for containers.
- **Namespaces:** Used for process isolation, providing each container with its own namespace for processes, network interfaces, file systems, and more.
Key namespaces utilized by Docker include:
    - PID Namespace: Isolates process IDs, enabling containers to maintain separate process trees.
    - NET Namespace: Isolates network-related resources like interfaces and firewall rules.
    - IPC Namespace: Isolates Inter-Process Communication resources.
    - MNT Namespace: Manages mount points, allowing containers to have distinct filesystems.
    - UTS Namespace: Isolates host and domain names, creating a unique identity for containers.
- **UnionFS (Union File System):** Used for layering file systems, enabling Docker to create images efficiently by layering changes on top of existing file systems.

**Diagrams of Docker Environment on Linux:**

```
+---------------------+
|     Dockerfile      |
| (Build Instructions)|
|                     |
|  +-----------------+
|  | Instructions    |
|  | for building    |
|  | the image       |
|  | ...             |
|  +-----------------+
|  Defines the environment and configuration for the  |
|  Docker image.                                   |
+------------------------------------------------------+
           |
           |
           |
           v
+---------------------+
|   Docker Images     |
|                     |
|  +-----------------+
|  | Base OS Image   |
|  | Application     |
|  | Dependencies    |
|  | Configuration   |
|  | ...             |
|  +-----------------+
|    Immutable snapshots containing the             |
|    application, its dependencies, and configurations. |
+------------------------------------------------------+
           |
           |
           |
           v
+---------------------+
|  Docker Containers  |
|                     |
|  +-----------------+
|  | Running         |
|  | Application     |
|  | Instances       |
|  | ...             |
|  +-----------------+
|    Running instances of Docker images.                |
+------------------------------------------------------+
           |
           |
           |
           v
+---------------------+    Docker Daemon
|  Docker Client      | <--------------------------+
|  (User Interface)   |                             |
+---------------------+                             |
|  User-facing command-line interface for Docker.     |
+----------------------------------------------------+
           |
           |
           |
           v
+---------------------+
|      Docker Daemon  |  <------------------------------------+
+---------------------+                                       |
|  Persistent process running on the host machine.            |
|  Manages Docker objects such as images, containers,         |
|  networks, and volumes.                                      |
+--------------------------------------------------------------+
           |
           |
           |
           v
+---------------------+-----------------------------+
|      containerd     |                             |
|  (Container Runtime)|                             |
|                     |                             |
|  +-----------------+|                             |
|  |    runc         ||                             |
|  | (Container Tool)||                             |
|  +-----------------+|                             |
|  Manages container lifecycle tasks, including     |
|  creation, execution, and destruction.              |
+------------------------------------------------------+

```
This diagram illustrates the core components of the Docker environment on a Linux system, including the Docker daemon, containers, images, and Dockerfile used for building images.

When executing Docker commands, a following sequence of interactions occurs:
```
+---------------------+
|   Docker Client     |
|   (User Interface)  |
+---------------------+
           |
           |
           | Docker Commands
           v
+---------------------+
|   Docker Daemon     |
|      (dockerd)      |
+---------------------+
           |
           |
           | Container Management Tasks
           v
+---------------------+
|      containerd     |
|  (Container Runtime)|
+---------------------+
           |
           |
           | Container Management (utilizes namespaces, cgroups, and runc)
           v
+---------------------+
|        runc         |
|  (Container Tool)   |
+---------------------+
```

## Setting Up Docker for C/C++ Development

Setting up Docker for C/C++ development involves installing Docker on your development machine, understanding the basics of Dockerfile for defining the development environment, and creating a Docker image tailored for C/C++ development.

**Installing Docker on Your Development Machine:**

First, you need to install Docker on your development machine. There are different ways to install Docker, depending on your operating system.

- **Docker Desktop:** Docker Desktop is a convenient solution for developers working on Windows or macOS. It includes Docker Engine, Docker CLI client, Docker Compose, Docker Content Trust, Kubernetes, and Credential Helper.

  Follow the instructions provided on the [Docker Desktop website](https://www.docker.com/products/docker-desktop) to download and install Docker Desktop for your operating system.

- **Docker Engine:** Docker Engine is the core technology behind Docker containers. It's available for various Linux distributions and is typically installed via package managers like apt or yum.

  Follow the instructions provided on the [Docker Engine website](https://docs.docker.com/engine/install/) to install Docker Engine on your Linux distribution.

**Basics of Dockerfile:**

Create a new directory for your C/C++ project and navigate into it:

```bash
mkdir my_cpp_project
cd my_cpp_project
```

Inside your project directory, create a new file named `Dockerfile` using a text editor of your choice:

```bash
touch Dockerfile
```

Edit the `Dockerfile` and define the environment for your C/C++ project. Here's a basic example:

```Dockerfile
# Use an official Ubuntu as a base image
FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND noninteractive

# Install build essentials and other necessary tools
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    gcc \
    g++ \
    gdb \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /usr/src/my_cpp_project

# Copy the local project files into the container
COPY . .
```

In this Dockerfile:
- `FROM`: Specifies the base image for the Docker image.
- `ENV`: Sets environment variables. In this example, it disables interactive prompts during package installation.
- `RUN`: Executes commands within the container to install necessary tools.
- `WORKDIR`: Sets the working directory within the container.
- `COPY`: Copies the local project files into the container.

**Creating a Docker Image for C/C++ Development:**

Once you've created the Dockerfile, you can build the Docker image using the `docker build` command. Run the following command in your project directory:

```bash
docker build -t my_cpp_image .
```

This command builds a Docker image with the tag `my_cpp_image` using the Dockerfile (`.` denotes the current directory).


## Useful Docker Client Commands

1. **Building Docker Images:**
   ```bash
   docker build -t my_image .
   ```

2. **Running Docker Containers:**
   ```bash
   docker run --name my_container my_image
   ```

3. **Listing Docker Containers:**
   ```bash
   docker ps -a
   ```

4. **Inspecting Docker Containers:**
   ```bash
   docker inspect my_container
   ```

5. **Copying Files to/from Docker Containers:**
   ```bash
   docker cp local_file.txt my_container:/path/to/destination
   ```

6. **Viewing Docker Logs:**
   ```bash
   docker logs my_container
   ```

7. **Stopping Docker Containers:**
   ```bash
   docker stop my_container
   ```

8. **Removing Docker Containers/Images:**
   ```bash
   docker rm my_container
   docker rmi my_image
   ```

9. **Pulling Docker Images from Registry:**
   ```bash
   docker pull my_registry/my_image:tag
   ```

10. **Pushing Docker Images to Registry:**
    ```bash
    docker push my_registry/my_image:tag
    ```

11. **Executing Commands inside Docker Containers:**
    ```bash
    docker exec -it my_container bash
    ```

12. **Managing Docker Networks:**
    ```bash
    docker network ls
    ```

13. **Inspecting Docker Volumes:**
    ```bash
    docker volume inspect my_volume
    ```

14. **Cleaning up Unused Resources:**
    ```bash
    docker system prune
    ```

15. **Listing Docker Images:**
    ```bash
    docker images
    ```

16. **Searching Images Online:**
    ```bash
    docker search $IMAGE_NAME
    ```

17. **Attaching to a Running Container:**
    ```bash
    docker exec -it CONTAINER_ID_OR_NAME /bin/bash
    ```

18. **Starting and Stopping Containers:**
    ```bash
    docker start/stop CONTAINER_ID_OR_NAME
    ```

19. **Killing All Containers:**
    ```bash
    docker kill $(docker ps -q)
    ```

20. **Removing Containers:**
    ```bash
    docker rmi CONTAINER_ID_OR_NAME
    ```

21. **Removing All Containers:**
    ```bash
    docker rm $(docker ps -q -a)  # -f for force remove even if it is running
    ```

22. **Exporting (Saving) an Image:**
    ```bash
    docker save IMAGE_NAME > IMAGE_NAME.tar.gz
    ```

23. **Loading (Importing) an Image:**
    ```bash
    docker load -i IMAGE_NAME.tar.gz
    ```

24. **Finding the SHA256 Hash of a Docker Image:**
    ```bash
    docker inspect --format='{{index .RepoDigests 0}}' IMAGE_NAME
    ```

25. **Pulling Docker Image by the SHA256 Digest:**
    ```bash
    docker pull IMAGE_NAME@sha256:0a3b2cc81
    ```


## Configuring My C/CPP Development Environment

- Installing necessary compilers, build tools, and libraries:
This Dockerfile is designed to create a C/C++ build environment within a Docker container. Let's elaborate on its structure and functionality:

```Dockerfile
################################################################################
# Dockerfile for creating a cpp build environment
################################################################################

# Set the base image to Ubuntu 22.04
FROM ubuntu:22.04

# Set docker image info
LABEL maintainer="Lukasz Uszko <lukasz.uszko@gmail.com>"
LABEL Description="luk6xff's cpp project template"

# Set non-interactive installation mode
ENV DEBIAN_FRONTEND=noninteractive

# Create a default user and group
ARG USERNAME
ARG USER_UID
ARG USER_GID
ENV HOME /home/${USERNAME}

# Create a non-root user to use
RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd -s /bin/bash -c ${USERNAME} -d ${HOME} --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
    # Add sudo support
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    # Cleanup
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

################################################################################
# Install LUK6xFF mandatory packages
################################################################################
RUN apt-get update && apt-get install --no-install-recommends -qy \
    # Build tools
    make \
    autoconf \
    automake \
    ninja-build \
    libtool \
    m4 \
    cmake \
    ccache\
    # GNU Toolchain
    gcc \
    g++ \
    # LLVM Toolchain
    clang \
    clang-tools \
    clangd \
    lld \
    lldb \
    # C/C++ libraries
    libboost-all-dev \
    libgtest-dev \
    libgmock-dev \
    libgoogle-glog-dev \
    libgoogle-perftools-dev \
    libbenchmark-dev \
    # Libraries
    gnupg \
    unzip \
    # Python
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    python3-setuptools \
    # Networking
    curl \
    wget \
    socat \
    # Code analysis
    cppcheck \
    iwyu \
    clang-tidy \
    clang-format \
    # Debugging/tracing
    gdb \
    valgrind \
    ltrace \
    strace \
    # Code coverage
    lcov \
    gcovr \
    # Documentation
    doxygen \
    graphviz \
    doxygen-latex \
    doxygen-doxyparse\
    # Version control
    git \
    git-flow \
    # Other tools
    lsb-release \
    jq \
    gawk \
    ###
    # clean up
    && rm -rf /var/lib/apt/lists/*

# Setup python virtual environment
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install cpplint
RUN pip install cpplint

# Install Infer
RUN VERSION=1.1.0; \
curl -sSL "https://github.com/facebook/infer/releases/download/v$VERSION/infer-linux64-v$VERSION.tar.xz" \
| sudo tar -C /opt -xJ && \
sudo ln -s "/opt/infer-linux64-v$VERSION/bin/infer" /usr/local/bin/infer

# Install CodeChecker
ENV CODE_CHECKER_PATH=/opt/CodeChecker
ENV BUILD_LOGGER_64_BIT_ONLY=YES
RUN curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
RUN apt-get install -y nodejs
RUN git clone https://github.com/Ericsson/CodeChecker.git --depth 1 ${CODE_CHECKER_PATH} && \
    cd ${CODE_CHECKER_PATH} && \
    make package
# Set environment variables to include CodeChecker in the PATH
ENV PATH="${CODE_CHECKER_PATH}/build/CodeChecker/bin:${PATH}"
ENV CC_REPO_DIR="${CODE_CHECKER_PATH}"
# Set the report-converter permissions
RUN chmod +x ${CODE_CHECKER_PATH}/build/CodeChecker/bin/report-converter
# Expose the default port used by CodeChecker server
EXPOSE 8999

################################################################################
# Install additional packages required for your project
################################################################################
RUN apt-get update \
    && apt install --no-install-recommends -qy \
    libxrandr-dev \
    libxcursor-dev \
    libudev-dev \
    libfreetype-dev \
    libopenal-dev \
    libflac-dev \
    libvorbis-dev \
    libgl1-mesa-dev \
    libegl1-mesa-dev

# clean up
RUN rm -rf /var/lib/apt/lists/*

################################################################################
# Setup
################################################################################
USER ${USERNAME}
WORKDIR $HOME
```

My Dockerfile sets up an environment for C/C++ development, including various tools and libraries commonly used in C/C++ projects. Let's break down its components:
- **Base Image:** The Dockerfile starts with the `FROM ubuntu:22.04` instruction, indicating that it's based on the Ubuntu 22.04 image.
- **Labels:** The `LABEL` instructions provide metadata about the image, such as the maintainer and description.
- **Non-Root User:** It creates a non-root user for running the container, enhancing security and avoiding potential permission issues.
- **Installation of Essential Packages:** It installs various build tools, compilers (GNU and LLVM), libraries (Boost, Google Test, Google Mock, etc.), Python packages, networking utilities, code analysis/debugging tools (cppcheck, gdb, valgrind, etc.), and version control tools (Git, Git Flow).
- **Python Virtual Environment:** It sets up a Python virtual environment for managing Python dependencies.
- **Installation of Additional Tools:** It installs additional tools like cpplint, Infer, and CodeChecker, which are used for code analysis, static analysis, and code checking.
- **Exposure of Default Port:** It exposes the default port used by the CodeChecker server (port 8999).
- **Additional Packages:** It installs additional packages required for specific project dependencies.
- **Cleanup:** It removes unnecessary files and packages to reduce the size of the Docker image.
- **User and Working Directory Setup:** It sets the user and working directory within the container.


## Managing Dependencies

Managing dependencies within your Dockerized C/C++ development environment is crucial for ensuring smooth project builds and executions. This involves:

1. **Utilizing Package Managers:**
   - Use tools like apt or yum within the Dockerfile to install system-level dependencies.
   - Specify package versions to ensure consistency and reproducibility.

```Dockerfile
# Example of installing specific versions of packages using apt
RUN apt-get update \
    && apt-get install -y \
        <package1>=<version1> \
        <package2>=<version2> \
        ...
        <packagen>=<versionn> \
    && rm -rf /var/lib/apt/lists/*
```

2. **Incorporating Third-Party Libraries:**
   - Download and install third-party libraries from their official sources or package repositories.
   - Specify precise versions and document dependencies for future reference.

```Dockerfile
# Example of incorporating a third-party library into the Docker image
RUN curl -L -o <library>.tar.gz <URL_to_library.tar.gz> \
    && tar -xzvf <library>.tar.gz \
    && cd <library> \
    && ./configure \
    && make \
    && make install \
    && cd .. \
    && rm -rf <library>.tar.gz <library>
```
By managing dependencies effectively and specifying precise versions within your Dockerfile, you ensure consistency and reproducibility across different environments, making it easier to build and distribute your C/C++ projects.


## Streamlining Build Processes

1. **Automating the Build Process using Dockerfile and Docker Compose:**
Docker Compose can be employed for orchestrating multi-container applications and defining complex build configurations.
Let's consider a scenario where you have a C/C++ project consisting of multiple services, such as a web server and a database. We'll compare how you would use Docker Compose and Docker run commands to manage these services.

### Scenario:
You have a C/C++ project named "MyProject" that includes a web server service and a database service.

### Docker Compose Example:
With Docker Compose, you can define a `docker-compose.yml` file to orchestrate the deployment of multiple containers as services.

```yaml
# docker-compose.yml

version: '3'
services:
  web_server:
    image: my_project_web_server:latest
    ports:
      - "8080:80"
    depends_on:
      - database
  database:
    image: mysql:latest
    environment:
      MYSQL_ROOT_PASSWORD: root_password
      MYSQL_DATABASE: my_database
```

In this example:
- The `web_server` service is defined with the `my_project_web_server` image, exposing port 8080 on the host and depending on the `database` service.
- The `database` service is defined with the `mysql` image, setting environment variables for MySQL root password and database name.

You can then deploy the services using the following Docker Compose command:
```bash
docker-compose up
```

### Docker Run Example:
With Docker run commands, you would need to manually specify each container and its configurations.

```bash
# Start the database container
docker run --name database -e MYSQL_ROOT_PASSWORD=root_password -e MYSQL_DATABASE=my_database -d mysql:latest

# Start the web server container
docker run --name web_server -p 8080:80 --link database my_project_web_server:latest
```

In this example:
- The `database` container is started with the MySQL image, setting environment variables for MySQL root password and database name.
- The `web_server` container is started with the `my_project_web_server` image, exposing port 8080 on the host and linking it to the `database` container.

### Comparison:
- **Docker Compose:** Provides a declarative way to define and manage multi-container applications, simplifying service orchestration and dependencies.
- **Docker Run Commands:** Require manual specification of each container and its configurations, which can become cumbersome for complex applications with multiple services.

In summary, Docker Compose offers a more streamlined and maintainable approach for managing multi-container applications, while Docker run commands are suitable for simpler scenarios or quick ad-hoc deployments.

2. **Handling Different Build Configurations within Docker:**
   - Use environment variables or build arguments in Dockerfile to handle different build configurations (e.g., Debug vs. Release).
   - Customize build commands based on the selected configuration.

   ```Dockerfile
   # Example of handling different build configurations in Dockerfile
   ARG BUILD_TYPE=Release

   # Set build options based on selected configuration
   RUN if [ "$BUILD_TYPE" = "Debug" ]; then \
           make debug; \
       else \
           make release; \
       fi
   ```


## Debugging CPP apps using GDB

You can use GDB's remote debugging feature to debug your C/C++ applications running inside a Docker container from a host machine. Here's how you can achieve that:

1. **Expose GDB Server Port in Docker Container:**
   - In your Dockerfile or Docker Compose file, expose a port for GDB server to communicate with the host machine.

   ```yaml
   # Example of exposing GDB server port in Docker Compose file
   version: '3'
   services:
     my_cpp_app:
       build:
         context: .
         dockerfile: Dockerfile
       ports:
         - "1234:1234"  # Expose port for GDB server
   ```

2. **Run GDB Server in Docker Container:**
   - Start your Docker container as usual, but ensure that GDB server is running inside the container, listening on the exposed port.

   ```bash
   # Start Docker container with GDB server
   docker run --rm -d -p 1234:1234 my_cpp_image gdbserver :1234 my_executable
   ```

3. **Connect Host GDB to GDB Server:**
   - On your host machine, use the GDB command-line interface to connect to the GDB server running inside the Docker container.

   ```bash
   # Connect host GDB to GDB server in Docker container
   gdb
   (gdb) target remote <docker_host_ip>:1234
   ```

4. **Debug C/C++ Application with Host GDB:**
   - Once connected, you can use GDB commands on your host machine to debug the C/C++ application running inside the Docker container.

   ```bash
   # Example of setting breakpoints and debugging
   (gdb) break main
   (gdb) continue
   (gdb) ...
   ```

By setting up GDB server in the Docker container and connecting it to the host GDB, you can effectively debug your C/C++ applications running inside Docker containers from your host machine.


## Collaboration and Deployment

### Collaboration and Deployment

Collaboration and deployment are crucial stages in the software development lifecycle. Docker provides a robust platform for sharing development environments across teams and deploying C/C++ applications consistently in production environments. Here's how you can leverage Docker for collaboration and deployment:

1. **Sharing Docker Images for Consistent Development Environments:**
   - Build Docker images containing your C/C++ development environment, including dependencies, libraries, and tools.
   - Share these Docker images via a Docker registry or repository, ensuring consistency across development teams.

   ```bash
   # Example of building and sharing a Docker image
   docker build -t my_cpp_image .
   docker tag my_cpp_image my_registry/my_cpp_image:latest
   docker push my_registry/my_cpp_image:latest
   ```

   Team members can pull the shared Docker image to set up their development environments quickly and reliably.

2. **Deploying C/C++ Applications using Docker Containers in Production Environments:**
   - Package your C/C++ applications into Docker containers, along with necessary dependencies and configurations.
   - Deploy these Docker containers to production environments, ensuring consistency and portability across different infrastructure setups.

   ```bash
   # Example of deploying a Docker container in production
   docker run -d --name my_cpp_app my_registry/my_cpp_image:latest
   ```

   Docker containers offer isolation, scalability, and reproducibility, making them well-suited for deploying C/C++ applications in production environments.

By leveraging Docker for collaboration and deployment, development teams can streamline their workflows, maintain consistency across environments, and accelerate the delivery of C/C++ applications from development to production.


## Best Practices and Tips

Optimizing Dockerfiles, managing container resources, and securing Docker containers are essential aspects of using Docker effectively for C/C++ projects. Here are some best practices and tips:

1. **Optimizing Dockerfiles for Efficiency:**
   - Keep Dockerfiles clean and concise by minimizing the number of layers and reducing the size of the final image.
   - Use multi-stage builds to separate build dependencies from runtime dependencies, resulting in smaller images.
   - Utilize caching mechanisms to speed up the build process by caching intermediate layers.

2. **Managing Container Resources Effectively:**
   - Specify resource constraints such as CPU and memory limits for Docker containers to prevent resource contention and ensure predictable performance.
   - Monitor container resource usage using Docker metrics and adjust resource limits accordingly to optimize resource utilization.
   - Consider using orchestration tools like Docker Swarm or Kubernetes for managing containerized applications at scale, enabling efficient resource allocation and scheduling.

3. **Securing Docker Containers for C/C++ Projects:**
   - Update Docker base images and dependencies regularly to patch known vulnerabilities and ensure the security of your containers.
   - Implement least privilege principles by running containers with non-root users and restricting container capabilities using Docker security features.
   - Enable Docker Content Trust (DCT) to ensure the integrity and authenticity of images by verifying image signatures before pulling and running them.
   - Monitor container activities and network traffic using Docker security tools and third-party solutions to detect and respond to security threats effectively.

Examples:

### Optimizing Dockerfiles for Efficiency:

1. **Minimizing Layers:**
   ```Dockerfile
   # Bad practice: creating multiple layers
   RUN apt-get update
   RUN apt-get install -y package1
   RUN apt-get install -y package2

   # Good practice: combining commands to reduce layers
   RUN apt-get update && \
       apt-get install -y package1 package2
   ```

2. **Using Multi-Stage Builds:**
   ```Dockerfile
   # Single-stage build
   FROM base_image AS builder
   RUN build_commands

   FROM base_image
   COPY --from=builder /app /app
   ```

3. **Caching Mechanisms:**
   ```Dockerfile
   # Bad practice: not utilizing caching
   COPY . /app
   RUN npm install
   RUN npm build

   # Good practice: using caching for dependencies
   COPY package.json /app
   RUN npm install
   COPY . /app
   RUN npm build
   ```

### Managing Container Resources Effectively:

1. **Specifying Resource Constraints:**
   ```bash
   # Setting CPU and memory limits for a Docker container
   docker run --cpus=2 --memory=2g my_image
   ```

2. **Monitoring Container Resource Usage:**
   ```bash
   # Checking container resource usage
   docker stats my_container
   ```

3. **Using Orchestration Tools:**
   ```bash
   # Deploying a Docker stack with Docker Swarm
   docker stack deploy -c docker-compose.yml my_stack
   ```

### Securing Docker Containers for C/C++ Projects:

1. **Updating Docker Base Images:**
   ```bash
   # Pulling the latest version of a Docker base image
   docker pull base_image:latest
   ```

2. **Implementing Least Privilege Principles:**
   ```Dockerfile
   # Running container with non-root user
   USER my_user
   ```

3. **Enabling Docker Content Trust (DCT):**
   ```bash
   # Enabling Docker Content Trust
   export DOCKER_CONTENT_TRUST=1
   ```

4. **Monitoring Container Activities:**
   ```bash
   # Monitoring container logs
   docker logs my_container
   ```

## Docker containers vs native builds
This table provides a concise comparison between Docker containers and native builds across various aspects of performance and functionality.

| Aspect                        | Docker Containers                                       | Native Builds                                           |
|-------------------------------|---------------------------------------------------------|---------------------------------------------------------|
| **Isolation Overhead**       | Introduces a layer of abstraction, incurring some overhead. | Executes directly on the host system without overhead.  |
| **Resource Allocation**       | Allows fine-grained control over resource allocation.  | Accesses all system resources without virtualization.   |
| **Portability and Consistency** | Offers portability across different environments, ensuring consistency. | Tightly coupled to the host environment, may lack consistency. |
| **Dependency Management**     | Encapsulates dependencies within a self-contained environment. | Relies on system-wide dependencies, requiring careful management. |


## Multi architectures builds
Sure, here's an example of building a simple "Hello, World!" C++ application for different platforms using Docker buildx (Demo: [HERE](https://github.com/luk6xff/luk6xff.github.io/tree/master/content/other/code/cpp_proj_template)):

1. **Create a C++ source file** (hello.cpp):
   ```cpp
   #include <iostream>

   int main() {
       std::cout << "Hello, World!" << std::endl;
       return 0;
   }
   ```

2. **Create a Dockerfile**:
   ```Dockerfile
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
   ```

3. **Build the Docker image** for multiple architectures:
   ```bash
    # Create the builder (if not already created)
    docker buildx create --name my_builder

    # Use the builder for subsequent builds
    docker buildx use my_builder

    # Build the multi-architecture image and load it into local Docker daemon
    docker buildx build --platform linux/amd64,linux/arm64 -t hello-world:latest .
    docker buildx build --load -t hello-world:latest .
   ```

4. **Run the Docker image**:
   ```bash
   docker run hello-world
   ```

This example demonstrates how to build a simple "Hello, World!" C++ application for both amd64 and arm64 architectures using Docker buildx. The resulting Docker image can be run on systems with different CPU architectures without modification, showcasing the versatility and compatibility of Docker multi-architecture builds.

## Conclusion

- Recap of the benefits of Docker for C/C++ development.
- Encouragement for developers to embrace Docker for simplifying their workflows and enhancing collaboration.

