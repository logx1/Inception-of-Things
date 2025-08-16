#!/bin/bash

sudo k3s kubectl delete -f /vagrant/app1.yaml
sudo k3s kubectl delete -f /vagrant/app2.yaml
sudo k3s kubectl delete -f /vagrant/app3.yaml
sudo k3s kubectl delete -f /vagrant/ingress.yaml