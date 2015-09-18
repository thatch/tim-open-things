// screw_clearance_diameter, socket_head_clearance_diameter, nut outside diameter
// TODO untested numbers, these should move to a common include.
// TODO include standard/thin socket head height, nut width, jam nut width
M3 = [3.8, 6.4, 6.5];
M5 = [5.5, 9.4, 9.4];
M8 = [8, 13, 13];

module InsetHole(x) {
  d = x[0];
  socket_head = x[1];
  union() {
    translate([0,0,-50]) cylinder(r=d/2, h=100);
    cylinder(r=socket_head/2, h=10);
  }
}

module Nut(x) {
  assign(nut_size=x[2]) {
    cylinder(r=nut_size/2, $fn=6, h=nut_size/3);
  }
}

module NutHole(x) {
  d = x[0];
  nut_size = x[2];
  union() {
    translate([0,0,1]) cylinder(r=d/2, h=50);
    cylinder(r=nut_size/2, $fn=6, h=6);
  }
}

module CapScrew(x, l) {
  assign($fn=20,d=x[0],socket_head=x[1])
  union() {
    cylinder(r=d/2, h=l+1);
    translate([0,0,l]) cylinder(r=socket_head/2, h=d);
  }
}
