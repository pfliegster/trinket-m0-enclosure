// ****************************************************************************
//
// File: trinket_m0_enclosure_collision_tests.scad
//
// Description:
//      Test Design file for detecting collisions in top & bottom enclosure
//      model parts to verify proper fit and function when customizing
//      dimensional parameters (prior to printing).
//
//      Ideally, nothing should show up as a collision here, unless there is
//      an issue related to modified dimensional parameters that prevents the
//      enclosure parts from fitting together.
//
// Author:  Keith Pflieger
// github:  pfliegster (https://github.com/pfliegster)
// License: CC BY-NC-SA 4.0
//          (Creative Commons: Attribution-NonCommercial-ShareAlike)
//
// ****************************************************************************

include <trinket_m0_enclosure_elements.scad>

// If there is a collision volume detected, you can determine where in the enclosure
// design the collision occurs by turning on visibility of other objects ...
// Visibility settings for other objects (for testing and visualization):
display_enclosure_parts = true;
display_trnk_m0_pwb = false;
display_wiring_harness = false;
display_mounting_hardware = false;
_screw_in_through_top_enclosure = true; // false = screw PWB directly into Mounting Studs in base

/////////////////////////////////////////////////////////////////
//
// View Trinket-M0 Enclosure part collision of top & bottom parts,
// along with other design entities, based
// on boolean display settings defined above:
//
/////////////////////////////////////////////////////////////////
// Add a very small delta to the Z translation for the top enclosure
// part to avoid the 0 height 'rings' around the periphery surface 
// where the top & bottom parts are touching, so that it doesn't show
// as a collision (same for detecting PWB collisions):
delta_z = 0.001;
top_position = [0, 0, top_z_offset + delta_z];
pwb_position = [0, 0, delta_z];

// Show the 'intersection' (collision volumes) of the top & bottom parts in RED:
color("red") render() intersection() {
    AdafruitTrinketEnclosureBottom(
        case_width = case_width,
        case_length = case_length,
        case_bottom_height = case_bottom_height,
        lid_shelf_width = lid_shelf_width,
        lid_shelf_depth = lid_shelf_depth,
        wall_thickness = case_wall_thickness,
        enable_pwb_cutout = pwb_cutout_enable);
    
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
}

// Show the 'intersection' (collision volumes) of the bottom enclosure part with the PWB in BLUE:
color("blue") render() intersection() {
    AdafruitTrinketEnclosureBottom(
        case_width = case_width,
        case_length = case_length,
        case_bottom_height = case_bottom_height,
        lid_shelf_width = lid_shelf_width,
        lid_shelf_depth = lid_shelf_depth,
        wall_thickness = case_wall_thickness,
        enable_pwb_cutout = pwb_cutout_enable);
    
    translate(pwb_position) ada_trnk_m0_pwb_model();
}

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

if (display_enclosure_parts) {
    color("dimgray", alpha = 0.6) render() {
        AdafruitTrinketEnclosureBottom(
            case_width = case_width,
            case_length = case_length,
            case_bottom_height = case_bottom_height,
            lid_shelf_width = lid_shelf_width,
            lid_shelf_depth = lid_shelf_depth,
            wall_thickness = case_wall_thickness,
            enable_pwb_cutout = pwb_cutout_enable);
        
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
    }
}
