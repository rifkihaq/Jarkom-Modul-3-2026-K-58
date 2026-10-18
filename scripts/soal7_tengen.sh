#!/bin/sh

echo "=== VERIFIKASI DHCP SOAL 7 ==="

echo "=== VALIDASI KONFIGURASI ==="
dhcpd -t -cf /etc/dhcp/dhcpd.conf || exit 1

echo "=== DHCP OPTIONS ==="
grep -E 'option (subnet-mask|routers|broadcast-address|domain-name-servers|domain-search)' \
    /etc/dhcp/dhcpd.conf

echo "=== DAFTAR LEASE NETWORK 2 DAN 3 ==="
grep -E '^lease 192\.240\.[23]\.' /var/lib/dhcp/dhcpd.leases | sort -u

echo "=== RESERVATION KUGISAKI ==="
grep -A3 '^host kugisaki' /etc/dhcp/dhcpd.conf

echo "=== VERIFIKASI SOAL 7 SELESAI ==="
