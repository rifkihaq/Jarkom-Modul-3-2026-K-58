#!/bin/sh

echo "=== SOAL 9 - SIMULASI GANGGUAN DHCP RELAY ==="

case "$1" in
  stop)
    echo "Menghentikan DHCP Relay..."
    pkill -x dhcrelay 2>/dev/null || true
    echo "DHCP Relay dihentikan."
    ;;

  start)
    echo "Memulihkan DHCP Relay..."
    if pgrep -x dhcrelay >/dev/null; then
      echo "DHCP Relay sudah aktif."
    else
      dhcrelay -d -4 -iu eth4 -id eth2 -id eth3 \
        192.240.4.10 > /tmp/relay.log 2>&1 &
      sleep 1

      if pgrep -x dhcrelay >/dev/null; then
        echo "DHCP Relay berhasil dipulihkan."
      else
        echo "Gagal menjalankan DHCP Relay."
        tail -n 10 /tmp/relay.log
        exit 1
      fi
    fi
    ;;

  status)
    if pgrep -af dhcrelay; then
      echo "DHCP Relay AKTIF."
    else
      echo "DHCP Relay TIDAK AKTIF."
    fi
    ;;

  *)
    echo "Penggunaan:"
    echo "sh /root/soal9_jichi.sh stop"
    echo "sh /root/soal9_jichi.sh start"
    echo "sh /root/soal9_jichi.sh status"
    ;;
esac

echo "=== SOAL 9 SELESAI ==="
