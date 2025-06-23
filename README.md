# 🚫 Script Chặn Các Trang Đo Tốc Độ Mạng Trên VPS Linux

Một công cụ đơn giản giúp bạn **chặn tất cả các trang và ứng dụng đo tốc độ mạng** như:

- 🌐 `speedtest.net`
- ⚡ `fast.com`
- 📶 `nperf.com`
- ⚙️ `iperf3` (port 5201)

✅ Dành cho các VPS đang chia sẻ VPN, SSH, Proxy hoặc cần ẩn thông tin băng thông thật.

---

## 🧩 Tính Năng Chính

- Chặn domain bằng `/etc/hosts`
- Chặn các port thường dùng bởi các công cụ đo tốc độ (TCP & UDP)
- Không chặn các dịch vụ như Cloudflare, YouTube, Facebook
- Có sẵn lệnh **gỡ chặn (unblock)** dễ sử dụng

---

## 🚀 Hướng Dẫn Sử Dụng

### ✅ 1. Chặn toàn bộ speedtest / fast.com

**Chạy lệnh sau trên VPS của bạn:**

```bash
bash <(curl -sSL https://raw.githubusercontent.com/khiembui-dev/vps-speedtest-blocker/main/block_speedtest_safe.sh)
