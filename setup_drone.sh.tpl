#!/bin/bash

apt-get install -qqy nginx

cat > /etc/nginx/sites-available/default <<EOT
map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

upstream drone {
    server 127.0.0.1:8000;
}

server {
    listen 80;

    location / {
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Host $http_host;

        proxy_pass http://drone;
        proxy_redirect off;
        proxy_http_version 1.1;
        proxy_buffering off;

        chunked_transfer_encoding off;
    }

    location ~* /ws {
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Host $http_host;

        proxy_pass http://drone;
        proxy_http_version 1.1;
        proxy_read_timeout 86400;
    }
}
EOT

service nginx restart

docker run -d \
  -e DRONE_GITHUB=true \
  -e DRONE_GITHUB_CLIENT=${client_id} \
  -e DRONE_GITHUB_SECRET=${client_secret} \
  -e DRONE_SECRET=${drone_secret} \
  -e DRONE_OPEN=true \
  -v /var/lib/drone:/var/lib/drone \
  -p 8000:8000 \
  --restart=always \
  --name=drone \
  drone/drone:0.5
