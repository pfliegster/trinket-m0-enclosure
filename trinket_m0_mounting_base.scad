// ****************************************************************************
//
// File: trinket_m0_mounting_base.scad
//
// Description:
//      Simple, standalone mounting base for the Adafruit Trinket M0 PWB &
//      optional wiring harness.
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
// Preview or Render Model with override values listed below:
//
/////////////////////////////////////////////////////////////////
AdafruitTrinketMountingBase(
    mounting_width = 25,
    base_thickness = 4,
    stud_height = 5,
    lip_height = 1);
