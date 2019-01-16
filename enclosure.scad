// Global config variables
enclosure_height = 32;
enclosure_radius = 30;
wall_thickness = 1;
$fn = 180; // curved resolution (used for cylinders and spheres)

buildBase();
buildLidWithVents();

// Base of enclosure
module buildBase() {
    // Cylinder with a smaller cylinder cut out of it
    difference() {
        cylinder(h = enclosure_height, r = enclosure_radius);
        // Make the cylinder hollow
        translate([0,0,wall_thickness]) {
          inner_height = enclosure_height;
          inner_radius = enclosure_radius - (wall_thickness * 2);
          cylinder(h = inner_height, r = inner_radius, center = false);
        }

        // Flat back for power hookup
        translate([enclosure_radius - 5,-75,0]) {
          cube([20,150,15]);
        }
        // TODO: Try 1 mm sized holes, may need 1 mm spacing
        // Mesh grid of cubes for airflow
        rotate( 90, [0, 0, 1]) {
            grid(2, 4);
        }
        rotate( 180, [0, 0, 1]) {
            grid(3, 3);
        }
        rotate( 270, [0, 0, 1]) {
            grid(4, 2);
        }
    }
}

// TODO: Try circles instead of squares for the grid
// Grid for the base
module grid(grid_size, numCubes) {
    // TODO: The minimum grid spacing should be set to 2 (which is 1mm)
    // Space holes at 1/2 the width apart
    grid_spacing = grid_size * 1.5;
    // TODO: Translating the grid should be moved to the buildBase module so that the grid can be re-used in other places.
    // Translate the grid to the edge of the enclosure
    translate([enclosure_radius - 8,0,5]) {
        // Mesh grid for airflow
        for ( i = [0 : numCubes] ){
            for ( k = [0 : numCubes] ){
                // Rotate by 45 degrees to avoid needing support when printing
                rotate( 45, [1, 0, 0])
                translate([0, grid_spacing * i, grid_spacing * k])
                cube([10, grid_size, grid_size]);
            }
        }
    }
}

// Lid for the enclosure
module buildLidWithVents() {
    difference() {
        // Draw the plain lid
        lid();
        // Horizontal vents for airflow
        translate([-20,enclosure_radius*3 + 1,12]) {
            rotate( 135, [1, 0, 0])
            cube([40,3,24]);
        }
        translate([-20,enclosure_radius*3 + enclosure_radius - 13,-5]) {
            rotate( 45, [1, 0, 0])
            cube([40,3,24]);
        }
    }
}

// Plain lid
module lid() {
    // Move the lid so it doesn't collide with the base
    translate([0,enclosure_radius*3,0]) {
        inner_height = enclosure_height;
        // Subtract 0.1 to ensure the lid fits (this may need to be adjusted)
        inner_radius = enclosure_radius - (wall_thickness * 2) - 0.1;
        cylinder(h = 4, r = enclosure_radius, center = false, $fn = 180);
        translate([0,0,0]) {
            cylinder(h = 9, r = inner_radius, center = false, $fn = 180);
        }
    }
}
