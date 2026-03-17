JSONNET    ?= jsonnet
SERVER     ?= vpn-nl
CLIENT_DIR := ../../infra/$(SERVER)/client
SOURCES    := $(wildcard $(CLIENT_DIR)/client-*.jsonnet)
TARGETS    := $(SOURCES:.jsonnet=.json.tpl)

.PHONY: all clean

all: $(TARGETS)

$(CLIENT_DIR)/%.json.tpl: $(CLIENT_DIR)/%.jsonnet lib/outbounds.libsonnet lib/route.libsonnet
	$(JSONNET) --jpath . -o $@ $<

clean:
	rm -f $(CLIENT_DIR)/client-*.json.tpl
