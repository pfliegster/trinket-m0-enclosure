// ****************************************************************************
//
// File: trinket_m0_enclosure_top.scad
//
// Description:
//      Top Enclosure Part for the Adafruit Trinket M0 PWB & optional wiring harness.
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
top_position = [0, 0, top_z_offset];

translate(top_position) {
    AdafruitTrinketEnclosureTop(
        case_width = case_width,
        case_length = case_length,
        case_top_height = case_top_height,
        top_z_offset = top_z_offset,
        lid_shelf_width = lid_shelf_width,
        lid_shelf_depth = lid_shelf_depth,
        wall_thickness = case_wall_thickness);
}
