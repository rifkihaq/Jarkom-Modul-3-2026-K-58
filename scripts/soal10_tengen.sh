#!/bin/sh
set -e

echo "=== SOAL 10 - AUTOSTART DHCP SERVER TENGEN ==="

# Mengaktifkan interface dan IP Tengen
ip link set eth0 up
ip -4 addr show eth0 | grep -q 'inet 192.240.4.10/24' || \
  ip addr add 192.240.4.10/24 dev eth0

# Gateway menuju router Jichi
ip route replace default via 192.240.4.1 dev eth0

# Memulihkan konfigurasi DHCP final
cp /root/soal10_dhcpd.conf /etc/dhcp/dhcpd.conf

# Menyiapkan database lease
mkdir -p /var/lib/dhcp
touch /var/lib/dhcp/dhcpd.leases

dhcpd -t -cf /etc/dhcp/dhcpd.conf

# Menjalankan server jika belum aktif
if ! pgrep -x dhcpd >/dev/null; then
  rm -f /var/run/dhcpd.pid
  dhcpd -cf /etc/dhcp/dhcpd.conf eth0
fi

echo "=== DHCP SERVER TENGEN AKTIF ==="
