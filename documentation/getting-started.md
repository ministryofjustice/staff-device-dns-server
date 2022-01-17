# Getting started

To get started with development you will need:

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

## Authenticate with AWS  

Assuming you have been granted necessary access permissions to the Shared Service Account, please follow the CloudOps best practices provided [step-by-step guide](https://ministryofjustice.github.io/cloud-operations/documentation/team-guide/best-practices/use-aws-sso.html#re-configure-aws-vault) to configure your AWS Vault and AWS Cli with AWS SSO.  

## Prepare the variables  

1. Copy `.env.example` to `.env`
1. Modify the `.env` file and provide values for variables as below:  

| Variables | How? |
| --- | --- |
| `AWS_PROFILE=` | your **AWS-CLI** profile name for the **Shared Services** AWS account. Check [this guide](https://ministryofjustice.github.io/cloud-operations/documentation/team-guide/best-practices/use-aws-sso.html#re-configure-aws-vault) if you need help. |
| `SHARED_SERVICES_ACCOUNT_ID=` | Account ID of the MoJO Shared Services AWS account.  |
| `REGISTRY_URL=` | `<MoJO Development AWS Account ID>`.dkr.ecr.eu-west-2.amazonaws.com |  
| `ENV=` | Your Terraform namespace from the DNS DHCP Infrastructure repo. |  

## Authenticating Docker with AWS ECR

The Docker base image is stored in ECR. Prior to building the container you must authenticate Docker to the ECR registry. [Details can be found here](https://docs.aws.amazon.com/AmazonECR/latest/userguide/Registries.html#registry_auth).

If you have [aws-vault](https://github.com/99designs/aws-vault#installing) configured according to CloudOps best practices, do the following to authenticate:

```bash
make authenticate-docker
```  

## Running Locally

See the target `run` in the [Makefile](/Makefile)

## Automated Testing

To run the tests locally run

```bash
make test
```  
