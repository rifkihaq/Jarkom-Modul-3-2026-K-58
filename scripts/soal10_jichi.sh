#!/bin/sh
set -e

echo "=== SOAL 10 - AUTOSTART DHCP RELAY JICHI ==="

# Menyalakan seluruh interface
for iface in eth0 eth1 eth2 eth3 eth4; do
  ip link set "$iface" up
done

# Memastikan IP setiap interface sesuai topologi
ip -4 addr show eth0 | grep -q '192.168.122.10/24' || \
  ip addr add 192.168.122.10/24 dev eth0
ip -4 addr show eth1 | grep -q '192.240.1.1/24' || \
  ip addr add 192.240.1.1/24 dev eth1
ip -4 addr show eth2 | grep -q '192.240.2.1/24' || \
  ip addr add 192.240.2.1/24 dev eth2
ip -4 addr show eth3 | grep -q '192.240.3.1/24' || \
  ip addr add 192.240.3.1/24 dev eth3
ip -4 addr show eth4 | grep -q '192.240.4.1/24' || \
  ip addr add 192.240.4.1/24 dev eth4

# Routing, forwarding, dan NAT
ip route replace default via 192.168.122.1 dev eth0
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -C POSTROUTING -o eth0 -j MASQUERADE 2>/dev/null || \
  iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Menjalankan relay jika belum aktif
if ! pgrep -x dhcrelay >/dev/null 2>&1; then
  dhcrelay -d -4 -iu eth4 -id eth2 -id eth3 \
    192.240.4.10 > /tmp/relay.log 2>&1 &
fi

echo "=== DHCP RELAY JICHI AKTIF ==="
