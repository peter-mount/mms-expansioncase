# Makefile to generate STL's for the top of the enclosure
.PHONY: all

STLS := $(patsubst %.scad,$(BUILD)/%.stl,$(wildcard *.scad))

all: $(STLS)

clean:
	@$(RM) *.scad

$(BUILD)/%.stl: %.scad
	@echo $<
	@$(OPENSCAD) $(OPENSCAD_OPTS) -o $@ $<
