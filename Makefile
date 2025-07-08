ANSIBLE ?= ansible-playbook
INVENTORY := inventory.ini
PLAYBOOK := playbook.yml
UNINSTALL := vpn_uninstall.sh

.PHONY: all deploy uninstall clean check

all: deploy

deploy:
	$(ANSIBLE) -i $(INVENTORY) --ask-become-pass $(PLAYBOOK)

uninstall:
	sudo $(UNINSTALL)

clean:
	sudo iptables -t nat -F
	sudo iptables -t mangle -F
	sudo ipset destroy vpn_udp_cidrs || true
	sudo ip rule del fwmark 1 table vpnroute || true
	sudo ip route flush table vpnroute || true

check:
	@echo "Checking domains.txt:"
	@grep -Pv '^[a-zA-Z0-9.-]+$' domains.txt && echo "[X] Invalid domains!" || echo "OK"
	@echo "\nChecking udp_cidrs.txt:"
	@grep -Pv '^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$' udp_cidrs.txt && echo "[X] Invalid CIDRs!" || echo "OK"
