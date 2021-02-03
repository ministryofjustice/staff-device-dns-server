# Health checks

NGINX is run on the ECS service as a sidecar container. This responds to the health checks. The NGINX image is stored as a base image in the [base images repository](https://github.com/ministryofjustice/staff-device-docker-base-images).

The container is deployed into ECR in the target AWS account, where the DNS service can pull it down and run it.
