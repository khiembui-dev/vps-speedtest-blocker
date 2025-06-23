#!/bin/bash

echo "[+] Blocking SpeedTest, Fast.com, and similar tools..."

DOMAINS=(
  "speedtest.net"
  "www.speedtest.net"
  "fast.com"
  "www.fast.com"
  "speed.nperf.com"
  "nperf.com"
)

for domain in "${DOMAINS[@]}"; do
  if ! grep -q "$domain" /etc/hosts; then
    echo "127.0.0.1 $domain" >> /etc/hosts
    echo "[+] Added $domain to /etc/hosts"
  fi
done

PORTS=( 5201 8080 8081 8888 7547 )

for port in "${PORTS[@]}"; do
  iptables -A INPUT -p tcp --dport $port -j DROP
  iptables -A INPUT -p udp --dport $port -j DROP
  iptables -A OUTPUT -p tcp --dport $port -j DROP
  iptables -A OUTPUT -p udp --dport $port -j DROP
  echo "[+] Blocked port $port (TCP/UDP)"
done

if command -v netfilter-persistent &> /dev/null; then
  netfilter-persistent save
  echo "[✔] Saved iptables rules"
elif command -v iptables-save &> /dev/null; then
  iptables-save > /etc/iptables.rules
  echo "[!] Saved iptables manually to /etc/iptables.rules"
fi

echo "[✅] Done. SpeedTest & Fast.com blocked. Cloudflare untouched."
