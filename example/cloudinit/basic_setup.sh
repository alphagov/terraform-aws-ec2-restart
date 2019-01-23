#!/usr/bin/env bash
echo "Started running cloud-init script"
touch /var/log/created_by_cloudinit
hostname ${hostname}
echo "127.0.1.1 $(hostname)" >> /etc/hosts
locale-gen en_GB.UTF-8
apt-get update
apt-get upgrade
echo "Finished running cloud-init script"
