#!/bin/sh

echo "=== KONFIGURASI DHCP SOAL 5 - TENGEN ==="

# Mengembalikan snapshot konfigurasi Soal 5
cp /root/soal5_dhcpd.conf /etc/dhcp/dhcpd.conf

mkdir -p /var/lib/dhcp
touch /var/lib/dhcp/dhcpd.leases

dhcpd -t -cf /etc/dhcp/dhcpd.conf || exit 1

pkill -x dhcpd 2>/dev/null || true
sleep 1

dhcpd -cf /etc/dhcp/dhcpd.conf eth0

echo "=== SOAL 5 TENGEN SELESAI ==="
