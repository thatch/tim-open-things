include <../libs/trig.scad>;

// enlarged to account for shrink
g3mm = 3.45;
g3mmnut = 5.85;
g2mm = 2.0;
gNutChamfer = 0.5;

gMicroswitchHoleSpacing = 6.0;
gSideClampHole1 = 0;
gSideClampHole2 = 10;

gTopClampY1 = 15;
gTopClampY2 = 30;
gClampOffset = 10;
gSideClampOffset = 0;

module NutTrap(x,h=100) {
    cylinder(d=x/0.866,h=h,$fn=6);
    translate([0,0,-0.01])
        cylinder(d1=(x+gNutChamfer)/0.866,d2=x/0.866,h=gNutChamfer,$fn=6);
}

/* cylinder_wall_thick should be a small integer *nozzle_dia */
module NutTrapSupport(d,h,cylinder_wall_thick=0.7,cylinder_wall_offset=0.1) {
    cylinder(d=d+cylinder_wall_offset*2,h=h,$fn=16);
}


module Fillet(r,h=100) {
    difference() {
        cube([r,r,h]);
        translate([0,0,-1]) cylinder(r=r,h=h+2);
    }
}

/* Side clamp, in two parts */

module SideBody() {
    difference() {
        translate([0,-4,0]) cube([22,24,5+gSideClampOffset]);
        if(gSideClampOffset > 0) {
            translate([1,-4.01,5.01]) cube([22,16,10]);
            translate([0.5,0.5,5.01]) linear_extrude(height=10, convexity=3) SideClampOutline();
        }
        translate([-1,-5,3.5]) cube([11,27,5+gSideClampOffset]);
        translate([14,17,-1]) cylinder(d=g2mm,h=100,$fn=32);
        translate([14+gMicroswitchHoleSpacing,17,-1]) cylinder(d=g2mm,h=100,$fn=32);
        translate([8,gSideClampHole1,-1]) cylinder(d=g3mm,h=100,$fn=32);
        translate([8,gSideClampHole2,-1]) cylinder(d=g3mm,h=100,$fn=32);
    }
}

gSidePos1 = [8,18];
gSidePos2 = [11,4];
gSideCutoutRad = 25;

module SideClampOutline() {
    difference() {
        hull() for(c=[[4,-2],[11,-2],[4,18],gSidePos1,gSidePos2])
            translate(c) circle(r=2,$fn=32);
        translate([0,0,-1])
            translate(CircleCircleIntersection(gSidePos1, gSidePos2, 2, gSideCutoutRad))
            circle(r=gSideCutoutRad,$fn=256);
    }
}

module SideClamp() {
    difference() {
        linear_extrude(height=5, convexity=3) SideClampOutline();
        //translate(gSidePos1) cylinder(r=2,h=10);
        //translate(gSidePos2) cylinder(r=2,h=10);
        translate([8,gSideClampHole1,-1]) union() {
            cylinder(d=g3mm,h=100,$fn=32);
            translate([0,0,6.1]) scale([1,1,-1]) NutTrap(g3mmnut,3);
        }
        translate([8,gSideClampHole2,-1]) {
            cylinder(d=g3mm,h=100,$fn=32);
            translate([0,0,6.1]) scale([1,1,-1]) NutTrap(g3mmnut,3);
        }
    }
}


/* Top clamp, in two parts */

module TopBody() {
    difference() {
        union() {
            translate([-1,0,0]) cube([11,35,12]);
            /* thing adjustment screw goes on */
            hull() for(x=[-9,0])
                for(y=[1,9])
                    translate([x,y]) cylinder(r=1,h=12);
            translate([-2.99,11.99,0]) rotate([0,0,-90]) Fillet(2,12);
        }
        hull() {
            for(x=[5,10])
                for(y=[10,50])
                    translate([x,y,3])
                    cylinder(r=2,h=100);
        }
        hull() {
            for(x=[5+1.7,10])
                for(y=[10+1.7,50])
                    translate([x,y,-1])
                    cylinder(r=2,h=100);
        }
        /* adjustment screw */
        translate([-5,5,0]) {
            NutTrap(g3mmnut,3);
            cylinder(d=g3mm,h=200);
        }
        /* notch for frame */
        hull() {
            for(x=[8,20])
            translate([x,0,-1]) cylinder(r=2,h=100);
        }
        /* clamp holes */
        for(y=[gTopClampY1,gTopClampY2])
            translate([-10,y,6])
            rotate([0,90,0]) cylinder(d=g3mm,h=100);
    }
    /* adjustment screw support */
    translate([-5,5,0]) NutTrapSupport(g3mm,3);
}

module TopClamp() {
    difference() {
        intersection() {
            cube([12,25,6]);
            hull() {
                translate([0,2,4]) rotate([0,90,0]) cylinder(r=2,h=100);
                translate([0,50,4]) rotate([0,90,0]) cylinder(r=2,h=100);
                translate([0,50,-50]) rotate([0,90,0]) cylinder(r=2,h=100);
                translate([0,2,-50]) rotate([0,90,0]) cylinder(r=2,h=100);
            }
        }
        /* clamp holes */
        for(y=[gTopClampY1,gTopClampY2])
            translate([6,y-gClampOffset,0]) {
                cylinder(d=g3mm,h=100);
                NutTrap(g3mmnut,3);
            }
    }
    /* clamp holes support */
    for(y=[gTopClampY1,gTopClampY2])
        translate([6,y-gClampOffset,0])
            NutTrapSupport(g3mm,3);
}

TopBody($fn=32);

/* to visualize together */
/* translate([11,gClampOffset,0]) rotate([0,-90,0]) Clamper($fn=32); */
/* for printing */
translate([7,gClampOffset+2,0]) TopClamp($fn=32);

translate([-25,15,0]) SideBody();
/* to visualise together  */
/* translate([-25,15,6+gSideClampOffset]) SideClamp(); */
/* for printing */
translate([-15,-3,0]) rotate([0,0,90]) SideClamp();
