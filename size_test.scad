$fn = 64; // curved resolution (used for cylinders and spheres)

// Add a ridge for increased stability
difference(){
    cube([100,60,7]);
    translate([1.5,1.5,2])cube([97,57,8]);
}

translate([6, 8, 0])featherFriction(1.3, 6);

translate([41.56, 8, 0])featherFriction(1.1, 12);

translate([77.12, 8, 0])featherFriction(1, 24);

module featherFriction(pegRadius, resolution) {
    translate([0,0,0])frictionmount(pegRadius, resolution);
    translate([0,45.72,0])frictionmount(pegRadius, resolution);
    translate([17.78,45.72,0])frictionmount(pegRadius, resolution);
    translate([17.78,0,0])frictionmount(pegRadius, resolution);
}

// Friction mount for screw holes
module frictionmount(pegRadius, resolution) { 
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
    cylinder(r=pegRadius, h=14, $fn = resolution);
}