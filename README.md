# VPS SpeedTest Blocker 🚫⚡

A simple bash script to **block all known speed test services** (like `speedtest.net`, `fast.com`, `nperf.com`) on your Linux VPS.  
Useful for **preventing users from testing and leaking port speeds** when sharing tunneling/VPN.

---

## ✅ Features

- Block domains: `speedtest.net`, `fast.com`, `nperf.com`
- Block common ports used by `iperf3` and browser-based testers
- Safe: Does **not block Cloudflare**, YouTube, or general internet access
- Easy to run on any VPS

---

## 🚀 Quick Install

Run this command on your VPS:

```bash
bash <(curl -sSL https://raw.githubusercontent.com/khiembui-dev/vps-speedtest-blocker/main/block_speedtest_safe.sh)
