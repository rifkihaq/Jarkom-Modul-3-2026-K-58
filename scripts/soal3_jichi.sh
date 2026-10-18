#!/bin/sh

# DHCP Relay Jichi
# Network 2: eth2
# Network 3: eth3
# Jalur server Tengen: eth4

sysctl -w net.ipv4.ip_forward=1

dhcrelay -d -4 -iu eth4 -id eth2 -id eth3 \
  192.240.4.10 > /tmp/relay.log 2>&1 &

echo "DHCP Relay aktif. Log: /tmp/relay.log"
