#!/usr/bin/env sh

ACCOUNT_ID="806488921245"
REGION="ap-northeast-1"

aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.ap-northeast-1.amazonaws.com
docker build -t lambda-docker .
docker tag lambda-docker:latest ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/lambda-docker:latest
docker push ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/lambda-docker:latest