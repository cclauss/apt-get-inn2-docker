Run https://github.com/InterNetNews/inn in a localhost Docker container or as a GitHub
Actions service.  Installs the InterNetNews server using `apt-get install inn2`.

This is a friendly fork of https://github.com/greenbender/inn-docker which is probably
more appropriate and configurable for your use case.
```
docker build -t inn .
docker run --rm -t -p119:119 -p563:563 inn
-- or --
docker run --rm -t -p119:119 -p563:563 cclauss/inn
```
To use this in a GitHub Action please add:
```yaml
    services:
      inn-service:
        image: cclauss/inn
        ports:
          - 119:119
          - 563:563
```
* GitHub: https://github.com/cclauss/apt-get-inn2-docker
* DockerHub: https://hub.docker.com/r/cclauss/inn/tags
