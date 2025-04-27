// OpenSCAD Code for a Customizable Double Timing Pulley with Belt Type Selection

// --- User Customizable Parameters ---

// Select the type of timing belt
belt_type = "GT2"; // [GT2, GT3, HTD3, HTD5]

// Number of teeth on the pulley
num_teeth = 20; // [8:100]

// Width of the groove for ONE belt (e.g., 6mm or 9mm belt)
// Common widths: GT2/GT3: 6, 9, 10, 15 | HTD3: 6, 9, 15 | HTD5: 9, 15, 25
belt_groove_width = 6; // [4:30]

// Total width of the double pulley (including both grooves, central divider, and outer flanges)
// Must be >= 2 * belt_groove_width + 2 * flange_thickness + central_divider_thickness
total_pulley_width = 18; // [10:80]

// Diameter of the central bore for the shaft
bore_diameter = 5; // [3:20]

// --- Pulley Design Parameters ---
flange_thickness = 1.0; // Thickness of the side flanges
flange_overhang = 1.0; // How much the flange radius extends beyond the tooth tip
central_divider_min_thickness = 1.0; // Minimum thickness for the central divider

// Smoothness of curves
$fn = 60; // Increase for smoother curves, decrease for faster preview

// --- Belt Profile Parameters (Set based on belt_type selection) ---
// These will be overridden by the conditional block below
pitch = 2;
tooth_height = 0.75;
valley_depth = 0.50;
tooth_tip_radius_approx = 0.25; // Approximation for GT profiles
valley_radius_approx = 0.25; // Approximation for GT profiles
is_htd_profile = false; // Flag for HTD profile generation

// --- Set Parameters based on Selected Belt Type ---
echo(str("Selected Belt Type: ", belt_type));

if (belt_type == "GT2") {
    pitch = 2;
    tooth_height = 0.75; // Approximate height of the tooth from pitch radius
    valley_depth = 0.50;  // Approximate depth of the valley below pitch radius
    tooth_tip_radius_approx = 0.25;
    valley_radius_approx = 0.25;
    is_htd_profile = false;
    echo("Using GT2 Profile (Pitch 2mm)");
} else if (belt_type == "GT3") {
    // Assuming 3mm Pitch GT3
    pitch = 3;
    tooth_height = 1.14; // Approx values for GT3-3mm
    valley_depth = 0.76; // Approx values for GT3-3mm
    tooth_tip_radius_approx = 0.4; // Estimated
    valley_radius_approx = 0.4; // Estimated
    is_htd_profile = false;
    echo("Using GT3 Profile (Pitch 3mm - Estimated)");
} else if (belt_type == "HTD3") {
    pitch = 3;
    // HTD uses radius for tooth/valley definition relative to pitch circle
    // These height/depth values simulate that for the profile generator
    tooth_height = 1.17; // Approx total height for HTD3M
    valley_depth = 0.90; // Approx depth for HTD3M valley below pitch
    // Radii aren't directly used in the simplified HTD profile function below,
    // but are inherent in the rounded shape generation.
    is_htd_profile = true;
    echo("Using HTD3 Profile (Pitch 3mm - Approximated)");
} else if (belt_type == "HTD5") {
    pitch = 5;
    tooth_height = 2.06; // Approx total height for HTD5M
    valley_depth = 1.5; // Approx depth for HTD5M valley below pitch
    is_htd_profile = true;
    echo("Using HTD5 Profile (Pitch 5mm - Approximated)");
} else {
    // Default case or handle error
    echo("Warning: Unknown belt_type. Defaulting to GT2.");
    pitch = 2;
    tooth_height = 0.75;
    valley_depth = 0.50;
    tooth_tip_radius_approx = 0.25;
    valley_radius_approx = 0.25;
    is_htd_profile = false;
}


// --- Calculated Parameters (Depend on pitch) ---
pitch_radius = (num_teeth * pitch) / (2 * PI);
outer_radius = pitch_radius + tooth_height; // Radius to the tip of the teeth
root_radius = pitch_radius - valley_depth;   // Radius to the bottom of the tooth valleys
flange_radius = outer_radius + flange_overhang;

// Calculate central divider thickness based on total width
central_divider_thickness = total_pulley_width - (2 * belt_groove_width) - (2 * flange_thickness);

// Sanity check for the total width
assert(central_divider_thickness >= central_divider_min_thickness, str("Error: total_pulley_width (", total_pulley_width, ") is too small for the specified belt_groove_width (", belt_groove_width, "), flange_thickness (", flange_thickness, ") and minimum central divider thickness (", central_divider_min_thickness, "). Minimum required total width is: ", 2 * belt_groove_width + 2 * flange_thickness + central_divider_min_thickness));

// Calculate Z positions for components
z_flange1_start = 0;
z_groove1_start = z_flange1_start + flange_thickness;
z_divider_start = z_groove1_start + belt_groove_width;
z_groove2_start = z_divider_start + central_divider_thickness;
z_flange2_start = z_groove2_start + belt_groove_width;
z_total_height = z_flange2_start + flange_thickness; // Should match total_pulley_width

echo("Calculated Pitch Radius: ", pitch_radius);
echo("Calculated Outer Radius: ", outer_radius);
echo("Calculated Root Radius: ", root_radius);
echo("Calculated Flange Radius: ", flange_radius);
echo("Calculated Central Divider Thickness: ", central_divider_thickness);
echo("Total Height Check: ", z_total_height);

// --- Module Definitions ---

// Module for GT2/GT3-like tooth profile (2D) - Simplified polygon
module gt_profile_2d(pr = pitch_radius, th = tooth_height, vd = valley_depth) {
    angle_step = 360 / num_teeth;
    half_angle = angle_step / 2;
    root_r = pr - vd;
    outer_r = pr + th;

    // Points defining a simplified tooth/valley shape
    // More angular approximation suitable for GT profiles
    p1 = [ root_r * cos(-half_angle*0.95), root_r * sin(-half_angle*0.95) ]; // Valley start
    p2 = [ pr * cos(-half_angle*0.6), pr * sin(-half_angle*0.6) ];         // Pitch line crossing lower flank
    p3 = [ outer_r * cos(-half_angle*0.3), outer_r * sin(-half_angle*0.3) ]; // Tooth flank near top
    p4 = [ outer_r * cos(half_angle*0.3), outer_r * sin(half_angle*0.3) ];   // Tooth flank near top (other side)
    p5 = [ pr * cos(half_angle*0.6), pr * sin(half_angle*0.6) ];           // Pitch line crossing lower flank (other side)
    p6 = [ root_r * cos(half_angle*0.95), root_r * sin(half_angle*0.95) ]; // Valley end

    polygon([
        [root_r * cos(-half_angle), root_r * sin(-half_angle)], // Inner point 1
        p1, p2, p3, p4, p5, p6,                                 // Tooth profile points
        [root_r * cos(half_angle), root_r * sin(half_angle)]    // Inner point 2
    ]);
}

// Module for HTD-like tooth profile (2D) - Simplified rounded polygon
module htd_profile_2d(pr = pitch_radius, th = tooth_height, vd = valley_depth) {
    angle_step = 360 / num_teeth;
    half_angle = angle_step / 2;
    root_r = pr - vd;
    outer_r = pr + th;
    mid_radius = pr; // HTD profile is centered around pitch radius

    // Approximate the rounded HTD profile using more points on arcs
    points = [ for (a = [-half_angle*0.9 : half_angle*0.18 : half_angle*0.9])
        let(
            // Interpolate radius smoothly from root to outer and back to root
            // This is a crude approximation of the circular HTD profile
            interp_factor = abs(a) / (half_angle * 0.9), // 0 at center, 1 at edges
            r = root_r + (outer_r - root_r) * (1 - pow(interp_factor, 2)) // Parabolic interpolation
           )
        [r * cos(a), r * sin(a)]
     ];

    // Create a polygon representing the tooth protrusion from the root cylinder
     polygon(concat(
        [ [root_r * cos(-half_angle), root_r * sin(-half_angle)] ], // Start at root corner
        points,                                                      // Add calculated curve points
        [ [root_r * cos(half_angle), root_r * sin(half_angle)] ]    // End at other root corner
    ));
}


// Module for the toothed section of one pulley groove
module pulley_teeth_section(groove_w = belt_groove_width) {
    // Create the base cylinder (root diameter)
    cylinder(h = groove_w, r = root_radius, center = false);

    // Add teeth by extruding and rotating the appropriate 2D profile
    angle_step = 360 / num_teeth;
    for (i = [0 : num_teeth - 1]) {
        rotate([0, 0, i * angle_step])
        linear_extrude(height = groove_w) {
            if (is_htd_profile) {
                // Use simplified HTD profile
                htd_profile_2d(pr = pitch_radius, th = tooth_height, vd = valley_depth);
            } else {
                // Use simplified GT profile
                gt_profile_2d(pr = pitch_radius, th = tooth_height, vd = valley_depth);
            }
        }
    }
}

// --- Main Pulley Construction ---

difference() {
    // Combine all solid parts
    union() {
        // Outer Flange 1
        translate([0, 0, z_flange1_start])
            cylinder(h = flange_thickness, r = flange_radius, center = false);

        // Toothed Section 1
        translate([0, 0, z_groove1_start])
            pulley_teeth_section(groove_w = belt_groove_width);

        // Central Divider
        // Use pitch_radius for a visually typical divider height
        translate([0, 0, z_divider_start])
            cylinder(h = central_divider_thickness, r = pitch_radius, center = false);

        // Toothed Section 2
        translate([0, 0, z_groove2_start])
            pulley_teeth_section(groove_w = belt_groove_width);

        // Outer Flange 2
        translate([0, 0, z_flange2_start])
            cylinder(h = flange_thickness, r = flange_radius, center = false);
    }

    // Subtract the central bore
    // Add a small epsilon to height to ensure clean cuts
    translate([0, 0, -0.5]) // Start bore slightly below bottom
        cylinder(h = total_pulley_width + 1, r = bore_diameter / 2, center = false);

}
