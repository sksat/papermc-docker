#!/bin/sh

# datasource=github-releases depName=itzg/mc-monitor
MC_MONITOR_VERSION="0.10.3"

mkdir mc-monitor
cd mc-monitor
wget "https://github.com/itzg/mc-monitor/releases/download/${MC_MONITOR_VERSION}/mc-monitor_${MC_MONITOR_VERSION}_linux_amd64.tar.gz" -O mc-monitor.tar.gz
ls
tar -xzvf mc-monitor.tar.gz
ls mc-monitor
