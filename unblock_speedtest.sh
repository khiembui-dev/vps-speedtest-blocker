#!/bin/bash

echo "[🧹] Unblocking SpeedTest, Fast.com, and related services..."

# Danh sách domain cần xóa khỏi /etc/hosts
DOMAINS=(
  "speedtest.net"
  "www.speedtest.net"
  "fast.com"
  "www.fast.com"
  "speed.nperf.com"
  "nperf.com"
)

# Xóa dòng khỏi /etc/hosts
for domain in "${DOMAINS[@]}"; do
  sed -i "/$domain/d" /etc/hosts
  echo "[✔] Removed $domain from /etc/hosts"
done

# Danh sách port đã block cần mở lại
PORTS=( 5201 8080 8081 8888 7547 )

for port in "${PORTS[@]}"; do
  iptables -D INPUT  -p tcp --dport $port -j DROP 2>/dev/null
  iptables -D INPUT  -p udp --dport $port -j DROP 2>/dev/null
  iptables -D OUTPUT -p tcp --dport $port -j DROP 2>/dev/null
  iptables -D OUTPUT -p udp --dport $port -j DROP 2>/dev/null
  echo "[✔] Unblocked port $port (TCP/UDP)"
done

# Lưu iptables nếu có netfilter-persistent
if command -v netfilter-persistent &> /dev/null; then
  netfilter-persistent save
  echo "[✔] Saved iptables rules"
elif command -v iptables-save &> /dev/null; then
  iptables-save > /etc/iptables.rules
  echo "[!] Saved iptables manually to /etc/iptables.rules"
fi

echo "[✅] Unblock completed."
