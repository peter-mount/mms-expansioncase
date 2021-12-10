# Makefile to generate the various STL's

# We require OpenSCAN 2021.01 for binary STL's
#
# If you want to use an earlier version without binary stl support then change
# this to that instance and remove "--export-format binstl" from OPENSCAD_OPTS
#
export OPENSCAD      = OpenSCAD-2021.01-x86_64.AppImage
export OPENSCAD_OPTS = --export-format binstl

# Location of built stl's
export BUILD		= $(shell pwd)/build

.PHONY: all clean

all:
	@mkdir -pv $(BUILD)
	@$(MAKE) -C parts all

clean:
	@$(RM) -r $(BUILD)
