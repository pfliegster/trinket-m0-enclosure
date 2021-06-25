// ****************************************************************************
//
// File: trinket_m0_enclosure_bottom.scad
//
// Description:
//      Bottom Enclosure Part for the Adafruit Trinket M0 PWB & optional wiring harness.
//
// Author:  Keith Pflieger
// github:  pfliegster (https://github.com/pfliegster)
// License: CC BY-NC-SA 4.0
//          (Creative Commons: Attribution-NonCommercial-ShareAlike)
//
// ****************************************************************************

include <trinket_m0_enclosure_elements.scad>

/////////////////////////////////////////////////////////////////
//
// Preview or Render Model using dimension variables as defined in
// the included 'trinket_m0_enclosure_elements.scad' design file:
//
/////////////////////////////////////////////////////////////////
AdafruitTrinketEnclosureBottom(
    case_width = case_width,
    case_length = case_length,
    case_bottom_height = case_bottom_height,
    lid_shelf_width = lid_shelf_width,
    lid_shelf_depth = lid_shelf_depth,
    wall_thickness = case_wall_thickness,
    add_back_mounting_screws = false,
    enable_pwb_cutout = pwb_cutout_enable);
