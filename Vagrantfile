# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"

  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.network "public_network"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end

  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -qqy unzip

    # Install Caddy
    curl -s https://getcaddy.com | bash

    # Install ngrok
    curl -s https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip -o ngrok.zip
    unzip ngrok.zip

    # Start ngrok
    nohup ./ngrok http 80 &

    sleep 5

    NGROK_URL=`curl -s http://127.0.0.1:4040/status | grep "http:\/\/[a-z1-9]*\.ngrok\.io" -oh`

    # Configure Caddy
    mkdir /etc/caddy
    cat > /etc/caddy/Caddyfile <<EOL
$NGROK_URL:80
tls off
proxy / 127.0.0.1:8000 {
        websocket
        transparent
}

    nohup caddy -conf /etc/caddy/Caddyfile &
EOL
  SHELL

  config.vm.provision "docker" do |d|
    d.run "drone/drone:0.5",
      args:
        "-e DRONE_GITHUB=true \
         -e DRONE_OPEN=true \
         -e DRONE_GITHUB_CLIENT=#{ENV['DRONE_GITHUB_CLIENT']} \
         -e DRONE_GITHUB_SECRET=#{ENV['DRONE_GITHUB_SECRET']} \
         -e DRONE_SECRET=#{ENV['DRONE_SECRET']} \
         -e DRONE_DEBUG=true \
         -e DRONE_BROKER_DEBUG=true \
         -v drone:/var/lib/drone \
         -p 8000:8000",
      restart: "always",
      auto_assign_name: false
  end
end
