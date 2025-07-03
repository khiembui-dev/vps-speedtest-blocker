#!/bin/bash

echo "🔒 Đang tiến hành chặn các công cụ đo tốc độ mạng..."

# Backup file /etc/hosts
cp /etc/hosts /etc/hosts.backup.$(date +%s)

# Danh sách domain liên quan tới speedtest
domains_to_block=(
    "speedtest.net"
    "www.speedtest.net"
    "speedtestcustom.com"
    "fast.com"
    "www.fast.com"
    "nperf.com"
    "www.nperf.com"
    "ooklaserver.net"
    "prod.fastly.net"
)

# Chặn domain qua /etc/hosts
for domain in "${domains_to_block[@]}"; do
    if ! grep -q "$domain" /etc/hosts; then
        echo "127.0.0.1 $domain" >> /etc/hosts
    fi
done

# Chặn các cổng thường dùng bởi ứng dụng đo tốc độ
ports_to_block=(5201 8080 5060 5061 5070 5080 5100)

for port in "${ports_to_block[@]}"; do
    iptables -A OUTPUT -p tcp --dport $port -j DROP
    iptables -A OUTPUT -p udp --dport $port -j DROP
done

# Chặn các IP/subnet phổ biến dùng đo tốc độ (Netflix CDN, Speedtest CDN)
ip_to_block=(
    "23.246.0.0/18"     # Netflix
    "45.57.0.0/17"      # Netflix
    "64.120.128.0/17"   # Netflix
    "151.101.0.0/16"    # Fastly CDN (fast.com)
    "185.13.160.0/22"   # Ookla
    "185.13.164.0/22"   # Ookla
)

for iprange in "${ip_to_block[@]}"; do
    iptables -A OUTPUT -d $iprange -j DROP
done

# Lưu lại iptables nếu có persistent
if command -v netfilter-persistent &>/dev/null; then
    netfilter-persistent save
elif command -v iptables-save &>/dev/null; then
    iptables-save > /etc/iptables/rules.v4
fi

echo "✅ Đã hoàn tất chặn Speedtest, Fast.com, nPerf và ứng dụng liên quan."
