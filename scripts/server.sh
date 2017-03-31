#!/bin/bash

docker run -d \
  -e DRONE_GITHUB=true \
  -e DRONE_GITHUB_CLIENT=$DRONE_GITHUB_CLIENTY \
  -e DRONE_GITHUB_SECRET=$DRONE_GITHUB_SECRET \
  -e DRONE_SECRET=$DRONE_SECRET \
  -e DRONE_OPEN=true \
  -e DRONE_DEBUG=true \
  -e DRONE_BROKER_DEBUG=true \
  -v /var/lib/drone:/var/lib/drone \
  -p 8000:8000 \
  --restart=always \
  --name=drone \
  -e DRONE_ADMIN=$DRONE_ADMIN \
  drone/drone:0.5
