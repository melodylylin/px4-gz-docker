#!/bin/bash
export HOST_UID=$(id -u)
export HOST_GID=$(id -g)
xhost +local:docker
docker compose up
