include <spring.scad>
include <metric.scad>
include <../libs/lobes.scad>

/* TODOs
    - screw/cotter holes too detailed
    - inherits $fs/$fn from lobes
    - revisit bearing_thick value
    - split cutaway/plate stuff into another file that imports this one
    - reference M3 dia from metric
    - add spring to cutaway (and, make sure spring works)
    - flip driven so it prints upside down
*/

/* Defines, edit me. */

spring_height_mm = 25;
spring_step_mm = 2;
spring_dia_mm = 10;

cotter_pin_dia_mm = 3;

blind_adjuster_flats_mm = 8.6;
blind_adjuster_outside_rad = blind_adjuster_flats_mm / 2 / cos(30);

d_shaft_mm = 5.3;
d_shaft_flat = 3.3;
d_shaft_setscrew_mm = 3.2;

bearing_thick = 3;
bearing_rad = 5; /* warning: consider spring dia */

rotational_clearance_mm = 0.5; /* each side */

chamber_thick = 2.0;
chamber_rad = blind_adjuster_outside_rad + chamber_thick + bearing_rad + rotational_clearance_mm;

holder_rad = blind_adjuster_outside_rad + 0.5;

/* No defines past this point. */

module NegativeD(r, inset) {
  difference() {
    circle(r=r, $fn=100);
    translate([-50,r-inset]) square([100,100]);
  }
}

module NegativeI(r, w) {
  difference() {
    circle(r=r, $fn=100);
    for(y_scale=[1,-1])
      scale([1,y_scale])
        translate([-50,w/2]) square([100,100]);
  }
}

//NegativeI(5/2, 3);

module Torus(r1, r2) {
  rotate_extrude() {
    translate([r2,0]) circle(r=r1);
  }
}

module TorusSkirt(r1, r2, depth=100) {
  union() {
    Torus(r1, r2);
    difference() {
      translate([0,0,-depth])
        cylinder(r=r2+r1, h=depth);
      translate([0,0,-depth-1])
        cylinder(r=r2-r1, h=depth+2);
    }
  }
}

module PieArc(r, a1, a2) {
  polygon(points=[[sin(a1)*r, cos(a1)*r],
                  [0,0],
                  [sin(a2)*r, cos(a2)*r]]);
}

// TODO appears to have the wrong 0 point.
module Pie(r, start_ang, end_ang) {
  assign(delta=2) {
    for(t=[start_ang+delta:delta:end_ang])
      PieArc(r, t-delta, t);
    if((end_ang-start_ang)%delta != 0)
      PieArc(r, end_ang-((end_ang-start_ang)%delta), end_ang);
  }
}


//Pie(10, -45, 45.75);

module Horseshoe(r1, r2, ang_from_center) {
  for(a=[-ang_from_center,ang_from_center])
    hull() {
      for(yt=[0,-100])
        translate([0,yt,0]) rotate([0,0,a])
          translate([0,-r2,0]) sphere(r1);
  }
  intersection() {
    Torus(r1, r2);
    translate([0,0,-r1]) linear_extrude(r1*2) Pie(r2+r1+1, ang_from_center-180, 360-ang_from_center-180);
  }
}

//Horseshoe(3, 10, 45, $fn=32);

module HorseshoeSkirt() {
}


/* The bottom, which has a D shaft hole. The adjuster will turn loosely within
   this, and the inner hole is just to make sure the spring stays centered. */
module Driven(h=20, d_shaft_inset=7, d_setscrew_inset=3, cotter_inset=10) {
  assign(inner_r=chamber_rad-blind_adjuster_outside_rad-chamber_thick) {
    //difference() {
    //  cylinder(r=chamber_rad, h=100);
    //  translate([0,0,bearing_thick+inner_r])
    //    scale([1,1,-1]) TorusSkirt(inner_r, chamber_rad, $fa=4, $fn=32);
    //}
    difference() {
      cylinder(r=chamber_rad, h=h);
      /* holes */
      translate([0,0,-1]) cylinder(r=blind_adjuster_outside_rad, h=h-cotter_inset-cotter_pin_dia_mm/2-1);
      translate([0,0,h-d_shaft_inset])
        linear_extrude(h=d_shaft_inset+1,convexity=3)
        NegativeI(r=d_shaft_mm/2,w=d_shaft_flat);
      /* setscrew */
      translate([0,0,h-d_setscrew_inset]) rotate([-90,0,0])
        cylinder(r=d_shaft_setscrew_mm/2,h=100);
      hull()
        for(p=[h-d_setscrew_inset,h+d_setscrew_inset])
          translate([0,4,p]) rotate([-90,0,0])
            scale([1,1,1.7]) Nut(M3);
      /* cotter hole */
      translate([-50,0,h-cotter_inset]) rotate([0,90,0])
        cylinder(r=cotter_pin_dia_mm/2,h=100);
      /* less plastic to print */
        translate([0,0,h-cotter_inset-chamber_thick-inner_r-2])
          TorusSkirt(inner_r, chamber_rad, $fa=4, $fn=32);
      /* horseshoe */
      //for(r=[180:10:360]) {
      //  hull()
      //    for(z=[h-cotter_inset+13,h+10])
      //      rotate([0,0,r])
      //        translate([15,0,z]) rotate([90,0,0])
      //        translate([0,0,-50]) cylinder(r=10,h=100, $fn=16);
      //}
    }
  }
}

/* The middle part, which has stairstep holes and provides
   the bearing surface for Holder. */
module Housing(height=48) {
  difference() {
    /* outside */
    cylinder(r=chamber_rad+chamber_thick,h=height);
    /* inside */
    translate([0,0,bearing_thick])
      cylinder(r=chamber_rad+rotational_clearance_mm, h=height);
    /* hole at bottom (as-printed) */
    translate([0,0,-1])
      cylinder(r=holder_rad+rotational_clearance_mm,h=100);
    /* adjustment holes */
    for(i=[0:4])
      translate([0,0,height-6-(i*3)])
        rotate([0,90,-20*i]) translate([0,0,-50])
        cylinder(r=cotter_pin_dia_mm/2,h=100,$fn=16);
  }
}

module Holder() {
  difference() {
    union() {
      translate([0,0,0.1])
        cylinder(r=holder_rad,h=15);
      cylinder(r=chamber_rad,h=bearing_thick);
    }
    translate([0,0,-1]) cylinder(r=blind_adjuster_outside_rad, h=100, $fn=6);
  }
}

module Cutaway() {
  intersection() {
    union() {
      Housing();
      translate([0,0,26]) Driven();
      translate([0,0,6.5]) rotate([0,180,0]) Holder();
    }
    translate([-100,0,-100]) cube([200,200,200]);
  }
}

//TorusSkirt(3, 10);
//Cutaway();
/* 40 seconds */
//Housing();
/* 36 seconds; 2m17s with curves; 25m to print 0.25/fast 57m to print 0.15/normal */
translate([-40,0,0]) Driven();
/* 9 seconds */
//translate([0,40,0]) Holder();
