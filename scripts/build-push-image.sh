#! /bin/sh

set -e # Exit immediately if a command exits with a non-zero status.

IMAGE_NAME="${IMAGE_NAME}:"$(cat version)

docker build --build-arg REPOSITORY=${REPOSITORY_NAME} \
    --build-arg GITHUB_URL=${GITHUB_URL} \
    --build-arg GITHUB_API_URL=${GITHUB_API_URL} -t "${IMAGE_NAME}" .

echo "${DOCKERHUB_TOKEN}" | docker login --username "${DOCKER_USER}"  --password-stdin

echo "Pushing image: ${IMAGE_NAME}"

docker push "${IMAGE_NAME}"

echo "Pushed image: ${IMAGE_NAME}"