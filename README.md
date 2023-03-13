# EKS and API Gateway Integration

API Gateway integration with GRPC Service with an HTTP reverse-proxy in EKS through ALB

## Prerequisites

Make sure the dev environment is installed with the below `cli` tools and `aws` creds are exported in the `env`

- `terraform`
- `kubectl`
- `aws`

Export `KUBE_CONFIG_PATH` with `/path/to/.kube/config`

    $ export KUBE_CONFIG_PATH=~/.kube/config


## Deployment

Run below command to deploy to `aws`, default region is `ap-south-1`

    $ terraform init
    $ terraform plan
    $ terraform apply

## Test

Please collect the output variable `app_fqdn_path` of the command `terraform apply`
Follow https://github.com/subbuv26/image-array-reverse-proxy by replacing `localhost:8080` with `app_fqdn_path`


## Troubleshooting

- If `$ terraform apply` ends up in `error`, just rerun `$ terraform apply`
- Still stuck in error case an no progress, destroy the app module that stuck in inconsistent state, by running `$ terraform destroy -target=module.k8s_app`
- Run `$ terraform apply` multiple time even after the command is successful, to properly sync the resources created in multiple tries

## Notes
- Need to create certificates for domain `internal.dev.jina.ai`, if region is changed, in the chosen region.
