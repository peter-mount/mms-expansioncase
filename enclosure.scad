/*
 * A simple expansion enclosure for the MISTer Multi System (MMS)
 */
use <roundedcube.scad>;

// Components to view, set to 0 to hide
showTop = 1;        // Show top half of enclosure
showBase = 0;       // Show bottom half of enclosure
showMMSBase = 1;    // Requires part_c_61-23038_1_multisystem_base_3d_rtp.stl but shows it above the top for alignment
topCutouts = 1;     // Cutout top access points for cables to go though
snacCutout = 1;     // Optional cutout under the SNAC port / dust cover

// Fixed dimensions of the MMS case
width = 203;
depth = 175;

// Height of the expansion enclosure - this can be adjusted as required.
// Note: this is the external size, internal clearance is 2 * wallThick maximum and that doesn't include any
// internal structures.
height = 50;

// The position where the two halves divide, normally half way down the enclosure
divideHeight = height / 2;

// Thickness of walls
wallThick = 3;
wallThick2 = wallThick * 2;

// Best not change anything below this point
width2 = width / 2;       // Half of width
depth2 = depth / 2;       // Half of depth

// Main enclosure
module enclosure() {
    difference() {
        // Hollow rounded cube
        roundedcube([width, depth, height], radius = 3);
        translate([wallThick, wallThick, wallThick])
            cube([width - wallThick2, depth - wallThick2, height - wallThick2]);

        if (topCutouts) {
            // Remove left cable access point
            translate([6, 80, height - 5]) cube([13, 25, 5]);

            // Remove right cable access point
            translate([189, 36, height - 5]) cube([9, 20, 5]);
        }

        if (snacCutout) {
            // Remove optional front access point under dust cover
            translate([width2 - 35, 9, height - 5]) cube([70, 20, 5]);
        }
    }
}

module top() {
    difference() {
        enclosure();
        translate([- 1, - 1, - 1]) cube([width + 2, depth + 2, divideHeight + 2]);
    };
}

module base() {
    difference() {
        enclosure();
        translate([- 1, - 1, divideHeight]) cube([width + 2, depth + 2, divideHeight + 2]);
    };
}

// Show the major components
if (showTop) {
    top();
}

if (showBase) {
    translate([0, 0, - 5]) base();
}

if (showMMSBase) {
    translate([221, 67, height + 1]) import("part_c_61-23038_1_multisystem_base_3d_rtp.stl");
}

