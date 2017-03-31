#!/bin/bash

docker run -d \
  -e DRONE_SERVER=$DRONE_SERVER \
  -e DRONE_SECRET=$DRONE_SECRET \
  -e DRONE_DEBUG=true \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --restart=always \
  --name=drone-agent \
  drone/drone:0.5 agent
