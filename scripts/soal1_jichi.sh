#!/bin/bash

# WAN / NAT1
ip addr replace 192.168.122.10/24 dev eth0
ip link set eth0 up
ip route replace default via 192.168.122.1

echo "nameserver 192.168.122.1" > /etc/resolv.conf

# Gateway empat jaringan internal
ip addr replace 192.240.1.1/24 dev eth1
ip addr replace 192.240.2.1/24 dev eth2
ip addr replace 192.240.3.1/24 dev eth3
ip addr replace 192.240.4.1/24 dev eth4

# Aktifkan forwarding
sysctl -w net.ipv4.ip_forward=1

# Aturan NAT tanpa menambahkan duplikat
iptables -t nat -C POSTROUTING -o eth0 -j MASQUERADE 2>/dev/null || \
  iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Mengizinkan lalu lintas dari jaringan internal menuju WAN
for IFACE in eth1 eth2 eth3 eth4; do
  iptables -C FORWARD -i "$IFACE" -o eth0 -j ACCEPT 2>/dev/null || \
    iptables -A FORWARD -i "$IFACE" -o eth0 -j ACCEPT
  iptables -C FORWARD -i eth0 -o "$IFACE" -m conntrack \
    --ctstate ESTABLISHED,RELATED -j ACCEPT 2>/dev/null || \
    iptables -A FORWARD -i eth0 -o "$IFACE" -m conntrack \
    --ctstate ESTABLISHED,RELATED -j ACCEPT
done

echo "=== SOAL 1 JICHI SELESAI ==="
