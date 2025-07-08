# VPN-Aware TCP/UDP Router for LAN

This project turns any Linux machine into a smart VPN router that:

- Routes **specific domains** over VPN using Nginx + TCP SNI detection
- Routes **UDP/QUIC traffic** (e.g. YouTube) by **IP CIDRs** via `ipset`
- Works transparently for all devices on your LAN
- Supports **Debian**, **Ubuntu**, **Arch**, **AlmaLinux/RHEL**
- Fully automated via **Ansible** and **Makefile**

## ✨ Features

- ♻ TCP 80/443 redirection to Nginx
- 🔍 Domain-based SNI detection via Nginx `stream` + `ssl_preread`
- 🌍 CIDR-based UDP-443 matching via `ipset`
- 🔄 VPN watchdog (auto-restarts OpenVPN if needed)
- ♻ Full uninstall and cleanup
- 📦 Multi-distro support with `apt`, `dnf`, `pacman`

## 🧰 Requirements

- Ansible
- Make
- Openvpn client config

| Host Distro | Install Command |
| --- | --- |
| Debian/Ubuntu | `sudo apt install ansible make` |
| Arch Linux | `sudo pacman -S ansible base-devel` |
| AlmaLinux / RHEL | `sudo dnf install ansible make` |

You must also have Python 3 (already present on most systems).

## 📁 Repo Structure

```
.
├── Makefile                # Easy CLI for deploy/uninstall/lint
├── ansible.cfg
├── inventory.ini           # Defines localhost target
├── playbook.yml           # Main Ansible playbook
├── domains.txt            # List of domains to VPN via TCP
├── udp_cidrs.txt         # List of CIDRs to VPN via UDP
├── templates/
│   ├── nginx.conf.j2
│   ├── vpn_domains.map.j2
│   └── vpn_monitor.sh.j2
├── vpn_uninstall.sh
├── LICENSE
└── README.md
```

## 🚀 Quick Start

1. **Clone the repo**
```bash
git clone https://github.com/rookieslav/handy-repo-vpn-router.git
cd handy-repo-vpn-router
```

2. **Fill in `domains.txt` and `udp_cidrs.txt`**
- `domains.txt`: one domain per line (e.g. `youtube.com`)
- `udp_cidrs.txt`: one CIDR per line (e.g. `142.250.0.0/15`)

3. **Run deployment**
```bash
make deploy
```

You'll be prompted for:
- LAN interface (e.g. `eth0`)
- Path to your `.ovpn` config
- Default gateway (e.g. `192.168.1.1`)

## 🔎 Validate Files

```bash
make check
```
- Checks `domains.txt` for valid FQDNs
- Checks `udp_cidrs.txt` for valid CIDRs

## 🗑️ Uninstall & Cleanup

```bash
make uninstall
```
Removes all iptables rules, ipset sets, VPN routing config, and restarts services.

## 🙏 Credits

- Domains restricted in Russia were sourced from [Re:filter](https://github.com/1andrevich/Re-filter-lists) by @1andrevich (MIT License)
- CIDR blocks for YouTube were sourced from [wikitwist.com](https://wikitwist.com/list-of-ip-youtube)

