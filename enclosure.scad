/*
 * A simple expansion enclosure for the MISTer Multi System (MMS)
 */
use <roundedcube.scad>;

// Fixed dimensions of the MMS case
width = 203;
depth = 175;

divideHeight = height / 2;      // Position where the two halves divides

wallThick = 3;                  // Thickness of walls
wallThick2 = wallThick * 2;

width2 = width / 2;             // Half of width
depth2 = depth / 2;             // Half of depth

// Main enclosure
module enclosure() {
    difference() {
        union() {
            difference() {
                // Rounded cube with the rear top & bottom edges flat for belt printers
                hull() {
                    roundedcube([width, depth, height], radius = 3);
                    translate([3, depth - 3, height-10]) cube([width - 6, 3, 10]);
                    translate([3, depth - 3, 0]) cube([width - 6, 3, 10]);
                }

                // Hollow the hull
                // If we do not have a faceplate visible then the wall needs to be thinner
                translate([wallThick, frontFaceplate?wallThick2:wallThick, wallThick])
                    cube([width - wallThick2,
                            depth - wallThick * (2 + frontFaceplate + backFaceplate),
                            height - wallThick2]);

                // Cutout the fan & grille
                fan();
                grille();

                // Cutout the back plate
                if (backFaceplate) {
                    translate([0, depth - wallThick * 3, 0]) faceplate();
                }
                if (frontFaceplate) {
                    translate([0, - wallThick, 0]) faceplate();
                }

                if (topCutouts) {
                    cutouts(height);
                }

                if (baseCutouts) {
                    cutouts(4);
                }

                if (snacCutout) {
                    // Remove optional front access point under dust cover
                    translate([width2 - 35, 9, height - 5]) cube([70, 20, 5]);
                }

                // Text on inside
                for (y = [20, height - 20]) {
                    translate([wallThick - 1, depth2 - 17, y]) rotate([90, 0, 90]) letter("Area51.dev", 4);
                    translate([wallThick - 1, depth2 + 17, y]) rotate([90, 0, 90]) letter("V1", 4);
                }

                translate([width2, 20, wallThick - 1]) letter("MMS Expansion Unit", 4);

                // Hook to cut out of enclosure
                enclosureRemoveBefore();
            }

            // Support struts, identical on top and bottom
            for (z = [wallThick - 0.2, height - wallThick - 1.5]) {
                translate([0, 0, z]) struts();
            }

            posts(0);

            enclosureAdd();
        }
        posts(1);

        // Hook to cut out of enclosure
        enclosureRemoveAfter();
    }
}

module letter(l, size = 10) {
    // Use linear_extrude() to make the letters 3D objects as they
    // are only 2D shapes when only using text()
    linear_extrude(height = 3) {
        text(l, size = size, font = font, halign = "center", valign = "center", $fn = 16);
    }
}
// Faceplate, normally at the back but can be at the front as well
module faceplate() {
    translate([20, 0, wallThick2]) {
        cube([width - 40, wallThick2 * 2, height - 2 * wallThick2]);
    }
    translate([17, wallThick * 1.5, wallThick * 1.25]) {
        cube([width - 34, wallThick, height - wallThick2]);
    }
}

// The internal posts for attaching the two halves
module posts(type) {
    if (type) {
        // bolt holes - these match the pegs
        for (x = [6.5, width - 6]) {
            for (y = [11.5, depth - 13]) {
                translate([x, y, - 1]) {
                    // Use h = height + 2 to expose hole through top
                    cylinder(r = 1, h = height - 1, $fn = 16);

                    // Wider on bottom so bolt is shorter & recessed
                    cylinder(r = 3, h = 11, $fn = 16);
                }
            }
        }
    } else {
        // posts
        w = 9;
        d = 16;
        for (x = [2, width - 2 - w]) {
            for (y = [2, depth - 2 - d]) {
                translate([x, y, 1]) cube([w, d, height - 4]);
            }
        }
    }
}

// Top pegs allows the MMS to sit on top but not slide off
// type=1 for a hole, 0 for the peg
module topPegs(type) {
    translate([0, 0, height - 4])
        for (x = [6.5, width - 6]) {
            for (y = [11.5, depth - 13]) {
                translate([x, y, 0])
                    cylinder(r = type?2.8:2.2, h = 8, $fn = 16);
            }
        }
}

// joinPegs adds little pegs to align the two halves
// top==1 for the top hole, 0 for the bottom peg
module joinPegs(top) {
    translate([0, 0, divideHeight - 1])
        for (x = [6.5, width - 6]) {
            for (y = [5.5, depth - 7]) {
                translate([x, y, 0])
                    if (top) {
                        cylinder(r = 3.25, h = 10, $fn = 16);
                    } else {
                        cylinder(r = 3, h = 5, $fn = 16);
                    }
            }
        }
}

// The cutouts matching those on the base of the MMS case
module cutouts(h) {
    // Remove left cable access point
    translate([6, 80, h - 5]) cube([13, 25, 5]);

    // Remove right cable access point
    translate([189, 36, h - 5]) cube([9, 20, 5]);
}

// Struts on the inside of the top & bottom surfaces.
// Partially for strength but also for looks.
// Both are mirrored so some go around non-existend cutouts on the bottom where they appear on the top.
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

    // vertical struts
    translate([width2 / 2 + 1, wallThick2, 0]) cube([3, dh - wallThick2, 2]);
    translate([width2 + (wallThick / 4), wallThick2 + 37, 0]) cube([3, dh - wallThick2 - 37, 2]);
    translate([width2 * 3 / 2 + 1, wallThick2, 0]) cube([3, dh - wallThick2, 2]);

    // Horizontal struts
    translate([wallThick, depth2 / 2 - 1, 0]) cube([dw - 15, 3, 2]);
    translate([wallThick + 20, depth2 - (wallThick / 2), 0]) cube([dw - 18 - 25, 3, 2]);
    translate([wallThick, depth2 * 3 / 2 - 2, 0]) cube([dw, 3, 2]);

    // topCutouts
    translate([width - 20, 18, 0]) cube([wallThick, 43, 2]);
    translate([width - 20, 29, 0]) cube([19, 3, 2]);

    translate([23, depth2 - 15, 0]) cube([3, 39, 2]);
    translate([2, depth2 - 15, 0]) cube([23, 3, 2]);
    translate([2, depth2 + 21, 0]) cube([23, 3, 2]);

    // fan mount on the inside of the case
    translate([width - 24.5 - wallThick, depth2, 0]) {
        translate([0, 22, 0]) cube([24.5, wallThick, 2]);
        translate([0, - 22 - wallThick2, 0]) cube([24.5, wallThick, 2]);
        translate([0, - 22 - wallThick2, 0]) cube([wallThick, 50, 2]);
    }
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
        for (z = [1, - 1]) {
            for (y = [1:6]) {
                c = 8 - y;
                dx = (c / 2) * 6;
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
    for (x = [0: 8]) {
        dy = 6 + (divideHeight * .4 * sin(20 * x));
        for (y = [0:3]) {
            // Don't generate first one as it's blocked by a post
            if (!(x == 0 && y == 0)) {
                for (z = [- 1, 1]) {
                    translate([- 1, 15.5 + 36 * y + 4 * x, divideHeight + dy * z])
                        rotate([0, 90, 0]) cylinder(r = 1.5, h = 8);
                }
            }
        }
    }
}

// The top of the enclosure
module top() {
    difference() {
        enclosure();

        // cut out bottom half
        translate([- 1, - 1, - 1])  cube([width + 2, depth + 2, divideHeight + 1]);

        // Cut out holes for the pegs
        joinPegs(1);
        topPegs(1);
    };

    // Show the pegs between top & MMS
    if (showMMSBase) {
        topPegs(0);
    }
}

// The base of the enclosure
module base() {
    union() {
        difference() {
            enclosure();

            // Cut out top half
            translate([- 1, - 1, divideHeight]) cube([width + 2, depth + 2, divideHeight]);

            translate([- 1, - 1, divideHeight])cube([width + 2, depth + 2, divideHeight]);
        }
        joinPegs(0);
    }
}
