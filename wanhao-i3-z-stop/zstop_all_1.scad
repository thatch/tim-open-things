g3mm = 3.2;
g2mm = 2.0;

gMicroswitchHoleSpacing = 6.0;
gSideClampHole1 = 0;
gSideClampHole2 = 10;

gTopClampY1 = 15;
gTopClampY2 = 30;
gClampOffset = 10;

module NutTrap(x,h=100) {
    cylinder(d=x/0.866,h=h,$fn=6);
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
        translate([0,-4,0]) cube([22,24,5]);
        translate([-1,-5,3.5]) cube([11,27,5]);
        translate([14,17,-1]) cylinder(d=g2mm,h=100,$fn=32);
        translate([14+gMicroswitchHoleSpacing,17,-1]) cylinder(d=g2mm,h=100,$fn=32);
        translate([8,gSideClampHole1,-1]) cylinder(d=g3mm,h=100,$fn=32);
        translate([8,gSideClampHole2,-1]) cylinder(d=g3mm,h=100,$fn=32);
    }
    
}

module SideClamp() {
    difference() {
        translate([3,-3,0]) cube([9,16,5]);
        translate([30+10,15,-1]) cylinder(r=30,h=100,$fn=100);
        translate([8,gSideClampHole1,-1]) union() {
            cylinder(d=g3mm,h=100,$fn=32);
            translate([0,0,4]) NutTrap(5.6);
        }
        translate([8,gSideClampHole2,-1]) {
            cylinder(d=g3mm,h=100,$fn=32);
            translate([0,0,4]) NutTrap(5.6);
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
        translate([-5,5,-1]) {
            NutTrap(5.6,3);
            cylinder(d=3.2,h=200);
        }
        /* notch for frame */
        hull() {
            for(x=[8,20])
            translate([x,0,-1]) cylinder(r=2,h=100);
        }
        /* clamp holes */
        for(y=[gTopClampY1,gTopClampY2])
            translate([-10,y,6])
            rotate([0,90,0]) cylinder(d=3.2,h=100);
    }
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
            translate([6,y-gClampOffset,-1]) {
        
            cylinder(d=3.2,h=100);
                NutTrap(5.6,3);
            }
        
    }
}

TopBody($fn=32);
/* to visualize together */
/* translate([11,gClampOffset,0]) rotate([0,-90,0]) Clamper($fn=32); */
/* for printing */
translate([7,gClampOffset+2,0]) TopClamp($fn=32);

translate([-25,15,0]) SideBody();
translate([-14,-2,0]) rotate([0,0,90]) SideClamp();