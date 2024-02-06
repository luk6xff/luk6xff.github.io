# luk6xff.github.io
The next gen blog website based on [zola - static site generator](https://www.getzola.org/)


## Installation
* Pull
```sh
docker pull ghcr.io/getzola/zola:v0.17.1
```

## Build
```sh
docker run -u "$(id -u):$(id -g)" -v $PWD:/app --workdir /app ghcr.io/getzola/zola:v0.17.1 build
```

## Serve
```sh
cd ~/Projects/luk6xff.github.io
docker run -u "$(id -u):$(id -g)" -v $PWD:/app --workdir /app -p 8080:8080 -p 1024:1024 ghcr.io/getzola/zola:v0.17.1 serve --interface 0.0.0.0 --port 8080 --base-url localhost
```
You can now browse to: http://localhost:8080