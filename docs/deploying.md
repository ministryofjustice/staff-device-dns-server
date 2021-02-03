# Deploying

This service runs in 3 different environments:

- Development
- Pre-production
- Production

These 3 environments are identical and changes should be tested on a non-production environment before deploying to production.

Deployments are automated in the CI pipeline. See [buildspec.yml](./buildspec.yml)

Deployments are designed to be zero downtime, a deploy will double the running task count with the new containers and the old containers will be slowly decomissioned after that.
Deployments are queued and will run in a sequence until the final changes have been applied.

A deployment can be triggered in two ways:

1. Updating the BIND 9 configuration in the Admin Portal
2. Updating the container Dockerfile

In both these situations new containers will be created and the traffic will be redirected to them.
