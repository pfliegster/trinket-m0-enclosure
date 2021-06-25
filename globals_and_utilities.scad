// ****************************************************************************
//
//  File: globals_and_utilities.scad
//
//  Description:
//      This file contains global variables and utility functions for the project.
//
//  Author:  Keith Pflieger
//  Github:  pfliegster (https://github.com/pfliegster)
//  License: CC BY-NC-SA 4.0
//           (Creative Commons: Attribution-NonCommercial-ShareAlike)
//
// ****************************************************************************

/////////////////////////////////////////////////////////////////
//
//  Module: jst_wiring_harness()
//
//  A simple wiring harness model, configurable for 3-pin or 4-pin connectors
//  (socket or header style) and wire length.
//
//  The wiring harness connector end is based on Adafruit JST-4PH and JST-3PH
//  socket/header connectors. Wire size, color coding and connector dimensions
//  closely match those used by the following Adafruit P/Ns:
//      4-pin socket (https://www.adafruit.com/product/4045),
//      4-pin header (https://www.adafruit.com/product/3955),
//      3-pin socket (https://www.adafruit.com/product/4046),
//      3-pin header (https://www.adafruit.com/product/3893)
//
//  Parameters:
//      num_conductor (default = 4):
//          only 3 or 4 conductor configurations supported.
//      harness_length (default = 10mm):
//          this defines the 'pigtail' length from the back of the PWB
//          to the connector housing;
//      connector_type (default = "unterminated"):
//          set to either "socket" or "header" style, or as "unterminated".
//          instantiation of the connector shell is useful for fit check or
//          visualization in more complex assemblies.
//
/////////////////////////////////////////////////////////////////
module jst_wiring_harness(num_conductor = 4, harness_length = 25, connector_type = "unterminated") {
    
    // First some error checking:
    assert(harness_length >= 0);
    assert(((num_conductor == 3) || (num_conductor == 4)),
            "Only 3 or 4 conductor wiring harnesses supported at this time.");
    assert(((connector_type == "socket") || (connector_type == "header") ||
            (connector_type == "unterminated")),
            "Unsupported connector_type. Check spelling.");

    // JST-PH 3-pin socket (with interface segment) and header connector dimensions:
    jst3ph_header_dimensions = [7.8, 4.3, 7.0];
    jst3ph_socket_dimensions = [8.0, 4.7, 6.0];
    jst3ph_socket_interface_dims = [6.6, 3.0, 6.6];

    // JST-PH 4-pin socket (with interface segment) and header connector dimensions:
    jst4ph_header_dimensions = [9.8, 4.4, 7.0];
    jst4ph_socket_dimensions = [10.0, 4.7, 6.0];
    jst4ph_socket_interface_dims = [8.6, 3.0, 6.6];

    // Constants defining the wires comprising the harness itself:
    wire_diam  = 1.6;
    wire_color = ["black", "red", "white", "green"];
    header_dimensions  = (num_conductor == 3) ? jst3ph_header_dimensions : jst4ph_header_dimensions;
    socket_dimensions  = (num_conductor == 3) ? jst3ph_socket_dimensions : jst4ph_socket_dimensions;
    interface_dims = (num_conductor == 3) ? jst3ph_socket_interface_dims : jst4ph_socket_interface_dims;

    // Add the wires:
    for (i = [ 0: num_conductor-1 ]) {
        wire_x_pos = i * wire_diam + wire_diam/2 - num_conductor * wire_diam/2;
        color(wire_color[i]) translate([wire_x_pos, 0, -harness_length/2])
            cylinder(h = harness_length, d = wire_diam, center = true);
    }

    // Next, add the connector backshell for socket or header harness termination:
    if (connector_type == "socket") {
        // Connector backshell (Socket style connection, which includes 'interface' section too):
        color("white") {
            translate([0, 0, interface_dims.z/2])
                cube(interface_dims, center = true);
            translate([0, 0, interface_dims.z + socket_dimensions.z/2])
                cube(socket_dimensions, center = true);
        }
    } else if (connector_type == "header") {
        // Connector backshell (Header style connection):
        color("white") translate([0, 0, header_dimensions.z/2])
            cube(header_dimensions, center = true);
    } // else don't do anything for "unterminated" wiring harness
}

///////////////////////////////////////////////////////////////////////////////////////
//
//  Generic Screw Model
//
//  Parameters:
//      screw_diam: Screw Diameter (e.g. set to 3.0 for M3 screw);
//      screw_type: This can be "round" (panel or button heads), "cylinder" 
//                  (socket head) or "flat" (e.g. 90 deg. flush-mount) screws.
//      cutout_region: Boolean, set to true if using generic_screw_model() to create a
//                  screw hole or other cutout_region (does not implement socket/screw
//                  driver feature).
//      head_diam:  Widest diameter of head or 'flange' (the top of a "flat" head or
//                  the bottom of "rounded" head types (panel, button, etc.), per convention.
//      head_height: The height of rounded heads, or the inset depth of the flat head type.
//      length:     Length of screw, from the bottom of the screw to either the
//                  a) bottom of "round" and "cylinder" head types, or
//                  b) top of "flat" head screws
//
///////////////////////////////////////////////////////////////////////////////////////
module generic_screw_model(screw_diam = 3.0, screw_type = "round", cutout_region = false,
                    head_diam = 6, head_height = 1.9, length = 8) {
    // First, some error checking on parameters:
    assert(screw_diam > 0);
    assert(head_diam > 0);
    assert(head_height > 0);
    assert(length > 0);
    assert(((screw_type == "round") || (screw_type == "cylinder") ||
            (screw_type == "flat")),
            "Unsupported screw_type! Please check spelling.");
    
    difference() {
        union() {
            // Now let's create the screw shaft itself:
            translate([0, 0, length/2])
                cylinder(h = length, d = screw_diam, center = true);
            // Next, create the screw head:
            if (screw_type == "round") {
                translate([0, 0, length]) {
                    scale([1, 1, 2*head_height/head_diam]) {
                        difference() {
                            sphere(d = head_diam, $fn = 100);
                            translate([0, 0, -head_diam/2]) cube(head_diam, center = true);
                        }
                    }
                }
            } else if (screw_type == "cylinder") {
                translate([0, 0, length + head_height/2])
                    cylinder(h = head_height, d = head_diam, center = true);
            } else if (screw_type == "flat") {
                translate([0, 0, length - head_height/2])
                    cylinder(h = head_height, d1 = screw_diam, d2 = head_diam, center = true);
            }
        }
        if (!cutout_region) {
            translate([0, 0, (screw_type == "flat") ? length : length + head_height])
                cylinder(h = head_height, d = screw_diam, center = true, $fn = 6);
        }
    }
}

/////////////////////////////////////////////////////////////////
//
//      Testing:
//
/////////////////////////////////////////////////////////////////
*jst_wiring_harness(num_conductor = 4, harness_length = 20, connector_type = "header", $fn=80);
*generic_screw_model(screw_diam = 2.0, screw_type = "round", head_diam = 3.65,
                    head_height = 1.96, length = 8, $fn=80);
