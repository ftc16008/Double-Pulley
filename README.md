# Double-Pulley
This is a scad program that will create a double belt pulley that has user customizable features.
# Customizable Double Timing Pulley Generator (OpenSCAD)

This OpenSCAD script generates 3D models of double-groove timing pulleys, suitable for use with two parallel timing belts. It allows customization of key parameters, including the belt profile type, number of teeth, belt width, total pulley width, and shaft bore diameter.

The generated design is similar in concept to dual pulleys found commercially, like the one shown in the reference image: [https://www.ebay.com/itm/256056963276](https://www.ebay.com/itm/256056963276)

## Features

*   **Double Groove Design:** Creates pulleys intended for two side-by-side timing belts.
*   **Selectable Belt Profiles:** Supports common timing belt standards via a dropdown menu:
    *   GT2 (2mm pitch)
    *   GT3 (3mm pitch - *approximated profile*)
    *   HTD3 (3mm pitch - *approximated profile*)
    *   HTD5 (5mm pitch - *approximated profile*)
*   **Customizable Tooth Count:** Specify the exact number of teeth required.
*   **Customizable Belt Width:** Define the width of the groove for a single belt (e.g., 6mm, 9mm).
*   **Customizable Total Width:** Control the overall width of the pulley, including flanges and the central divider.
*   **Customizable Bore Diameter:** Set the diameter of the central hole for mounting onto a shaft.
*   **Parametric:** Easily modify parameters within OpenSCAD for different pulley sizes.

## Prerequisites

*   **OpenSCAD:** You need OpenSCAD installed on your system. Download it from [openscad.org](https://openscad.org/).

## How to Use

1.  **Save the Code:** Save the OpenSCAD script provided into a file named `double_pulley.scad` (or any `.scad` extension).
2.  **Open in OpenSCAD:** Launch OpenSCAD and open the `.scad` file.
3.  **Use the Customizer:**
    *   If the "Customizer" panel is not visible, go to `Window -> Customizer`.
    *   This panel provides easy access to the customizable parameters defined in the script.
4.  **Select Belt Type:** Choose the desired belt profile (`GT2`, `GT3`, `HTD3`, `HTD5`) from the `belt_type` dropdown menu. This will automatically adjust the pitch and tooth profile geometry.
5.  **Adjust Parameters:** Modify the other parameters in the Customizer as needed:
    *   `num_teeth`
    *   `belt_groove_width`
    *   `total_pulley_width`
    *   `bore_diameter`
6.  **Preview:** Press `F5` to generate a fast preview of the pulley.
7.  **Render:** Press `F6` to perform a full render (this may take longer). This step is necessary before exporting.
8.  **Export:** Press `F7` (or go to `File -> Export -> Export as STL...`) to save the rendered model as an STL file, which can then be used with a 3D printer slicer.

## Customization Parameters

These parameters are available in the OpenSCAD Customizer panel:

*   `belt_type`: (Dropdown) Selects the timing belt standard. Affects pitch and tooth shape.
*   `num_teeth`: (Integer) The number of teeth on the pulley.
*   `belt_groove_width`: (Number, mm) The width of the channel for a *single* belt. Choose a value matching your belt (e.g., 6 for 6mm wide belts).
*   `total_pulley_width`: (Number, mm) The overall width of the entire double pulley, including both grooves, the outer flanges, and the central divider between the grooves.
    *   **Constraint:** This value *must* be greater than or equal to `(2 * belt_groove_width) + (2 * flange_thickness) + central_divider_min_thickness`. The script includes an `assert` to check this; rendering will fail if the value is too small.
*   `bore_diameter`: (Number, mm) The diameter of the central hole for the motor shaft or axle.

*Other parameters (less commonly changed, defined within the script):*

*   `flange_thickness`: (Number, mm) Thickness of the flanges at each end of the pulley.
*   `flange_overhang`: (Number, mm) How far the flange radius extends beyond the tooth tips.
*   `central_divider_min_thickness`: (Number, mm) The minimum allowed thickness for the divider between the two belt grooves.
*   `$fn`: (Integer) The number of fragments used to approximate curves. Higher values result in smoother curves but increase preview/render time.

## Important Notes

*   **Profile Accuracy:** The tooth profiles for GT3 and especially HTD standards are **approximations** generated using polygons. Generating perfectly accurate involute or complex curve profiles directly in OpenSCAD is challenging. While these approximations often work well for 3D-printed applications, **test printing and checking belt fit is recommended.**
*   **GT3 Pitch:** The "GT3" option currently assumes a **3mm pitch**. GT3 belts also exist in other pitches (like 2mm or 5mm), which are not explicitly handled by this script selection.
*   **Parameter Sanity:** Ensure the `total_pulley_width` is large enough to accommodate the belt grooves, flanges, and a reasonable central divider. Check the console output for any assertion errors if rendering fails.
*   **Units:** All dimensional parameters are in millimeters (mm).

## License

(Optional: You can add a license here, e.g., MIT, CC-BY-SA)
