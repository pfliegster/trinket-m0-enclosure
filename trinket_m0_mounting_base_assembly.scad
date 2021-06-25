// ****************************************************************************
//
// File: trinket_m0_mounting_base_assembly.scad
//
// Description:
//      Top-level Assembly design file for the Adafruit Trinket M0 Standalone
//      mounting base, Trinket-M0 PWB, wiring harness and mounting screws.
//
// Author:  Keith Pflieger
// github:  pfliegster (https://github.com/pfliegster)
// License: CC BY-NC-SA 4.0
//          (Creative Commons: Attribution-NonCommercial-ShareAlike)
//
// ****************************************************************************

include <trinket_m0_enclosure_elements.scad>

// Visibility settings for other objects (for testing and visualization):
display_trnk_m0_pwb = true;
display_wiring_harness = true;
display_mounting_hardware = true;

/////////////////////////////////////////////////////////////////
//
// View Trinket-M0 assembly components, based
// on boolean display settings defined above:
//
/////////////////////////////////////////////////////////////////
mtg_base_stud_h = 5;
mtg_base_pwb_lip = 1;

translate([0, 0, mtg_base_pwb_lip - mtg_base_stud_h])
    AdafruitTrinketMountingBase(
        mounting_width = 25,
        base_thickness = 4,
        stud_height = mtg_base_stud_h,
        lip_height = mtg_base_pwb_lip);

if (display_trnk_m0_pwb) {
    ada_trnk_m0_pwb_model();
}

if (display_wiring_harness) {
    translate([0, -30, -0.8]) rotate([90, 0, 0])
        jst_wiring_harness(num_conductor = 4, harness_length = 30,
                            connector_type = "header", $fn=80);
}

if (display_mounting_hardware) {
    mounting_screw_z_offset = ada_trk_m0_pwb_height - mounting_screw_length;
    num_pwb_holes   = len(ada_trk_m0_holes);
    for (i = [ 0: num_pwb_holes-1 ]) {
        if (ada_trk_m0_holes[i][4] == trnk_mtg_option_screw) {
            screw_position = [
                ada_trk_m0_holes[i][0].x,
                ada_trk_m0_holes[i][0].y,
                mounting_screw_z_offset];
            
            color("dimgray") translate(screw_position)
                generic_screw_model(screw_diam = 2.0,
                    screw_type = "cylinder",
                    head_diam = 3.65,
                    head_height = 1.96,
                    length = mounting_screw_length, $fn=80);
        }
    }
}
