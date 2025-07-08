#!/usr/bin/env bash
# Cleans up all firewall, routes, firewall marks, IPsets, services & files

set -e

echo "Flushing iptables..."
iptables -t nat    -F
iptables -t mangle -F

echo "Removing ip rule & route..."
ip rule del fwmark 1 table vpnroute || true
ip route flush table vpnroute       || true

echo "Destroying IPSet..."
ipset destroy vpn_udp_cidrs         || true

echo "Stopping services..."
systemctl stop openvpn nginx || true

echo "Disabling services..."
systemctl disable opnvpn nginx || true

echo "Removing files..."
rm -f /etc/openvpn/client/config.ovpn
rm -f /etc/nginx/nginx.conf /etc/nginx/vpn_domains.map
rm -f /usr/local/bin/vpn_monitor.sh

echo "Done."
