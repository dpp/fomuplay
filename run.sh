#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Run the container

cd ${SCRIPT_DIR} 

mkdir -p caches/root_cache
mkdir -p caches/sbt_cache
mkdir -p caches/rust_cache

docker run -ti --rm --privileged -v /dev:/dev \
  -v $(pwd)/caches/root_cache:/root/.cache \
  -v $(pwd)/caches/sbt_cache:/root/.sbt \
  -v $(pwd)/caches/rust_cache:/root/.cargo/registry \
  -v $(pwd)/..:/workshop fomu
