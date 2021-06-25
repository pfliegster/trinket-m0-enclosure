/////////////////////////////////////////////////////////////////////////////////
//
// File: ada_trnk_m0_pwb.scad
//
// Description:
//   Rough 3D Model of Adafruit "Trinket M0" PWB,
//   based on Adafruit EagleCAD rev D board file:
//
//     https://github.com/adafruit/Adafruit-Trinket-M0-PCB
//
//   The PWB model includes mounting holes, LEDs, Micro-USB connector,
//   PB Reset switch, and a few other prominent design objects.
//
// Author:  Keith Pflieger
// github:  pfliegster (https://github.com/pfliegster)
// License: CC BY-NC-SA 4.0
//          (Creative Commons: Attribution-NonCommercial-ShareAlike)
//
/////////////////////////////////////////////////////////////////////////////////
include <ada_trnk_m0_constants.scad>

$fn=40;

display_pwb_cutout_volume = false;

module ada_trnk_m0_pwb_model() {
        
    pwb_dimensions  = [ada_trk_m0_pwb_length, ada_trk_m0_pwb_width, ada_trk_m0_pwb_height];
    num_pwb_holes   = len(ada_trk_m0_holes);
    num_pwb_parts   = len(ada_trk_m0_parts);
    num_pwb_notches = len(ada_trk_m0_notches);
    
    translate([0, 0, ada_trk_m0_pwb_height/2]) {
        // Bare PWB:
        color("darkolivegreen") {
            render() difference() {
                translate([0, ada_trk_m0_pwb_shift, 0])
                    cube(pwb_dimensions, center = true);

                // Cutouts for holes:
                for (i = [ 0: num_pwb_holes-1 ]) {
                    pwb_hole_diam = ada_trk_m0_holes[i][1] ? ada_trk_m0_holes[i][3] : ada_trk_m0_holes[i][2];
                    translate([ada_trk_m0_holes[i][0].x, ada_trk_m0_holes[i][0].y, 0])
                        cylinder(h = ada_trk_m0_pwb_height, d = pwb_hole_diam, center = true);
                }

                // Notch corners of Trinket M0 PCB:
                for (i = [ 0: num_pwb_notches-1 ]) {
                    translate([ada_trk_m0_notches[i][0].x, ada_trk_m0_notches[i][0].y, 0])
                        rotate([0, 0, ada_trk_m0_notches[i][1]])
                            cube([10, 10, ada_trk_m0_pwb_height], center = true);
                }
            }
        }
        
        // Add Plated Hole Rings:
        render() {
            for (i = [ 0: num_pwb_holes-1 ]) {
                if (ada_trk_m0_holes[i][1]) {
                    ring_diam = ada_trk_m0_holes[i][3];
                    hole_diam = ada_trk_m0_holes[i][2];
                    translate([ada_trk_m0_holes[i][0].x, ada_trk_m0_holes[i][0].y, 0])
                        difference() {
                            cylinder(h = ada_trk_m0_pwb_height, d = ring_diam, center = true);
                            cylinder(h = ada_trk_m0_pwb_height, d = hole_diam, center = true);
                        }
                }
            }
        }

        // Add components or other prominent objects:
        for (i = [ 0: num_pwb_parts-1 ]) {
            color(ada_trk_m0_parts[i][4]) {
                if (ada_trk_m0_parts[i][2] == cylind_part_type) {
                    cylinder_diam   = ada_trk_m0_parts[i][1].x;
                    cylinder_height = ada_trk_m0_parts[i][1].z;
                    z_offset = (ada_trk_m0_pwb_height + cylinder_height)/2;
                    translate([ada_trk_m0_parts[i][0].x, ada_trk_m0_parts[i][0].y, z_offset])
                        cylinder(h = cylinder_height, d = cylinder_diam, center = true);
                } else { // ada_trk_m0_parts[i][2] == cube_part_type
                    z_offset = (ada_trk_m0_pwb_height + ada_trk_m0_parts[i][1].z)/2;
                    translate([ada_trk_m0_parts[i][0].x, ada_trk_m0_parts[i][0].y, z_offset])
                        cube(ada_trk_m0_parts[i][1], center = true);
                }
            }
        }
    }
}

// Module to create a 'cutout' volume based on outline of PWB, with some extra margin
// and scaled 10x in the Z direction. Used for ensuring PWB will sit in bottom enclosure
// model part after customization of various parameters creates collisions:
module ada_trnk_m0_pwb_cutout() {
    cutout_margin = 0.5;
    pwb_cutout_dimensions  = [
        ada_trk_m0_pwb_length + cutout_margin,
        ada_trk_m0_pwb_width + cutout_margin,
        10*ada_trk_m0_pwb_height];

    num_pwb_notches = len(ada_trk_m0_notches);

    translate([0, 0, 5*ada_trk_m0_pwb_height]) {
        // Primary PWB Cutout Volume:
        difference() {
            translate([0, ada_trk_m0_pwb_shift, 0])
                cube(pwb_cutout_dimensions, center = true);

            // Notch corners of Trinket M0 PCB:
            for (i = [ 0: num_pwb_notches-1 ]) {
                x_offset = ada_trk_m0_notches[i][0].x + sign(ada_trk_m0_notches[i][0].x) * cutout_margin/2;
                y_offset = ada_trk_m0_notches[i][0].y + sign(ada_trk_m0_notches[i][0].y) * cutout_margin/2;
                translate([x_offset, y_offset, 0])
                    rotate([0, 0, ada_trk_m0_notches[i][1]])
                        cube([10, 10, 20*ada_trk_m0_pwb_height], center = true);
            }
        }
    }
}

/////////////////////////////////////////////////////////////////
//
// Preview or Render Model only if viewed directly, not called as
//   part of upper-level Assembly:
//
/////////////////////////////////////////////////////////////////
if ($include_trnk_m0_pwb == undef) {
    ada_trnk_m0_pwb_model();
    if (display_pwb_cutout_volume) {
        color("dimgray", alpha = 0.6) ada_trnk_m0_pwb_cutout();
    }
}