/*
 * A simple expansion enclosure for the MISTer Multi System (MMS)
 */
use <roundedcube.scad>;

// Components to view, set to 0 to hide
showTop = 0;        // Show top half of enclosure
showBase = 1;       // Show bottom half of enclosure
showMMSBase = 0;    // Requires part_c_61-23038_1_multisystem_base_3d_rtp.stl but shows it above the top for alignment
topCutouts = 1;     // Cutout top access points for cables to go though
snacCutout = 0;     // Optional cutout under the SNAC port / dust cover

separation = 1;     // Separation of components when showing multiple in an exploded view

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
    union() {
        difference() {
            // Hollow rounded cube
            roundedcube([width, depth, height], radius = 3);
            translate([wallThick, wallThick, wallThick])
                cube([width - wallThick2, depth - wallThick * 3, height - wallThick2]);

            // Cutout the fan & grille
            fan();
            grille();

            // Cutout the back plate
            translate([10, depth - wallThick * 3, wallThick2]) {
                cube([width - 20, wallThick2 * 2, height - 2 * wallThick2]);
            }
            translate([7, depth - wallThick * 1.5, wallThick * 1.25]) {
                cube([width - 14, wallThick, height - wallThick2]);
            }

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

        // Support struts, identical on top and bottom
        for (z = [wallThick - 0.2, height - wallThick - 0.5]) {
            translate([0, 0, z]) struts();
        }
    }
}

module struts() {

    // The cross struts
    dw = width - wallThick2;
    dh = depth - wallThick2;
    pl = sqrt((dw * dw) + (dh * dh));
    pa = atan2(dw, dh);

    translate([wallThick, wallThick, 0])
        rotate([0, 0, - pa])
            cube([3, pl, 2]);
    translate([width - wallThick, wallThick, 0])
        rotate([0, 0, pa])
            cube([3, pl, 2]);

    // Horiz/Vert struts
    for(x=[width2/2, width2 + (wallThick / 4), width2*3/2]) {
        translate([x, wallThick, 0]) cube([3, dh - wallThick, 2]);
    }

    translate([wallThick, depth2/2, 0]) cube([dw-12, 3, 2]);
    translate([wallThick+18, depth2 - (wallThick / 2), 0]) cube([dw-18, 3, 2]);
    translate([wallThick, depth2*3/2, 0]) cube([dw, 3, 2]);
}

// The fan
module fan() {
    translate([width - wallThick2, depth2 - 1, height / 2]) {
        // Screw holes
        m1 = 16.25;
        for (x = [- 1, 1]) {
            for (y = [- 1, 1]) {
                translate([4, m1 * x, m1 * y]) rotate([0, 90, 0]) {
                    cylinder(r1 = 2.5, r2 = 4.5, h = 3);
                    translate([0, 0, - 4]) cylinder(r = 2.5, h = 8);
                }
            }
        }

        // Air holes
        for (y = [1:6]) {
            c = 8 - y;
            dx = (c / 2) * 6;
            for (z = [1, - 1]) {
                for (x = [1:c]) {
                    translate([0, - 4 - dx + (6 * x), 3 * y * z])
                        rotate([0, 90, 0]) cylinder(r = 1.5, h = 8);
                }
            }
        }
    }
}

// The "grille" on the left hand side
module grille() {
    prad = PI / 180;
    for (x = [0: 9]) {
        dy = 6 + (divideHeight * .4 * sin(20 * x));
        for (z = [- 1, 1]) {
            for (y = [0:3]) {
                translate([- 1, 15 + 36 * y + 4 * x, divideHeight + dy * z])
                    rotate([0, 90, 0]) cylinder(r = 1.5, h = 8);
            }
        }
    }
}

// The top of the enclosure
module top() {
    difference() {
        enclosure();
        translate([- 1, - 1, 0])  cube([width + 2, depth + 2, divideHeight]);
    };
}

// The base of the enclosure
module base() {
    difference() {
        enclosure();
        translate([- 1, - 1, divideHeight])cube([width + 2, depth + 2, divideHeight]);
    };
}

// Show the major components
if (showTop) {
    translate([0, 0, separation]) top();
}

if (showBase) {
    base();
}

if (showMMSBase) {
    translate([221, 67, height + 2 * separation]) import("part_c_61-23038_1_multisystem_base_3d_rtp.stl");
}

