// Global config variables
enclosure_height = 30;
enclosure_length = 92;
enclosure_width = 66;
enclosure_radius = 40;
wall_thickness = 1.6;
$fn = 48; // curved resolution (used for cylinders and spheres)

//bottomLayer();
interiorSupport();

// Position all of the modules
module bottomLayer() {
    difference() {
        buildBase();
        // Micro usb slot
        translate([34.9,-1,7.1])cube([8.2,4,3.5]);
        // Hole on the bottom of the enclosure
        translate([30,10,-1])rcube([18,32,10], 5);
        // Opening for power switch
        translate([enclosure_width - wall_thickness - 1,enclosure_length - 38,4]) {
            cube([5,19,13]);
        }
    }

    difference() {
        translate([30,4.1,0]) {
            featherScrew(1.1);
        }
        translate([20,-1.1,-1]) {
            cube([41,wall_thickness+1,enclosure_height + 2]);
        }
    }

    translate([27,wall_thickness +0.5,0]) {
        rotate(90, [0,0,1]) {
            batteryHolderBottom();
        }
    }
}

translate([27.6,wall_thickness,10]) {
    //featherBoard();
}

module batteryHolderBottom() {
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
        translate([69.5,-1,6]) {
            cube([2.5,8,8]);
        }
        translate([2,-1,6]) {
            //cube([2.5,8,6]);
        }
    }
}

module rcube2(size, radius) {
    // rcube module found here: https://www.prusaprinters.org/parametric-design-in-openscad/
    hull() {
        translate([radius, radius]) cylinder(r = radius, h = size[2]);
        translate([size[0] - radius, radius]) cylinder(r = radius, h = size[2]);
        translate([size[0] - 1, size[1] - 1]) cylinder(r = 1, h = size[2]);
        translate([1, size[1] - 1]) cylinder(r = 1, h = size[2]);
        //translate([1, size[1] - 1]) cylinder(r = 1, h = size[2]);
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
    translate([0, enclosure_length,0]) {
        
        platform();
    }
    
    // Cylinder with a smaller cylinder cut out of it
    difference() {

        outerWall();
        // Flat back for power hookup
        translate([enclosure_radius - 5,-10,5]) {
          //cube([8,20,7]);
        }
        translate([enclosure_width / 2,enclosure_length / 2,enclosure_height - 16]) {
          radialVents(2, 6, 2, 2, enclosure_radius + 20, 22, 28);
        }
        translate([enclosure_width / 2,enclosure_length / 2,enclosure_height - 25]) {
          radialVents(2, 6, 2, 6, enclosure_radius + 20, 116, 127);
        }
    }
}

module outerWall() {
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
    }
    
}

module platform() {
    holder_start = enclosure_width / 2;
    translate([0,-14,0]) {
        difference() {
            holder();
            translate([holder_start,0,0]) {
                translate([2,5,4]) {
                    #rotate(22, [1,0,0])cube([22,2,24]);
                }
                translate([3,-5,enclosure_height - 14]) {
                    rotate(22, [1,0,0])cube([20,10,6]);
                }
                translate([-1,10,0]) {
                    rotate(22, [1,0,0])cube([28,10,enclosure_height]);
                }
            }
        }
        
    }
}

module holder() {
    holder_start = enclosure_width / 2;
    translate([holder_start,0,0])cube([26,14,8]);
    translate([holder_start,-1,0])cube([3,8,enclosure_height - 8]);
    translate([holder_start + 23,-1,0])cube([3,8,enclosure_height - 8]);
    translate([1,-3,0])cube([enclosure_width - 2,2,enclosure_height - 8]);
} 

// Radial vents
// ventSpacing in mm
// horizontalSpacing in degrees (divisible by 360)
module radialVents(verticalSpacing, horizontalSpacing, size, numRows, ventRadius, startAngle, finishAngle) {
    for ( m = [0 : numRows] ){
        for ( k = [startAngle : finishAngle] ){
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
module featherScrew(pegRadius) {
    translate([0,0,0])screwmountM25();
    translate([0,45.72,0])frictionmount(pegRadius);
    translate([17.78,45.72,0])frictionmount(pegRadius);
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
            cylinder(r=1.2, h=9);
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
    cylinder(r=2.5, h=10);
    cylinder(r=pegRadius, h=14);
}

module interiorSupport() {
   difference() {
        translate([30,4.1,0]) {
            featherSupport();
        }
        translate([30,4.1,1.19]) {
            featherScrew(1.3);
        }
        translate([20,-1.1,-1]) {
            cube([41,wall_thickness+1,enclosure_height + 2]);
        }
    }
    translate([27,wall_thickness +0.5,0]) {
        rotate(90, [0,0,1]) {
            batteryHolderTop();
        }
    }
    difference() {
        translate([wall_thickness + 0.2,wall_thickness + 0.2,22]) {
            rcube2([enclosure_width - wall_thickness * 2 - 0.6, enclosure_length - wall_thickness * 2 - 13.5,2], 10);
          inner_height = enclosure_height;
          inner_radius = enclosure_radius - (wall_thickness * 2);
        }
        translate([26,5,-1])rcube2([25.5,42.8,30], 1);
        translate([35,53,-1])rcube([22,28,30], 1);
    }
    translate([enclosure_width - 7,7,3])cylinder(r=2, h=21);
}

module batteryHolderTop() {
    difference() {
        translate([4,1,11]) {
            cube([69.46, 22, 11]);
        }
        translate([1,12,12]) {
            rotate(90, [0,0,1]) {
                rotate(90, [1,0,0]) {
                    #cylinder(r=9.35, h=71);
                }
            }
        }
        translate([68,-1,10]) {
            cube([6,8,8]);
        }
        translate([2,-1,6]) {
            //cube([2.5,8,6]);
        }
    }
}

// Interior support bar
module featherSupport() {
    translate([0,45.72,3])cylinder(r=2, h=21);
    translate([17.78,45.72,3])cylinder(r=2, h=21);
}

