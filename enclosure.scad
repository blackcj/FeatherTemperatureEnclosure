// Global config variables
enclosure_height = 25;
enclosure_radius = 54;
wall_thickness = 1;
$fn = 180; // curved resolution (used for cylinders and spheres)

module batteryHolder() {
    difference() {
        translate([0,0,1]) {
            cube([75.46, 24, 11]);
        }
        translate([2,12,12]) {

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
difference() {
    translate([54,54,0]) {
        buildBase();
    }
    translate([34,0,-1]) {
        cube([41,3,28]);
    }
}


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
        translate([enclosure_radius - 5,-10,5]) {
          //cube([8,20,7]);
        }
        translate([0,0,enclosure_height - 14]) {
          radialVents(1.5, 5, 1.5, 4, enclosure_radius + 20);
        }
    }
}

// Radial vents
// ventSpacing in mm
// horizontalSpacing in degrees (divisible by 360)
module radialVents(verticalSpacing, horizontalSpacing, size, numRows, ventRadius) {
    for ( m = [0 : numRows] ){
        for ( k = [0 : 90] ){
            // Rotate by 45 degrees to avoid needing support when printing
            translate([0,0,m * verticalSpacing + 30]) {
                offset = horizontalSpacing / 2;
                rotate( k * horizontalSpacing - m * offset, [0, 0, 1]){
                //translate([0, grid_spacing * i, grid_spacing * k])
                    rotate( 45, [-1, 1, 0]) {
                        cube([size, ventRadius, size]);
                    }
                }
            }
        }
    }
}

// Plate
difference() {
    translate([54,54,0]) {
        cylinder(r=54, h=1.2, center=false);
    }
    translate([34,0,-1]) {
        cube([41,3,12]);
    }
}
difference() {
    translate([46,7.2,0]) {
        featherScrew();
    }
    translate([34,0,-1]) {
        cube([41,3,12]);
    }
}

translate([16,63,0]) {
    rotate(0, [0,0,1]) {
        batteryHolder();
    }
}
// Micro usb slot
difference() {
    translate([36,3,0]) {
        cube([36,1.6,enclosure_height]);
    }
    translate([50.9,2,11.2]) {
        cube([7.7,4,2.7]);
    }
}

// Featherboard
translate([43.5,4.7,10]) {
    //#cube([22.86,50.8,1.4]);
}
//cube([75.46,90,2]);

module featherFriction() {
    translate([0,0,0])screwmount();
    translate([0,45.72,0])screwmount();
    translate([17.78,45.72,0])screwmount();
    translate([17.78,0,0])screwmount();
}

module featherScrew() {
    translate([0,0,0])screwmountM25();
    translate([0,45.72,0])screwmountM25();
    translate([17.78,45.72,0])screwmountM25();
    translate([17.78,0,0])screwmountM25();
}

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

module screwmount() {
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
    cylinder(r=1.25, h=14);
}
