# Makefile to generate the various STL's
#
# When running, if you have the CPU & RAM, run this with -jX where
# X is the number of concurrent render's you want to run.
#


# We require OpenSCAN 2021.01 for binary STL's
#
# If you want to use an earlier version without binary stl support then change
# this to that instance and remove "--export-format binstl" from OPENSCAD_OPTS
#
export OPENSCAD      = OpenSCAD-2021.01-x86_64.AppImage
export OPENSCAD_OPTS = --export-format binstl

# Location of built stl's
export BUILD		= $(shell pwd)/build

.PHONY: all clean genparts $(BUILD) archive

all: archive

parts: $(BUILD) genparts
	@$(MAKE) -C parts all

genparts:
	@./genparts.sh

$(BUILD):
	@mkdir -pv $(BUILD)

clean:
	@$(RM) -r $(BUILD)
	@$(MAKE) -C parts clean

archive: parts $(BUILD)/mms_enclosure.zip $(BUILD)/mms_enclosure.tgz

$(BUILD)/mms_enclosure.zip: parts
	@$(RM) $@
	zip -r $@ README.md build/*.stl
$(BUILD)/mms_enclosure.tgz: parts
	@$(RM) $@
	tar cvzpf $@ README.md build/*.stl
