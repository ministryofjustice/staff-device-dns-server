# Health checks

A health check [script](../dns-service/health-check/health-check.py). is run on the ECS service container.
It carries out a dig on the local container its running on. If successful it serves a 200 HTTP responce.
If the dig is unsuccessful it will serve a 403 HTTP page. This is available on port 80 to be picked up by the AWS load
balancer target group [health-checks](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/target-group-health-checks.html).
