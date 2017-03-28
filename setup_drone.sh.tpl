#!/bin/bash

sudo docker run -d \
  -e DRONE_GITHUB=true \
  -e DRONE_GITHUB_CLIENT=${client_id} \
  -e DRONE_GITHUB_SECRET=${client_secret} \
  -e DRONE_SECRET=${drone_secret} \
  -e DRONE_OPEN=false  \
  -e DRONE_ADMIN=admin  \
  -v /var/lib/drone:/var/lib/drone \
  -p 80:8000 \
  --restart=always \
  --name=drone \
  drone/drone:0.5
