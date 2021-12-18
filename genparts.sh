#!/bin/bash
#
# Generate all the possible parts .scad files
#
# There are currently 3 distinct parts:
#
# top   The top half of the enclosure
# base  The bottom half of the enclosure
# plate The front/back plates
#
# There are 6 boolean options available:
# topCutouts      Cutout top access points for cables to go though
# snacCutout      Optional cutout under the SNAC port / dust cover
# baseCutouts     Optional base access points for cables to go though, for stacking
# topPegs         Add pegs on top to stop MMS from sliding off
# backFaceplate   Faceplate at back
# frontFaceplate  Faceplate at front
#
# Not all of these apply to each core part:
#
# top:    topCutouts, snacCutout, topPegs, backFaceplate, frontFaceplate
# base:   baseCutouts, backFaceplate, frontFaceplate
# plate:
#
# Any option not used must be set to 0 to stop warnings when making the stl's

# Generate the .scad filename
genFilename() {
  name="$1"
  if [[ $tc -eq 1 ]]; then name="${name}_tc"; fi
  if [[ $sc -eq 1 ]]; then name="${name}_sc"; fi
  if [[ $tp -eq 1 ]]; then name="${name}_tp"; fi
  if [[ $bc -eq 1 ]]; then name="${name}_bc"; fi
  if [[ $bf -eq 1 ]]; then name="${name}_bf"; fi
  if [[ $ff -eq 1 ]]; then name="${name}_ff"; fi
  if [[ $arg -eq 1 ]]; then name="${name}_${arg}"; fi
  echo "parts/${name}.scad"
}

# Generate the .scad file
genScad() {
  fileName="$1"
  part="$2"

  (
    echo "/* $fileName generated $(date) */"
    echo "topCutouts = $tc;"
    echo "snacCutout = $sc;"
    echo "baseCutouts = $bc;"
    echo "topPegs = $tp;"
    echo "backFaceplate = $bf;"
    echo "frontFaceplate = $ff;"
    echo "include <../global.scad>;"
    echo "include <../enclosure.scad>;"
    echo "${part}(${arg});"

    # Empty hooks to stop warnings
    echo "module enclosureRemoveBefore() {}"
    echo "module enclosureAdd() {}"
    echo "module enclosureRemoveAfter() {}"

  ) >$fileName

  touch -r enclosure.scad $fileName
}

# Generate top, 5 entries
for i in $(seq 0 $(((1 << 5) - 1))); do
  # The possible options, unused ones are set to 0 and not part of the sequence
  tc=$(((i & 1) == 1))
  sc=$(((i & 2) == 2))
  tp=$(((i & 4) == 4))
  bc=0
  bf=$(((i & 8) == 8))
  ff=$(((i & 16) == 16))
  arg=""

  genScad $(genFilename "top") "top"
done

# Generate base, 3 entries
for i in $(seq 0 $(((1 << 3) - 1))); do
  # The possible options, unused ones are set to 0 and not part of the sequence
  tc=0
  sc=0
  tp=0
  bc=$(((i & 1) == 1))
  bf=$(((i & 2) == 2))
  ff=$(((i & 4) == 4))
  arg=""

  genScad $(genFilename "base") "base"
done

# Misc parts
tc=0
sc=0
tp=0
bc=0
bf=0
ff=0
arg=""

# Faceplates
genScad $(genFilename "plate") "faceplatePlain"
genScad $(genFilename "faceplateFlush") "faceplateFlush"

# Pegs to hold MMS to top
genScad $(genFilename "pegs") "genPegs"
