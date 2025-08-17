#!/bin/bash
curl -sfL https://get.k3s.io | sh -

while [ ! -f /var/lib/rancher/k3s/server/node-token ]; do
    echo "Waiting for node token to be available..."
    sleep 2
done

TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)

echo $TOKEN > /vagrant/token