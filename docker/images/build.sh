#!/usr/bin/env bash
set -x

IMAGE=${1:-backend}

OUTPUT="type=registry"

if [ "--local" = "$2" ]; then
    OUTPUT="type=docker"
fi

ORG=${PENJAR_DOCKER_NAMESPACE:-penjarapp};
PLATFORM=${PENJAR_BUILD_PLATFORM:-linux/amd64,linux/arm64};
VERSION=${PENJAR_BUILD_VERSION:-latest}
DOCKER_IMAGE="$ORG/$IMAGE";
OPTIONS="-t $DOCKER_IMAGE:$VERSION";

IFS=", "
read -a TAGS <<< $PENJAR_BUILD_TAGS;

for element in "${TAGS[@]}"; do
    OPTIONS="$OPTIONS -t $DOCKER_IMAGE:$element";
done

docker buildx inspect penjar > /dev/null 2>&1;
docker run --privileged --rm tonistiigi/binfmt --install all > /dev/null;

if [ $? -eq 1 ]; then
    docker buildx create --name=penjar --use
    docker buildx inspect --bootstrap > /dev/null 2>&1;
else
    docker buildx use penjar;
    docker buildx inspect --bootstrap  > /dev/null 2>&1;
fi

unset IFS;

shift;
docker buildx build --output $OUTPUT --platform ${PLATFORM// /,} $OPTIONS -f Dockerfile.$IMAGE .;
