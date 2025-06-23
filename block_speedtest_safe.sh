#!/bin/bash

echo "🔒 Đang tiến hành chặn các công cụ đo tốc độ mạng..."

# Backup /etc/hosts
cp /etc/hosts /etc/hosts.backup.$(date +%s)

# Chặn domain qua /etc/hosts
domains_to_block=(
    "speedtest.net"
    "www.speedtest.net"
    "fast.com"
    "www.fast.com"
    "nperf.com"
    "www.nperf.com"
)

for domain in "${domains_to_block[@]}"; do
    if ! grep -q "$domain" /etc/hosts; then
        echo "127.0.0.1 $domain" >> /etc/hosts
    fi
done

# Chặn các port phổ biến
# iperf3 mặc định dùng port 5201 (TCP/UDP)
iptables -A INPUT -p tcp --dport 5201 -j DROP
iptables -A INPUT -p udp --dport 5201 -j DROP
iptables -A OUTPUT -p tcp --dport 5201 -j DROP
iptables -A OUTPUT -p udp --dport 5201 -j DROP

# Chặn fast.com (sử dụng domain phụ của Netflix)
# (Tuỳ chọn, không cần nếu chỉ block DNS chính)
# iptables -A OUTPUT -d fast.com -j REJECT

# Lưu iptables (Debian/Ubuntu)
if command -v netfilter-persistent &>/dev/null; then
    netfilter-persistent save
elif command -v iptables-save &>/dev/null; then
    iptables-save > /etc/iptables/rules.v4
fi

echo "✅ Đã chặn xong speedtest.net, fast.com và nperf.com"
