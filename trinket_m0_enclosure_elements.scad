// ****************************************************************************
//
// File: trinket_m0_enclosure_bottom.scad
//
// Description:
//      Bottom cover for the Adafruit Trinket M0 PWB & optional wiring harness.
//
// Author:  Keith Pflieger
// github:  pfliegster (https://github.com/pfliegster)
// License: CC BY-NC-SA 4.0
//          (Creative Commons: Attribution-NonCommercial-ShareAlike)
//
// ****************************************************************************

$include_trnk_m0_pwb = true;
include <ada_trnk_m0_pwb.scad>
include <globals_and_utilities.scad>

$fn = 100;

/////////////////////////////////////////////////////////////////
//
// Enclosure dimension control variables:
//
/////////////////////////////////////////////////////////////////
rounding_radius = 3;
case_wall_thickness = 2;
pwb_stud_height = 4;
pwb_lip_height = 0.7;
pwb_cutout_enable = false; // see README, may be required for certain parameter combinations

lid_shelf_width = 1; // Width of overlap region between top & bottom parts
lid_shelf_depth = 2; // Depth of overlap between top & bottom parts

mounting_screw_length = 8;
mounting_screw_head_inset_depth = 3; // Inset depth into top enclosure part

// These are the absolute minimum values for case dimension values,
// based on the parameters above (Caution changing any of these):
minimum_case_width = ada_trk_m0_pwb_length + 2*case_wall_thickness;
minimum_case_length = ada_trk_m0_pwb_width + 2*case_wall_thickness;
minimum_case_bottom_height = case_wall_thickness + pwb_stud_height;
minimum_case_top_height = rounding_radius;

// Recommended Default Case dimensions are all >= minimum values
// computed above. You can also set these to a fixed value as long
// as the dimension satisfies the minimum requirements (tested in
// the respective design module):
case_width         = minimum_case_width + 4;
case_length        = minimum_case_length + 1;
case_bottom_height = minimum_case_bottom_height + 4.5;
case_top_height    = minimum_case_top_height + 0;

// MicroUSB Access Hole cutout dimensions:
trinket_usb_cutout_width = 10;
trinket_usb_cutout_height = 5;

// Computation for how the top enclosure model implements the mounting screw
// stud length (use caution if changing this computation from the defaults):
top_z_offset = case_bottom_height + pwb_lip_height - pwb_stud_height - case_wall_thickness;

//////////////////////////////////////////////////////////////////////////////
//
// Module: AdafruitTrinketEnclosureBottom()
//      The Enclosure Bottom Model part constructed to fit with the matching
//      enclosure top model part defined below (must have consistent
//      dimensional parameters).
//
//      The Trinket-M0 PCB sits within the recessed mounting surfaces consisting
//      of the 'shelf' and 2 mounting screw 'studs'. The shelf has 2 alignment pegs
//      in the 'shelf' and the 2 screws holes are aligned with the 2 plated holes
//      in the Trinket PCB and with those in the top enclosure to hold the assembly
//      together.
//
//      The other features of the bottom part are the lid shelf/lip around the
//      periphery of the top of this model part (fits into matching top part),
//      mounting screw holes to hold the assembly together, and access/cutout
//      regions for both the MicroUSB connector on one end of the enclosure and
//      a wiring harness or bundle on the other end of the case.
//
//      The bottom part also has two optional mounting holes that can be added to the
//      bottom surface, for use in mounting the entire enclosure/assembly to other
//      objects. These optional mounting screw holes currently are fixed as M3 counter-
//      sunk, flathead screws. This feature is enabled using the 'add_back_mounting_screws'
//      parameter (set to true).
//
//  Parameters:
//      case_width: Overall width (outside dimension) of the enclosure.
//                  Must be wider than the 'minimum_case_width'. 
//      case_length: Overall length of the enclosure. Must be wider than
//                  the 'minimum_case_length'.
//      case_bottom_height: Overall height of the enclosure. Must be wider than
//                  the 'minimum_case_bottom_height'.
//      lid_shelf_width: Defines the width of the shelf/lip for the overlapping
//                  top/bottom model part mating surface around the periphery.
//                  Must be less than the overall 'wall_thickness'.
//      lid_shelf_depth: Defines the depth of the shelf/lip overlap for
//                  top/bottom model part mating surface around the periphery.
//      wall_thickness: Overall thickness of the walls of the enclosure, including
//                  enclosure sides, bottom, and top surfaces.
//      add_back_mounting_screws: Boolean - set to 'true' in order to add M3 flathead
//                  mounting screw holes to bottom surface of the bottom enclosure part.
//      enable_pwb_cutout: Boolean setting to ensure the Trinket PCB will fit in the
//                  bottom part (off by default, but may be required for various
//                  customized parameter combinations in order to avoid 'collision'
//                  of the bottom model part with the properly seated PCB.
//
//////////////////////////////////////////////////////////////////////////////
module AdafruitTrinketEnclosureBottom(
            case_width = 25,
            case_length = 50,
            case_bottom_height = 10,
            lid_shelf_width = 1,
            lid_shelf_depth = 2,
            wall_thickness = 2,
            add_back_mounting_screws = false,
            enable_pwb_cutout = false) {
                
    // First some error checking:
    assert(case_width >= minimum_case_width);
    assert(case_length >= minimum_case_length);
    assert(case_bottom_height >= minimum_case_bottom_height);
    assert(lid_shelf_width < wall_thickness - 0.4);
    assert(lid_shelf_depth > 0);
    assert(wall_thickness > 0.4);
    assert(pwb_stud_height - pwb_lip_height >= 2.6, "A minimum space > 2.6 mm under the PCB is required for wiring!");
                
    echo("Case Length = ", case_length);
    echo("Case Width = ", case_width);
    echo("Case Height = ", case_bottom_height + case_top_height);
    echo(" -> Bottom Model Height = ", case_bottom_height);

    outer_dimensions = [case_width - 2*rounding_radius,
                        case_length - 2*rounding_radius,
                        case_bottom_height];
    inner_dimensions = outer_dimensions - [2*wall_thickness, 2*wall_thickness, 0];
    lid_shelf_dimensions = outer_dimensions - [2*lid_shelf_width, 2*lid_shelf_width, 0];
                
    bottom_z_offset = case_bottom_height/2 + pwb_lip_height - pwb_stud_height - wall_thickness + rounding_radius;
    case_bottom_position = [0, ada_trk_m0_pwb_shift, bottom_z_offset];
    pwb_cutout_position = [0, -ada_trk_m0_pwb_shift, -bottom_z_offset];

    difference() {
        union() {
            translate(case_bottom_position) {
                difference() {
                    intersection() {
                        minkowski() {
                            cube (outer_dimensions, center = true);
                            sphere(rounding_radius);
                        }
                        translate([0, 0, -rounding_radius])
                            cube([case_width, case_length, case_bottom_height], center = true);
                    }
                    // remove rounded, inner cavity:
                    translate([0, 0, wall_thickness]) minkowski() {
                        cube (inner_dimensions, center = true);
                        sphere(rounding_radius);
                    }
                    // remove rounded, lid shelf region near top of bottom case section:
                    translate([0, 0, case_bottom_height/2 - lid_shelf_depth - rounding_radius])
                        difference() {
                            minkowski() {
                                cube(lid_shelf_dimensions, center = true);
                                sphere(rounding_radius);
                            }
                            translate([0, 0, -case_bottom_height/2])
                                cube([case_width+1, case_length+1, case_bottom_height], center = true);
                        }
                    // Cutout for wire harness
                    harness_cutout_z_offset = 2 + case_bottom_height/2 - bottom_z_offset +
                        pwb_lip_height - pwb_stud_height;
                    translate([0, rounding_radius - case_length/2, harness_cutout_z_offset])
                        minkowski() {
                            cube([6, 2*(rounding_radius + wall_thickness), case_bottom_height], center = true);
                            sphere(1);
                        }
                    // Cutout for USB Connection
                    usb_hole_z_offset = ada_trk_m0_pwb_height + ada_trk_m0_parts[1][1].z/2 - bottom_z_offset;
                    usb_cutout_dimensions = [
                        trinket_usb_cutout_width - 2,
                        rounding_radius + wall_thickness,
                        trinket_usb_cutout_height - 2];
                        
                    translate([0, case_length/2, usb_hole_z_offset])
                        minkowski() {
                            cube(usb_cutout_dimensions, center = true);
                            sphere(1);
                        }
                        
                    // Add holes for mounting screws:
                    translate(pwb_cutout_position + [0,0, pwb_lip_height])
                        AdafruitTrinketMountingHoles(
                            stud_height = pwb_stud_height,
                            hole_diam = 1.9,
                            screw_depth = mounting_screw_length);

                    // If enabled, explicitly cutout PWB volume segment (may be needed for various configurable
                    // parameter combinations, like high rounding_radius, with minimum case width/length values:
                    if (enable_pwb_cutout) {
                        translate(pwb_cutout_position) ada_trnk_m0_pwb_cutout();
                    }
                }
            }

            // For high values of rounding radius (> ~4.0), we need to remove extra volume segments outside
            // of the expected body region:
            intersection() {
                translate([0, 0, pwb_lip_height - pwb_stud_height])
                    AdafruitTrinketMountingBase(
                        mounting_width = case_width - wall_thickness,
                        base_thickness = wall_thickness/2,
                        stud_height = pwb_stud_height,
                        lip_height = pwb_lip_height );
                translate(case_bottom_position) intersection() {
                    minkowski() {
                        cube (outer_dimensions, center = true);
                        sphere(rounding_radius);
                    }
                    translate([0, 0, -rounding_radius])
                        cube([case_width, case_length, case_bottom_height], center = true);
                }
            }
        }

        // Add back mounting crew holes to mount enclosure to other objects
        if (add_back_mounting_screws) {
            back_screw_head_height = 2.1;
            back_screws_x_offset = case_width/2 - rounding_radius - 6.2/2;
            back_screws_z_offset = pwb_lip_height - pwb_stud_height - mounting_screw_length;
            translate([-back_screws_x_offset, 1.5, back_screws_z_offset]) {
                generic_screw_model(screw_diam = 3.4,
                    screw_type = "flat",
                    cutout_region = true,
                    head_diam = 6.1,
                    head_height = back_screw_head_height,
                    length = mounting_screw_length, $fn=80);
                translate([0, 0, 2 + mounting_screw_length])
                    cylinder(h = 4, d = 6.1, center = true, $fn = 80);
            }
            translate([back_screws_x_offset, -4.5, back_screws_z_offset]) {
                generic_screw_model(screw_diam = 3.4,
                    screw_type = "flat",
                    cutout_region = true,
                    head_diam = 6.1,
                    head_height = back_screw_head_height,
                    length = mounting_screw_length, $fn=80);
                translate([0, 0, 2 + mounting_screw_length])
                    cylinder(h = 4, d = 6.1, center = true, $fn = 80);
            }
        }
    }
}

//////////////////////////////////////////////////////////////////////////////
//
// Module: AdafruitTrinketEnclosureTop()
//      The Enclosure Top Model part constructed to fit on the matching
//      enclosure Bottom model part defined above (must have consistent
//      dimensional parameters).
//
//      The main features of the top part are the lid shelf/lip around the
//      periphery of the part (fits into matching bottom part), 2 counter-sunk
//      mounting screw holes to hold the assembly together, and access/view
//      holes for the Reset switch and LEDs on the Trinket-M0 PCB. There is also
//      guaranteed clearance around the Micro USB port.
//
//  Parameters:
//      case_width: Overall width (outside dimension) of the enclosure.
//                  Must be wider than the 'minimum_case_width'. 
//      case_length: Overall length of the enclosure. Must be wider than
//                  the 'minimum_case_length'.
//      case_top_height: Overall height of the enclosure. Must be wider than
//                  the 'minimum_case_top_height', which is set by the 
//                  'rounding_radius' of the design.
//      top_z_offset: Computed based on dimensional parameters of the bottom
//                  enclosure part. Controls how deep the mounting screw
//                  studs extend below the underside of the Enclosure top
//                  surface. Use CAUTION if changing this value from the
//                  default calculation defined above in this design file!
//      lid_shelf_width: Defines the width of the shelf/lip for the overlapping
//                  top/bottom model part mating surface around the periphery.
//                  Must be less than the overall 'wall_thickness'.
//      lid_shelf_depth: Defines the depth of the shelf/lip overlap for
//                  top/bottom model part mating surface around the periphery.
//      wall_thickness: Overall thickness of the walls of the enclosure, including
//                  enclosure sides, bottom, and top surfaces.
//
//////////////////////////////////////////////////////////////////////////////
module AdafruitTrinketEnclosureTop(
            case_width = 25,
            case_length = 50,
            case_top_height = 5,
            top_z_offset = 5,
            lid_shelf_width = 1,
            lid_shelf_depth = 2,
            wall_thickness = 2) {

    // First some error checking:
    assert(case_width >= minimum_case_width);
    assert(case_length >= minimum_case_length);
    assert(case_top_height >= minimum_case_top_height);
    assert(lid_shelf_width < wall_thickness - 0.4);
    assert(lid_shelf_depth > 0);
    assert(wall_thickness > 0.4);
                
    echo("Case Length = ", case_length);
    echo("Case Width = ", case_width);
    echo("Case Height = ", case_bottom_height + case_top_height);
    echo(" -> Top Model Height = ", case_top_height);

    outer_dimensions = [case_width - 2*rounding_radius,
                        case_length - 2*rounding_radius,
                        case_top_height];
    inner_dimensions = outer_dimensions - [2*wall_thickness, 2*wall_thickness, 0];
    lid_shelf_dimensions = [case_width - 2*rounding_radius - 2*lid_shelf_width - 0.4,
                        case_length - 2*rounding_radius - 2*lid_shelf_width - 0.4,
                        2*lid_shelf_depth];
                
    case_top_position = [0, ada_trk_m0_pwb_shift, -lid_shelf_depth];
    echo("TZO = ", top_z_offset);

    stud_radius = 2.5;
    screw_hole_diameter = 2.4;
    screw_head_inset_diameter = 3.8;
    screw_stud_length = top_z_offset + case_top_height - wall_thickness/2 - ada_trk_m0_pwb_height;
    screw_stud_z_offset = case_top_height - wall_thickness/2 - screw_stud_length/2;
    screw1_position = [ada_trk_m0_holes[0][0].x, ada_trk_m0_holes[0][0].y, screw_stud_z_offset];
    screw2_position = [ada_trk_m0_holes[1][0].x, ada_trk_m0_holes[1][0].y, screw_stud_z_offset];
    screw1_head_position = [ada_trk_m0_holes[0][0].x, ada_trk_m0_holes[0][0].y, case_top_height];
    screw2_head_position = [ada_trk_m0_holes[1][0].x, ada_trk_m0_holes[1][0].y, case_top_height];

    difference() {
        union() {
            translate(case_top_position) {
                difference() {
                    intersection() {
                        translate([0, 0, case_top_height/2 + lid_shelf_depth - rounding_radius]) minkowski() {
                            cube (outer_dimensions, center = true);
                            sphere(rounding_radius);
                        }
                        translate([0, 0, case_top_height/2 + lid_shelf_depth/2 + 1])
                            cube([case_width+1, case_length+1, case_top_height+lid_shelf_depth+2],
                                center = true);
                    }
                // remove rounded, inner cavity:
                translate([0, 0, case_top_height/2 + lid_shelf_depth - rounding_radius - wall_thickness])
                    minkowski() {
                        cube (inner_dimensions, center = true);
                        sphere(rounding_radius);
                    }
                // Cutout for USB Connection
                usb_hole_z_offset = ada_trk_m0_pwb_height + ada_trk_m0_parts[1][1].z/2 +
                    lid_shelf_depth - top_z_offset;
                usb_cutout_dimensions = [
                    trinket_usb_cutout_width - 2,
                    rounding_radius + wall_thickness,
                    trinket_usb_cutout_height - 2];
                    
                translate([0, case_length/2, usb_hole_z_offset])
                    minkowski() {
                        cube(usb_cutout_dimensions, center = true);
                        sphere(1);
                    }
                }
            }
            // Add Screw Hole Mounting Studs & shoulders:
            intersection() {
                union() {
                    translate(screw1_position) cylinder(h = screw_stud_length, r = stud_radius, center = true);
                    translate(screw2_position) cylinder(h = screw_stud_length, r = stud_radius, center = true);
                    shoulder_width = case_width/2 - ada_trk_m0_holes[1][0].x - wall_thickness - 0.3;
                    translate(screw1_position - [shoulder_width/2, 0, 0])
                        cube([shoulder_width, 2*stud_radius, screw_stud_length], center = true);
                    translate(screw2_position + [shoulder_width/2, 0, 0])
                        cube([shoulder_width, 2*stud_radius, screw_stud_length], center = true);
                }
                translate([0, 0, case_top_height/2 - rounding_radius]) {
                    minkowski() {
                        cube (outer_dimensions, center = true);
                        sphere(rounding_radius);
                    }
                }
            }
        }
        translate(screw1_position)
            cylinder(h = 2*screw_stud_length, d = screw_hole_diameter, center = true);
        translate(screw2_position)
            cylinder(h = 2*screw_stud_length, d = screw_hole_diameter, center = true);
        translate(screw1_head_position)
            cylinder(h = 2*mounting_screw_head_inset_depth, d = screw_head_inset_diameter, center = true);
        translate(screw2_head_position)
            cylinder(h = 2*mounting_screw_head_inset_depth, d = screw_head_inset_diameter, center = true);
        
        // Add Access holes and view ports for select PWB components (LEDs, PB Switches, etc.):
        num_pwb_parts   = len(ada_trk_m0_parts);
        for (i = [ 0: num_pwb_parts-1 ]) {
            if (ada_trk_m0_parts[i][3]) { // Component needs access or view port through top enclosure?
                z_offset = case_top_height/2;
                if (ada_trk_m0_parts[i][2] == cylind_part_type) {
                    cylinder_diam   = 1.5 * ada_trk_m0_parts[i][1].x;
                    cylinder_height = 2*case_top_height;
                    translate([ada_trk_m0_parts[i][0].x, ada_trk_m0_parts[i][0].y, z_offset])
                        cylinder(h = cylinder_height, d = cylinder_diam, center = true);
                } else { // ada_trk_m0_parts[i][2] == cube_part_type
                    cutout_dimensions = [
                        1.5 * ada_trk_m0_parts[i][1].x,
                        1.5 * ada_trk_m0_parts[i][1].y,
                        2*case_top_height ];
                    translate([ada_trk_m0_parts[i][0].x, ada_trk_m0_parts[i][0].y, z_offset])
                        minkowski() {
                            cube(cutout_dimensions, center = true);
                            sphere(0.5);
                        }
                }
            }
        }
        // remove rounded, lid shelf region where top and bottom enclosure parts meet and overlap:
        translate(case_top_position) difference() {
            cube([case_width+1, case_length+1, 2*lid_shelf_depth], center = true);
            minkowski() {
                cube(lid_shelf_dimensions, center = true);
                sphere(rounding_radius);
            }
        }
        // Remove any sections that overlap with the volume of the Bottom Enclosure Part.
        // This was added/required for customized enclosures for certain parameter combinations:
        translate([0, 0, -top_z_offset])
            AdafruitTrinketEnclosureBottom(
                case_width = case_width,
                case_length = case_length,
                case_bottom_height = case_bottom_height,
                lid_shelf_width = lid_shelf_width,
                lid_shelf_depth = lid_shelf_depth,
                wall_thickness = wall_thickness,
                enable_pwb_cutout = pwb_cutout_enable);
    }
}

//////////////////////////////////////////////////////////////////////////////
//
// Module: AdafruitTrinketMountingBase()
//      Design for a simple mounting base which can be used as a standalone
//      mounting option (with appropriate settings), or used as a component in
//      the construction of the complete enclosure (part of the bottom enclosure
//      model part).
//
//      This module can also be incorporated in other, outside projects by directly
//      adding it as a component in the construction of a higher-level model,
//      similar to how it is used in constructing the Trinket-M0 Enclosure
//      contained in this repository.
//
//  Parameters:
//      mounting_width: Overall width of the constructed mounting studs and shelf.
//                  Must be wider than the PWB itself, plus a little margin.    
//      base_thickness: thickness of base underneath mounting studs and shelf,
//                  connecting them together, at the same width as 'mounting_width'.
//      stud_depth: height of studs and shelf constructed. Allows space under PCB
//                  for wiring harness and solder joints.
//      lip_height: height of the lip around the PWB into which it is mounted into.
//                  Helps with alignment and mechanical stability once screwed in.
//
//////////////////////////////////////////////////////////////////////////////
module AdafruitTrinketMountingBase( mounting_width = 25, base_thickness = 2,
                    stud_height = 5, lip_height = 1) {
                  
    peg_height = stud_height + 0.8;
    base_dimensions = [ mounting_width, ada_trk_m0_pwb_width, base_thickness];
    difference() {
        union() {
            translate([0, ada_trk_m0_pwb_shift, -base_thickness/2])
                cube(base_dimensions, center = true);
            AdafruitTrinketMountingStuds(mounting_width = mounting_width, stud_height = stud_height);
        }
        AdafruitTrinketPWBLip(stud_height = stud_height, lip_height = lip_height);
        AdafruitTrinketMountingHoles(stud_height = stud_height, hole_diam = 1.9, screw_depth = 8);
    }
    AdafruitTrinketMountingPegs(peg_height = peg_height, peg_diam = 1.75);
}

//////////////////////////////////////////////////////////////////////////////
//
// Module: AdafruitTrinketMountingStuds()
//
//  This module creates two mounting studs (each constructed of a cylinder
//  combined with a cube) for the screw-mount holes, along with a larger
//  'shelf' for the upper section (side with MicroUSB) of the board to sit
//  on and mounting pegs for the two additional PWB mechanical holes slide over.
//
//  Parameters:
//      mounting_width: Overall width of the constructed mounting studs and shelf.
//                  Must be wider than the PWB itself, plus a little margin.    
//      stud_depth: height of studs and shelf constructed. Allows space under PCB
//                  for wiring harness and solder joints.
//
//////////////////////////////////////////////////////////////////////////////
module AdafruitTrinketMountingStuds(mounting_width = 25, stud_height = 5) {
    
    assert(mounting_width > ada_trk_m0_pwb_length + 2);
    shelf_length = mounting_width;
    shelf_width = (ada_trk_m0_pwb_width + 2*ada_trk_m0_pwb_shift
                    - ada_trk_m0_holes[2][0].y - ada_trk_m0_holes[4][0].y)/2;

    shelf_position = [ 0,
        (ada_trk_m0_holes[2][0].y + ada_trk_m0_holes[4][0].y + shelf_width)/2,
        stud_height/2 ];
    
    stud_radius = 2.2;
    stud_cube_length = (mounting_width + ada_trk_m0_holes[0][0].x - ada_trk_m0_holes[1][0].x)/2;
    stud_dimension = [stud_cube_length, 2 * stud_radius, stud_height];
    screw1_position = [ada_trk_m0_holes[0][0].x, ada_trk_m0_holes[0][0].y, stud_height/2];
    screw2_position = [ada_trk_m0_holes[1][0].x, ada_trk_m0_holes[1][0].y, stud_height/2];
    stud1_position = [screw1_position.x - stud_dimension.x/2, screw1_position.y, stud_height/2];
    stud2_position = [screw2_position.x + stud_dimension.x/2, screw2_position.y, stud_height/2];
    
    translate(shelf_position)
        cube([shelf_length, shelf_width, stud_height], center = true);
    
    translate(screw1_position)
        cylinder(h = stud_height, r = stud_radius, center = true, $fn = 80);
    translate(stud1_position)
        cube(stud_dimension, center = true);
    
    translate(screw2_position)
        cylinder(h = stud_height, r = stud_radius, center = true, $fn = 80);
    translate(stud2_position)
        cube(stud_dimension, center = true);
}

//  Create a sunken section of the shelf and mounting studs for the Adafruit Trinket M0 PWB
//  to sit firmly into to assist in securing board to enclosure.
module AdafruitTrinketPWBLip(stud_height = 5, lip_height = ada_trk_m0_pwb_height) {
    
    // Add a little margin to PWB dimensions for manufacturing tolerances:
    pwb_lip_dimensions  = [ada_trk_m0_pwb_length + 0.5, ada_trk_m0_pwb_width + 0.5, 2 * lip_height];
    pwb_lip_position    = [0, 0, stud_height];

    translate(pwb_lip_position) cube(pwb_lip_dimensions, center = true);
}

module AdafruitTrinketMountingHoles( stud_height = 5,
            hole_diam = 1.9, screw_depth = 8) {

    num_pwb_holes   = len(ada_trk_m0_holes);

    for (i = [ 0: num_pwb_holes-1 ]) {
        if (ada_trk_m0_holes[i][4] == trnk_mtg_option_screw) {
            screw_hole_position = [ ada_trk_m0_holes[i][0].x,
                                    ada_trk_m0_holes[i][0].y,
                                    stud_height - screw_depth/2 ];
            
            translate(screw_hole_position)
                cylinder(h = screw_depth, d = hole_diam, center = true);
        }
    }
}

module AdafruitTrinketMountingPegs( peg_height = 6, peg_diam = 1.8) {
    num_pwb_holes   = len(ada_trk_m0_holes);

    for (i = [ 0: num_pwb_holes-1 ]) {
        if (ada_trk_m0_holes[i][4] == trnk_mtg_option_peg) {
            screw_hole_position = [ ada_trk_m0_holes[i][0].x,
                                    ada_trk_m0_holes[i][0].y,
                                    peg_height/2 ];
            
            translate(screw_hole_position)
                cylinder(h = peg_height, d = peg_diam, center = true);
        }
    }
}
