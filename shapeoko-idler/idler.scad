// Idler designed for use with a Shapeoko and 625Z bearings.
// Loosely designed around existing idler's dimensions, drawing at
// http://www.buildlog.net/documents/b30041_rev_1.pdf
// but adapted experimentally to be printable and snug.

idler_width = 11.2;
bearing_od = 16;
bearing_clearance = 0.22;
// Wall needs to be wide enough that your slider gives it two perimeters, so
// ~double your nozzle.  0.75 works for an 0.4 nozzle in skeinforge.
wall = 0.75;
e = 0.02;

$fn=100;
difference() {
  union() {
    // main body
    cylinder(r=bearing_od/2+wall, h=idler_width);
    // base flange
    cylinder(r=bearing_od/2+2.5, h=1.6);
    // top flange, spool-shaped to be printable with 45-degree overhang
    translate([0,0,9.6])
      cylinder(r1=bearing_od/2+wall, r2=bearing_od/2+2.5, h=2.5-wall);
    translate([0,0,9.6+2.5-wall-e])
      cylinder(r=bearing_od/2+2.5, h=1);
  }
  // cutouts
  union() {
    // bearing size
    translate([0,0,1.6-e])
      cylinder(r=bearing_od/2+bearing_clearance, h=idler_width+2);
    // leave bottom flange inside
    translate([0,0,-1])
      cylinder(r=bearing_od/2-1.5, h=3.6, $fn=20);
  }
}
