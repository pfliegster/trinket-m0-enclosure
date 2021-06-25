/////////////////////////////////////////////////////////////////////////////////
//
// File: ada_trnk_m0_constants.scad
//
// Description:
//   Some useful constants for Adafruit "Trinket M0" PWB,
//   derived from EagleCAD board file dimensions (and physical inspection)
//   of Rev D circuit board:
//
//     https://github.com/adafruit/Adafruit-Trinket-M0-PCB
//
// Notes:
// * Original BRD units are Imperial (inches), converted to metric here (mm)
//
// Author: Keith Pflieger
// License: CC BY-NC-SA 4.0
//          (Creative Commons: Attribution-NonCommercial-ShareAlike)
// github: pfliegster (https://github.com/pfliegster)
//
/////////////////////////////////////////////////////////////////////////////////

// Raw PWB Dimensions:
ada_trk_m0_pwb_length =  0.60 * 25.4;
ada_trk_m0_pwb_width  =  1.05 * 25.4;
ada_trk_m0_pwb_height =  0.87; // measured
ada_trk_m0_pwb_shift  = -0.025 * 25.4; // in Y-axis, PWB is slightly off center ...

// Now, let's create a list of holes in the PWB (mounting, alignment, header
// through-holes, etc.
// The format for each hole entry is as follows:
//     [x_pos, y_pos], plated (boolean), hole_diam, plating_diam, mounting_option
// where `mounting_option` is: 0 = none, 1 = screw, 2 = peg
trnk_mtg_option_none  = 0;
trnk_mtg_option_screw = 1;
trnk_mtg_option_peg   = 2;

ada_trk_m0_holes = [
    // Plated 2.0 mm mounting holes:
    [ [-0.225 * 25.4, -0.40 * 25.4], true,  2.07, 3.22, trnk_mtg_option_screw],
    [ [ 0.225 * 25.4, -0.40 * 25.4], true,  2.07, 3.22, trnk_mtg_option_screw],
    // Regular mounting holes:
    [ [-0.240 * 25.4,  0.24 * 25.4], false, 1.98, 0.00, trnk_mtg_option_peg],
    [ [ 0.240 * 25.4,  0.24 * 25.4], false, 1.98, 0.00, trnk_mtg_option_peg],
    // Plated through-holes for two 1x5 headers for Dig/Analog I/O:
    [ [-0.250 * 25.4,  0.15 * 25.4], true,  1.00, 1.93, trnk_mtg_option_none],
    [ [-0.250 * 25.4,  0.05 * 25.4], true,  1.00, 1.93, trnk_mtg_option_none],
    [ [-0.250 * 25.4, -0.05 * 25.4], true,  1.00, 1.93, trnk_mtg_option_none],
    [ [-0.250 * 25.4, -0.15 * 25.4], true,  1.00, 1.93, trnk_mtg_option_none],
    [ [-0.250 * 25.4, -0.25 * 25.4], true,  1.00, 1.93, trnk_mtg_option_none],
    [ [ 0.250 * 25.4,  0.15 * 25.4], true,  1.00, 1.93, trnk_mtg_option_none],
    [ [ 0.250 * 25.4,  0.05 * 25.4], true,  1.00, 1.93, trnk_mtg_option_none],
    [ [ 0.250 * 25.4, -0.05 * 25.4], true,  1.00, 1.93, trnk_mtg_option_none],
    [ [ 0.250 * 25.4, -0.15 * 25.4], true,  1.00, 1.93, trnk_mtg_option_none],
    [ [ 0.250 * 25.4, -0.25 * 25.4], true,  1.00, 1.93, trnk_mtg_option_none]
];

// Now, let's create a list of prominent parts to display on PWB Model.
// The format for each hole entry is as follows:
//      [x_pos, y_pos] , [length, width, height], object_type, view_through_top, "color string"
// where `object_type` is: 0 = cube/rectangular, 1 = circular/cylindrical:
cube_part_type = 0;
cylind_part_type = 1;

ada_trk_m0_parts = [
    // Atmel ATSAMD21:
    [ [0.042 * 25.4, 0.119 * 25.4],   [5, 5, 1],         cube_part_type,  false, "Black"],
    // MicroUSB Connector:
//    [ [0.0,          0.33 * 25.4],   [7.6, 5.65, 2.6], cube_part_type, false, "Silver"],
    [ [0.0,          0.39 * 25.4],   [7.6, 5.65, 2.6],  cube_part_type,  false, "Silver"], // Had to adjust :-/
    // DotStar LED (APA102-2020):
    [ [-0.059 * 25.4, -0.063 * 25.4], [2.0, 2.0, 0.9],   cube_part_type,  true,  "White"],
    // Power (Green) LED:
    [ [-0.217 * 25.4, 0.405 * 25.4],  [0.8, 1.6, 0.6],   cube_part_type,  true,  "Green"],
    // Red LED:
    [ [ 0.217 * 25.4, 0.405 * 25.4],  [0.8, 1.6, 0.6],   cube_part_type,  true,  "Red"],
    // Reset Switch (Cube Body + Cylinder Button):
    [ [-0.035 * 25.4, -0.425 * 25.4], [3.55, 3.0, 1.43], cube_part_type,  false, "Silver"],
    [ [-0.035 * 25.4, -0.425 * 25.4], [1.70, 0.0, 1.91], cylind_part_type, true, "Black"]
];

// Here is a list of PCB Notch locations and rotations to approximate the actual PCB shape,
// using a simple 10x10 mm cube (same height as PCB):
ada_trk_m0_notches = [
    // Lower Right Corner - make 3 cuts:
    [ [ 0.300 * 25.4,  -0.4605 * 25.4 - 5.0 * sqrt(2.0)], 45],
    [ [ 0.142 * 25.4,  -0.490  * 25.4 - 5.0 * sqrt(2.0)], 45],
    [ [ 0.142 * 25.4 + 5.0,   -0.490  * 25.4 - 5.0], 0],
    // Lower Left Corner - make 2 cuts:
    [ [-0.269 * 25.4,  -0.480  * 25.4 - 5.0 * sqrt(2.0)], 45],
    [ [-0.269 * 25.4 - 5.0, -0.480 * 25.4 - 5.0],          0],
    // Upper Right Corner - 1 cut:
    [ [ 0.300 * 25.4,  0.45 * 25.4 + 5.0 * sqrt(2.0)],    45],
    // Upper Left Corner - 1 cut:
    [ [-0.300 * 25.4,  0.45 * 25.4 + 5.0 * sqrt(2.0)],    45]
];
