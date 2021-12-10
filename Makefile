# Makefile to generate the various STL's

export BUILD		= $(shell pwd)/build
export OPENSCAD     = openscad

.PHONY: all clean

all:
	@mkdir -pv $(BUILD)
	@$(MAKE) -C parts all

clean:
	@$(RM) -r $(BUILD)
