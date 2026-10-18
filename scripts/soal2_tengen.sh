#!/bin/bash

# DHCP Server Tengen 192.240.4.10/24
mkdir -p /var/lib/dhcp
touch /var/lib/dhcp/dhcpd.leases

cat > /etc/dhcp/dhcpd.conf <<'CONF'
authoritative;

# Subnet langsung Tengen (tanpa DHCP pool)
subnet 192.240.4.0 netmask 255.255.255.0 {
}

# Pool awal sementara Network 2
subnet 192.240.2.0 netmask 255.255.255.0 {
  range 192.240.2.100 192.240.2.200;
  option subnet-mask 255.255.255.0;
  option routers 192.240.2.1;
  option domain-name-servers 192.168.122.1;
}

# Pool awal sementara Network 3
subnet 192.240.3.0 netmask 255.255.255.0 {
  range 192.240.3.100 192.240.3.200;
  option subnet-mask 255.255.255.0;
  option routers 192.240.3.1;
  option domain-name-servers 192.168.122.1;
}
CONF

dhcpd -t -cf /etc/dhcp/dhcpd.conf || exit 1
pkill -x dhcpd 2>/dev/null || true
dhcpd -cf /etc/dhcp/dhcpd.conf eth0

echo "=== SOAL 2 TENGEN SELESAI ==="
