#!/bin/bash

echo "🔒 Đang tiến hành nâng cấp chặn các công cụ đo tốc độ mạng..."

# --- I. Sao lưu cấu hình hiện tại ---
cp /etc/hosts /etc/hosts.backup.$(date +%s)

# --- II. Tạo hoặc cập nhật cấu hình dnsmasq (nếu có) ---
DNSMASQ_CONF="/etc/dnsmasq.d/block_speedtest.conf"

echo "[+] Cấu hình dnsmasq để chặn wildcard domain..."

cat > "$DNSMASQ_CONF" <<EOF
address=/.speedtest.net/127.0.0.1
address=/.speedtestcustom.com/127.0.0.1
address=/.ooklaserver.net/127.0.0.1
address=/.nperf.com/127.0.0.1
address=/.fast.com/127.0.0.1
address=/.prod.fastly.net/127.0.0.1
EOF

# Khởi động lại dnsmasq nếu có
if systemctl is-active --quiet dnsmasq; then
    systemctl restart dnsmasq
else
    echo "[!] dnsmasq chưa được cài. Cài bằng: apt install dnsmasq -y"
fi

# --- III. Chặn các cổng đo tốc độ phổ biến ---
echo "[+] Chặn các cổng đo tốc độ phổ biến..."

ports_to_block=(5201 8080 5060 5061 5070 5080 5100)

for port in "${ports_to_block[@]}"; do
    iptables -C OUTPUT -p tcp --dport $port -j DROP 2>/dev/null || iptables -A OUTPUT -p tcp --dport $port -j DROP
    iptables -C OUTPUT -p udp --dport $port -j DROP 2>/dev/null || iptables -A OUTPUT -p udp --dport $port -j DROP
done

# --- IV. Chặn các dải IP thường xuyên dùng để đo (có thể cập nhật động sau) ---
echo "[+] Chặn các subnet thường dùng cho đo tốc độ..."

ip_to_block=(
    "185.13.160.0/22"   # Ookla
    "185.13.164.0/22"   # Ookla
    "151.101.0.0/16"    # Fastly (chỉ dùng cho Fast.com app)
)

for iprange in "${ip_to_block[@]}"; do
    iptables -C OUTPUT -d $iprange -j DROP 2>/dev/null || iptables -A OUTPUT -d $iprange -j DROP
done

# --- V. Lưu lại iptables ---
echo "[+] Lưu iptables rules..."

if command -v netfilter-persistent &>/dev/null; then
    netfilter-persistent save
elif command -v iptables-save &>/dev/null; then
    iptables-save > /etc/iptables/rules.v4
fi

echo "✅ Hoàn tất! Đã chặn Speedtest, Fast.com, nPerf một cách triệt để mà không ảnh hưởng dịch vụ khác."
