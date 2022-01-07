/*
 * Faceplate for the Minisynth32
 */

topCutouts = 0;
snacCutout = 0;
baseCutouts = 0;
topPegs = 0;
backFaceplate = 0;
frontFaceplate = 0;

include <../../global.scad>;
include <../../enclosure.scad>;

module enclosureRemoveBefore() {}
module enclosureAdd() {}
module enclosureRemoveAfter() {}

// Here we cut out a hole in our standard flush faceplate then place face.stl in place
union() {
    translate([17.5, .25 + wallThick / 2, wallThick + 1]) {
        difference() {
            faceplateBlank(1);
            translate([10,-3,12]) cube([140,30,19]);
        }
    }
    translate([26, 0, 10]) rotate([30, 0, 0]) translate([0, 5.5, 0]) import("face.stl");
}
