// ****************************************************************************
//
// File: trinket_m0_enclosure_assembly.scad
//
// Description:
//      Top-level Assembly design file for the Adafruit Trinket M0 Enclosure
//      components, Trinket-M0 PWB, wiring harness and mounting hardware
//
// Author:  Keith Pflieger
// github:  pfliegster (https://github.com/pfliegster)
// License: CC BY-NC-SA 4.0
//          (Creative Commons: Attribution-NonCommercial-ShareAlike)
//
// ****************************************************************************

include <trinket_m0_enclosure_elements.scad>

// Visibility settings for other objects (for testing and visualization):
display_enclosure_top = true;
display_enclosure_bottom = true;
display_trnk_m0_pwb = true;
display_wiring_harness = true;
display_mounting_hardware = true;
_screw_in_through_top_enclosure = true; // false = screw PWB directly into Mounting Studs in base

// Color alpha channel settings - 0.0-1.0 (1.0 is opaque, 0.0 is fully transparent)
top_alpha = 0.7;
bottom_alpha = 1.0; 

/////////////////////////////////////////////////////////////////
//
// View Trinket-M0 Enclosure top-level assembly components, based
// on boolean display settings defined above:
//
/////////////////////////////////////////////////////////////////
if (display_trnk_m0_pwb) {
    ada_trnk_m0_pwb_model();
}

if (display_wiring_harness) {
    translate([0, -30, -0.8]) rotate([90, 0, 0])
        jst_wiring_harness(num_conductor = 4, harness_length = 30,
                            connector_type = "header", $fn=80);
}

if (display_mounting_hardware) {
    mounting_screw_z_offset = _screw_in_through_top_enclosure ? 
        top_z_offset  + case_top_height - mounting_screw_length - mounting_screw_head_inset_depth :
        ada_trk_m0_pwb_height - mounting_screw_length;
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

if (display_enclosure_bottom) {
    color("gray", alpha = bottom_alpha) render()
        AdafruitTrinketEnclosureBottom(
            case_width = case_width,
            case_length = case_length,
            case_bottom_height = case_bottom_height,
            lid_shelf_width = lid_shelf_width,
            lid_shelf_depth = lid_shelf_depth,
            wall_thickness = case_wall_thickness,
            add_back_mounting_screws = false,
            enable_pwb_cutout = pwb_cutout_enable);
}

if (display_enclosure_top) {
    top_position = [0, 0, top_z_offset];
    
    color("dimgray", alpha = top_alpha) render() translate(top_position)
    AdafruitTrinketEnclosureTop(
        case_width = case_width,
        case_length = case_length,
        case_top_height = case_top_height,
        top_z_offset = top_z_offset,
        lid_shelf_width = lid_shelf_width,
        lid_shelf_depth = lid_shelf_depth,
        wall_thickness = case_wall_thickness);
}
