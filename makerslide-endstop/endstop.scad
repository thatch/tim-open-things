// To use, print 2x and use with a switch like D2F-L or D2F-FL.
// Holes are sized for M2 or smaller machine screw (#2 wood screw does not fit
// through microswitch holes).  For use with Grbl shield, wire up X,Y,Z to pins
// D9-D11.  TODO figure out which of normally open or normally closed works
// with firmware.  Note that X and Y use different lengths, see end of file.

// TODOS
// * make h= var do something useful
// * slightly enlarge so it fits snugly and doesn't move around
// * figure out why the hole doesn't go all the way through
// * come up with a plate that has both types
// * document sizing of hole (2.2mm) vs size of screw (down to M1.4)
// * templatize based on something (hopefully total distance + trigger from datasheet)
// * split out profile, so I can use it for other things. Note that this is 20x20 extrusion.

// * cable clip, for if you want to run in the channel
// * version with a tuning fork sort of shape, so a screw can tighten the
//   spacer area (tried something like this once, and it didn't print well --
//   was brittle).

gPlateRows = 1;
gPlateCols = 2;

e = 0.01;

h = 18;
rail_thick = 2.5;

// Set this to 10 if you only want the internal tips trimmed, 40 if you want the outside part to line up too.
tip_trim = 40;

module main() {
  union() {
    difference() {
      bulk();
      // trim exposed part
      translate([-40/2-1,0,0]) cube([40,40,h+2], center=true);
      // mounting hole
      //translate([5,0,h/2-5]) rotate([0,90,0]) cylinder(r1=5.1/2, r2=4/2, h=13, center=true, $fn=30);
    }
    // part the endstop attaches to
    difference() {
      translate([-4/2-e,0,-4]) cube([4,14,10], center=true);
      // mounting holes
      translate([0,7/2,-4]) rotate([0,90,0]) rotate([0,0,180]) cylinder(r=2.2/2, h=30, $fn=3, center=true);
      translate([0,-7/2,-4]) rotate([0,90,0]) rotate([0,0,180]) cylinder(r=2.2/2, h=30, $fn=3, center=true);
    }
  }
}

// This is intentionally untrimmed on the "top" part, so the caller can adjust
// height.
module bulk() {
  difference() {
    translate([-8.5,0,0]) rotate([0,0,45]) cube([25, 25, h], center=true);
    // trim bottom
    translate([24/2+6,0,0]) cube([24, 24, h+2], center=true);

    // trim top (this aligns the left edge with the center line)
    translate([rail_thick/2,12.5,0]) cube([rail_thick,20,h+2], center=true);
    // trim bottom
    translate([rail_thick/2,-12.5,0]) cube([rail_thick,20,h+2], center=true);

    // trim one tip
    translate([5,10,0]) cube([tip_trim,10,h+2], center=true);
    // trim other tip
    translate([5,-10,0]) cube([tip_trim,10,h+2], center=true);
  }
}

difference() {
  union() {
    // place on z=0
    translate([0,0,10])
    for(i = [0:gPlateRows-1]) {
      for(j = [0:gPlateCols-1]) {
        translate([i*20,j*20,0]) main();
      }
    }
  }
  // Trim length of stop varies depending on use (on a Shapeoko):
  // 100/2+15 for y stops
  // 100/2+22 for x stops
  translate([0,0,100/2+22]) cube([100,100,100], center=true);
}
