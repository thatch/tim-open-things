// Tested on a 5mm shaft and it works! Fits very sungly.

trap_nut_depth = 9.1;

// nut measures: 7.91 flat faces, 9.05 pointed faces, 3.8 thick
// TODO merge this into a library module, and increase 9.05 figure slightly
// because it's too tight (plus, probably more natural to specify the small
// dimension and derive the large one).

// screw, nut thick, wide (tips)
M5 = [5, 3.9, 9.24];
gCos30 = 0.866; // math.cos(pi/6 or 30 deg)

// Screw axis is at z=0, nut itself is centered on origin.
module TrapNut(x, d) {
  // nut-shaped bottom
  rotate([0,90,0]) cylinder(r=x[2]/2, h=x[1], $fn=6, center=true);
  // entrance hole (slightly larger)
  translate([0,0,-x[2]/2])
    cube([x[1]+0.1, x[2]*gCos30, d], center=true);
}

union() {
  translate([0,0,20])
  rotate([0,180,0])
  difference() {
    union() {
      // handle part
      translate([0,0,8/2+12]) cylinder(r=20, h=8, center=true, $fn=20);
      // shaft part
      translate([0,0,7]) cylinder(r=10, h=14, center=true);
    }
    // trap nut hole
    translate([5, 0, trap_nut_depth/2-0.1])
      TrapNut(M5, trap_nut_depth);
    // screw hole
    #translate([20/2,0,trap_nut_depth/2])
      rotate([0,90,0])
        cylinder(r=M5[0]/2, h=20, center=true);
    // motor hole
    translate([0,0,10.5/2-0.1])cylinder(r=5/2,h=10.5,center=true,$fn=30);
  }
  // For checking that the part lays on z=0
  //color([0.5,0.5,0.5,0.4]) translate([0,0,-1/2]) cube([50,50,1], center=true);
}
