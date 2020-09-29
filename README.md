# DNS Docker Image

This folder contains the dockerfile to create the [BIND](https://www.isc.org/bind/) DNS server docker image.

This images is pushed up to [Amazon ECR](https://aws.amazon.com/ecr/).

## Getting started

To get started with development you will need:

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

### Running locally

See the target `run` in the [Makefile](./Makefile)

### Deploying to production

Deployments are automated in the CI pipeline. See [buildspec.yml](./buildspec.yml)

## Automated Testing
To run the tests locally run
```bash
$ make test
```
