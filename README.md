INN Docker Image
================
Overview
This Docker image provides an easy-to-use implementation of the InterNetNews (INN) server.
Usage
Docker Run
To run the INN server using Docker, execute the following command:
Bash
docker run --rm -t -p119:119 -p563:563 inn
GitHub Actions
To use this image in a GitHub Action, add the following configuration to your workflow file:
YAML
services:
  inn-service:
    image: cclauss/inn
    ports:
      - 119:119
      - 563:563
Ports
The following ports are exposed by the container:
119: NNTP port
563: NNTPS port
Image Details
Image Name: cclauss/inn
Dockerfile: [insert link to Dockerfile if applicable]
Contributing
Contributions and issues are welcome! If you'd like to contribute or report a bug, please open an issue or submit a pull request.
License
[HERE]
