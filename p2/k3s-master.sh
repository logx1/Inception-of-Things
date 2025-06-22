#!/bin/bash
curl -sfL https://get.k3s.io | sh -

while [ ! -f /var/lib/rancher/k3s/server/node-token ]; do
    echo "Waiting for k3s server to start..."
    sleep 2
done

echo "K3s server started successfully."
