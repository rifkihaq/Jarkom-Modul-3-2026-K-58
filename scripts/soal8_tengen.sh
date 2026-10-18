#!/bin/sh

echo "=== SOAL 8 - PACKET CAPTURE DHCP ==="

timeout 180 tcpdump -lni eth0 -vvv -s 0 \
  'udp port 67 or udp port 68' \
  > /root/soal8_capture_ulang.txt 2>&1 &

echo "Packet capture aktif selama 180 detik."
echo "Lakukan DHCP request dari client Network 2 atau 3."
echo "Contoh Ino: udhcpc -i eth1 -n -q"
echo "Setelah berhasil, periksa hasil dengan:"
echo "grep -Ei 'DHCP-Message|Gateway-IP|Your-IP|Server-ID|Lease-Time' /root/soal8_capture_ulang.txt"
echo "=== SOAL 8 SIAP ==="
