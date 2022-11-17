#!/bin/sh

# datasource=github-releases depName=itzg/mc-monitor
MC_MONITOR_VERSION="0.11.0"

MC_MONITOR_ARCH="amd64"
case $(uname -m) in
	x86_64) MC_MONITOR_ARCH="amd64" ;;
	aarch64) MC_MONITOR_ARCH="arm64" ;;
esac

mkdir mc-monitor
cd mc-monitor
wget "https://github.com/itzg/mc-monitor/releases/download/${MC_MONITOR_VERSION}/mc-monitor_${MC_MONITOR_VERSION}_linux_${MC_MONITOR_ARCH}.tar.gz" -O mc-monitor.tar.gz
ls
tar -xzvf mc-monitor.tar.gz
ls mc-monitor
