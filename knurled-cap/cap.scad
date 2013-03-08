e = 0.01;

//Knob(knobType=0, $fn=100);

module KnurledKnob(h=10,r=10,chamfer=0.5,
                   knurlAngle=9, knurlSize=0.4, knurlOffset=0.2) {
  difference() {
    union() {
      // outer surface
      translate([0,0,chamfer-e])
        cylinder(h=h-(2*chamfer), r=r);
      // slight chamfers
      cylinder(h=chamfer+e, r1=r-chamfer, r2=r);
      translate([0,0,h-chamfer-e])
        cylinder(h=chamfer, r1=r, r2=r-chamfer);
    }
    for(i=[0:knurlAngle:360])
      rotate([0,0,i])
        translate([r+knurlOffset,0,-1])
          cylinder(h=h+2, r=knurlSize, $fn=10);
  }
}

// with "top" facing down
module TeeKnob(h=10, r1=10, r2=20, chamfer=0.5,
               knurlAngle=9, knurlSize=0.4, knurlOffset=0.2) {
  union() {
    difference() {
      union() {
        translate([0,0,h/2-e])
          cylinder(h=h/2, r=r1);
        cylinder(h=h/2, r1=r1*0.9, r2=r1);
      }
      // knurling
      for(i=[0:knurlAngle:360])
        rotate([0,0,i])
          translate([r1+knurlOffset,0,-1])
            cylinder(h=h+2, r=knurlSize, $fn=10);
    }
    // handles
    for(i=[0:180:360])
      rotate([0,0,i])
        linear_extrude(height=h-e)
          polygon([[-r1*0.5,0], [-r1*0.2,r2], [r1*0.2,r2], [r1*0.5,0]]);
  }
}


// knob types: 0=straight knurled, 1=tee
// example of straight knurled is mcmaster 91175A061, tee is 91175A081
// see catalog page for more common types
module Knob(outerRad=8, pegRad=2.5, capRad=5.5, pegHeight=3, innerHeight=4,
            thick=6, chamfer=0.5, knurlAngle=9, knurlSize=0.4, knurlOffset=0.2,
            knobType=0) {
  baseThick = thick - innerHeight;

  union() {
    difference() {
      if(knobType==0)
        KnurledKnob(h=thick, r=outerRad, chamfer=chamfer,
                    knurlAngle=knurlAngle, knurlSize=knurlSize, knurlOffset=knurlOffset);
      else
        TeeKnob(h=thick, r1=outerRad, r2=outerRad*1.8, chamfer=chamfer);
      // inner cutout
      translate([0,0,baseThick+e]) cylinder(h=innerHeight, r=capRad, $fn=32);
    }
    // peg
    translate([0,0,baseThick-e])
      cylinder(h=pegHeight, r=pegRad, $fn=16);
  }
}
// vim: ft=c sw=2 sts=2 ts=2 et
