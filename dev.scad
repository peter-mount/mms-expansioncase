/*
 * A simple expansion enclosure for the MISTer Multi System (MMS)
 *
 * This is used with openscad to handle the development of the enclosure.
 * It is also the template for the various files to generate the STL's
 */

// Components to view, set to 0 to hide
showTop = 1;        // Show top half of enclosure
showBase = 0;       // Show bottom half of enclosure
showMMSBase = 0;    // Requires part_c_61-23038_1_multisystem_base_3d_rtp.stl but shows it above the top for alignment

separation = 5;    // Separation of components when showing multiple in an exploded view

// Options, set to 1 to enable, 0 to disable
topCutouts = 1;     // Cutout top access points for cables to go though
snacCutout = 1;     // Optional cutout under the SNAC port / dust cover
baseCutouts = 0;    // Optional base access points for cables to go though, for stacking
topPegs = 1;        // Add pegs on top to stop MMS from sliding off
backFaceplate = 1;  // Faceplate at back
frontFaceplate = 0; // Faceplate at front

// Height of the expansion enclosure - this can be adjusted as required.
// Note: this is the external size, internal clearance is 2 * wallThick maximum and that doesn't include any
// internal structures. Minimum is 50mm for the fan to fit
height = 50;

lipJoin = 0;        // Experimental: Add a lip around the join of the two halves

include <enclosure.scad>;

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
