#!/bin/bash

echo "Building ansible 2.9 image"
docker build --network host -f Dockerfile -t osvccol:29 .

echo "Building ansible upstream image"
docker build --network host -f Dockerfile.dev -t osvccol:dev .
