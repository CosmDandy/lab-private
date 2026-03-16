JSONNET ?= jsonnet
SOURCES := $(wildcard client-*.jsonnet)
TARGETS := $(SOURCES:.jsonnet=.json.tpl)

.PHONY: all clean

all: $(TARGETS)

%.json.tpl: %.jsonnet lib/outbounds.libsonnet lib/route.libsonnet
	$(JSONNET) -o $@ $<

clean:
	rm -f $(TARGETS)
