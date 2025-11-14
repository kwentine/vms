SHELL=/bin/env bash
NET_DIR=scripts/net
QVM_DIR ?= /var/vms
QVM_RUNTIME_DIR := $(QVM_DIR)/run
VMS=cp wk1 wk2

firewall:
	$(SHELL) $(NET_DIR)/host-setup.sh
bridge:
	$(SHELL) scripts/qvm-bridge
dns-logs:
	@journalctl -b --no-pager SYSLOG_IDENTIFIER=dnsmasq
clean:
	@rm -f $(QVM_RUNTIME_DIR)/dnsmasq.pcap

localds:
	$(SHELL) scripts/qvm-localds $(VMS)

clean-localds:
	cd $(QVM_DIR)/localds && rm -f $(addsuffix .img, $(VMS))
