// heavily inspired by http://www.thingiverse.com/thing:16380/


module UpperLeftWall() {
  hull() for(p=[[0,0],[0,100],[100,0],[100,100]])
    translate([p[0],0,p[1]])
    rotate([90,0,0]) cylinder(r=2.5,h=6,$fn=32);
}

module InverseUpperLeftWall() {
  difference() {
    translate([-10,-4,0]) cube([200,5,200]);
    UpperLeftWall();
  }
}
    

module Stationary(screw_rad=3, wide=15, wall_thick=4, adjuster_wide=8, clearance=0.2, tall=55) {
  difference(){
    cube([wide,25,tall]);
    translate([-1,wall_thick,wall_thick])
      cube([wide+2,adjuster_wide+clearance, 30]);
    translate([wide/2, wall_thick+adjuster_wide/2, -1]) cylinder(r=screw_rad,h=100);
    translate([2.5,25,-100+tall-2.5]) InverseUpperLeftWall();
    // mounting screw
    translate([2.5,-1,tall-2.5]) rotate([-90,0,0]) cylinder(r=3.3/2,h=100);
  }
  // 3 is maybe 3.3
  difference() {
    union() {
      translate([-10-wall_thick,25-wall_thick-3,0])
        cube([10+wall_thick+1,wall_thick,8]);
      translate([-10-wall_thick,25-wall_thick,0])
        cube([wall_thick,wall_thick+1,8]);
    }
    translate([-10-wall_thick,25-wall_thick,-1])
      rotate([0,0,70])
        cube([20,20,20]);
  }
}


module Adjuster(screw_rad=2.7, stationary_wide=15, adjuster_wide=8, tall=8) {
  difference() {
    union() {
      // part the screw taps in
      hull() {
        translate([adjuster_wide/2,0,0])
          cylinder(r=adjuster_wide/2, h=tall, $fn=32);
        translate([stationary_wide-1, -adjuster_wide/2, 0])
          cube([1, adjuster_wide, tall]);
      }
      // arm
      translate([stationary_wide,-adjuster_wide/2,0]) cube([4,39,tall]);
    }

    translate([adjuster_wide/2,0,-1]) cylinder(r=screw_rad,h=100);
    // microswitch holes
    for(o=[30-9.7,30])
      translate([0,o,tall/2])
        rotate([0,90,0])
          cylinder(r=1.1,h=100,$fn=3);
  }
}

intersection() {
  union() {
    Stationary();
    translate([20,8,0]) Adjuster();
  }
  translate([-50,-1,-1])
    cube([100,100,11]);
}
