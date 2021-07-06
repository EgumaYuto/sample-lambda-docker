#!/usr/bin/env sh

cd infra
terraform apply --target aws_ecr_repository.repository -auto-approve
cd ../

./build-push.sh

cd infra
terraform apply -auto-approve
cd ../