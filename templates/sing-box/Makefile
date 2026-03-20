JSONNET    ?= jsonnet
CONFIGS_DIR := ../../configs/vpn

SOURCES := $(wildcard $(CONFIGS_DIR)/*/sing-box/client-*.jsonnet)
TARGETS := $(SOURCES:.jsonnet=.json.tpl)

.PHONY: all clean

all: $(TARGETS)

%.json.tpl: %.jsonnet lib/outbounds.libsonnet lib/route.libsonnet
	$(JSONNET) --jpath $(CURDIR) -o $@ $<

clean:
	rm -f $(TARGETS)
