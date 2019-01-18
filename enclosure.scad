// Global config variables
enclosure_height = 25;
enclosure_length = 78;
enclosure_width = 63;
enclosure_radius = 40;
wall_thickness = 1.6;
$fn = 180; // curved resolution (used for cylinders and spheres)


// Position all of the modules

difference() {
    buildBase();
    // Micro usb slot
    translate([34.9,-1,7])cube([8.2,4,3.3]);
    translate([34.33,19.42,-1])cylinder(r=2, h=14);
    translate([38.83,19.42,-1])cylinder(r=1, h=14);
    translate([43.33,19.42,-1])cylinder(r=2, h=14);
}

difference() {
    translate([30,4.1,0]) {
        featherScrew();
    }
    translate([20,-1.1,-1]) {
        cube([41,wall_thickness+1,enclosure_height + 2]);
    }
}

translate([27,wall_thickness +0.5,0]) {
    rotate(90, [0,0,1]) {
        batteryHolder();
    }
}

translate([27.6,wall_thickness,10]) {
    //featherBoard();
}

module batteryHolder() {
    difference() {
        translate([0,1,1]) {
            cube([73.46, 22, 11]);
        }
        translate([1,12,12]) {
            rotate(90, [0,0,1]) {
                rotate(90, [1,0,0]) {
                    #cylinder(r=9.35, h=71);
                }
            }
        }
        translate([70.5,-1,6]) {
            cube([2.5,8,8]);
        }
        translate([2,-1,6]) {
            //cube([2.5,8,6]);
        }
    }
}

module rcube(size, radius) {
    // rcube module found here: https://www.prusaprinters.org/parametric-design-in-openscad/
    hull() {
        translate([radius, radius]) cylinder(r = radius, h = size[2]);
        translate([size[0] - radius, radius]) cylinder(r = radius, h = size[2]);
        translate([size[0] - radius, size[1] - radius]) cylinder(r = radius, h = size[2]);
        translate([radius, size[1] - radius]) cylinder(r = radius, h = size[2]);
        //translate([1, size[1] - 1]) cylinder(r = 1, h = size[2]);
    }
}

// Base of enclosure
module buildBase() {
    // Cylinder with a smaller cylinder cut out of it
    difference() {
        rcube([enclosure_width,enclosure_length,enclosure_height], 10);

        //cylinder(h = enclosure_height, r = enclosure_radius);
        // Make the cylinder hollow
        translate([wall_thickness,wall_thickness,wall_thickness]) {
            rcube([enclosure_width - wall_thickness * 2, enclosure_length - wall_thickness * 2,enclosure_height], 10);
          inner_height = enclosure_height;
          inner_radius = enclosure_radius - (wall_thickness * 2);
          //cylinder(h = inner_height, r = inner_radius, center = false);
        }

        // Flat back for power hookup
        translate([enclosure_radius - 5,-10,5]) {
          //cube([8,20,7]);
        }
        translate([enclosure_width / 2,enclosure_length / 2,enclosure_height - 14]) {
          radialVents(2, 6, 2, 3, enclosure_radius + 20);
        }
    }
}

// Radial vents
// ventSpacing in mm
// horizontalSpacing in degrees (divisible by 360)
module radialVents(verticalSpacing, horizontalSpacing, size, numRows, ventRadius) {
    for ( m = [0 : numRows] ){
        for ( k = [110 : 120] ){
            // Rotate by 45 degrees to avoid needing support when printing
            translate([0,0,m * verticalSpacing + 4]) {
                offset = horizontalSpacing / 2;
                rotate( k * horizontalSpacing - m * offset, [0, 0, 1]){
                    rotate( 45, [0, 1, 0]) {
                        cube([size, ventRadius, size]);
                    }
                }
            }
        }
    }
}

// Featherboard with usb
module featherBoard() {
    difference() {
        rcube([22.86,50.8,1.19], 2.5);
        translate([2.54,2.54,-2])cylinder(r=1.35, h=14);;
        translate([2.54,48.26,-2])cylinder(r=1.35, h=14);;
        translate([20.32,48.26,-2])cylinder(r=1.35, h=14);;
        translate([20.32,2.54,-2])cylinder(r=1.35, h=14);;
    }
    translate([7.43,-1.2,-2.6]) {
        cube([8, 5, 2.7]);
    }
    translate([15.33,17.42,-2])cylinder(r=1.5, h=2);
    translate([6.7,17.42,-2])cylinder(r=1.5, h=2);
}

module featherFriction(pegRadius) {
    translate([0,0,0])frictionmount(pegRadius);
    translate([0,45.72,0])frictionmount(pegRadius);
    translate([17.78,45.72,0])frictionmount(pegRadius);
    translate([17.78,0,0])frictionmount(pegRadius);
}

// Screw mount spaced for a feather board
module featherScrew() {
    translate([0,0,0])screwmountM25();
    translate([0,45.72,0])frictionmount(1.1);
    translate([17.78,45.72,0])frictionmount(1.1);
    translate([17.78,0,0])screwmountM25();
}

// M2.5 screw mount for 6mm length M2.5 screws
module screwmountM25() {
    translate([0,0,1.9]) {
        rotate_extrude(convexivity = 10) {
            translate([2.5,0,0]) {
                intersection() {
                    square(8);
                    difference() {
                        square(5, center = true);
                        translate([4,4])circle(4);
                    }
                }
            }
        }
    }
    cylinder(r=5, h=2);
    difference() {
        cylinder(r=2.5, h=10);
        translate([0,0,4]) {
            #cylinder(r=1.2, h=9);
        }
    }
}

// Friction mount for screw holes
module frictionmount(pegRadius) {
 translate([0,0,2.8]) {
        rotate_extrude(convexivity = 10) {
            translate([2.5,0,0]) {
                intersection() {
                    square(8);
                    difference() {
                        square(5, center = true);
                        translate([4,4])circle(4);
                    }
                }
            }
        }
    }
    cylinder(r=5, h=3);
    cylinder(r=2.5, h=11);
    cylinder(r=pegRadius, h=14);
}
