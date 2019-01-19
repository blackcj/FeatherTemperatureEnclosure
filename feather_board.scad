$fn = 180; // curved resolution (used for cylinders and spheres)

rotate(180,[0,1,0]) featherBoard();

// Featherboard with usb
module featherBoard() {
    difference() {
        // PCB
        rcube([22.86,50.8,1.19], 2.5);
        // Holes for mounting
        translate([2.54,2.54,-2])cylinder(r=1.35, h=14);;
        translate([2.54,48.26,-2])cylinder(r=1.35, h=14);;
        translate([20.32,48.26,-2])cylinder(r=1.35, h=14);;
        translate([20.32,2.54,-2])cylinder(r=1.35, h=14);;
    }
    // Micro USB
    translate([7.43,-1.2,-2.6]) {
        cube([8, 5, 2.7]);
    }
    // Buttons
    translate([15.33,17.42,-2])cylinder(r=1.5, h=2);
    translate([6.7,17.42,-2])cylinder(r=1.5, h=2);
}

// Rounded rectangle
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