/*
 * A simple expansion enclosure for the MISTer Multi System (MMS)
 *
 * This file generates the top STL of the enclosure.
 */

// Options, set to 1 to enable, 0 to disable
topCutouts = 1;     // Cutout top access points for cables to go though
snacCutout = 0;     // Optional cutout under the SNAC port / dust cover
baseCutouts = 0;    // Optional base access points for cables to go though, for stacking
topPegs = 1;        // Add pegs on top to stop MMS from sliding off
backFaceplate = 1;  // Faceplate at back
frontFaceplate = 0; // Faceplate at front

include <../global.scad>;
include <../enclosure.scad>;

top();
