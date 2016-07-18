/* This is a bit of a hack since angled holes are required. */
gSpacerThick = 9;
gSpacerPlusHeatsinkThick = 11;
gFanThick = 10; // hole right in the middle?
gMotorHoleSpacing = 31;
gFanHoleSpacing = 32;
gGrillThick = 3;

/* Orientation is that "up" faces into the heatsink. */
module Spacer(w=40,r=2,thick=gSpacerThick) {
    linear_extrude(height=thick)
        hull()
        for(x=[w/2-r,w/2-8+r])
            for(y=[r,9-r])
                translate([x,y]) circle(r=r);
}

module SpacerHole(thick=gSpacerThick) {
    // TODO
    //translate([16,4.5,-1]) cylinder(d=3.4,h=thick+2);
}

/* For reuse building the two parts to line up */
module LowerHull(w,r,thick,d=0) {
    linear_extrude(height=thick) hull() {
        for(x=[w/2-r-d,-(w/2-r-d)])
            translate([x,r-d]) circle(r=r);
        for(x=[w/2-8-r,-(w/2-8-r)])
            translate([x,-8+r]) circle(r=r);
    }
}

module SpacerMount(w=40,r=2,thick=9) {
    difference() {
        LowerHull(w,2,thick);
        translate([0,0,-1]) linear_extrude(height=thick+2)
        hull() {
            for(x=[w/2-7-r,-(w/2-7-r)])
                for(y=[r+0.01,r*2])
                    translate([x,y]) circle(r=r);
        }
        // this is rotated, so can't linear_extrude easily
        hull() {
            for(y=[-r-1,-10])
            translate([0,y,thick])
            rotate([0,90,0]) cylinder(r=2,h=100,center=true);
        }
        for(x_scale=[1,-1])
            scale([x_scale,1,1])
            translate([6,-4.5,-1]) union() {
                cylinder(d=3.4,h=100);
                translate([0,0,thick-3]) cylinder(d=5.7,h=100);
            }
    }
}

module SpacerPair() {
    difference() {
        union() {
            Spacer($fn=32);
            scale([-1,1,1]) Spacer($fn=32);
            translate([-38/2,1.32,0]) cube([38,1.7,8]);
            SpacerMount($fn=32);
        }
        SpacerHole($fn=32);
        scale([-1,1,1]) SpacerHole($fn=32);
    }
}

module ThinCylinder(r,h,t) {
    difference() {
        cylinder(r=r,h=h);
        translate([0,0,-1]) cylinder(r=r-t,h=h+2);
    }
}

module FanGrill(r,spacing1=1.6,spacing2=8,height=gGrillThick) {
    translate([0,0,-0.01]) difference() {
        cylinder(r=r,h=100);
        rotate([0,0,45]) cube([spacing1,100,height*2],center=true);
        rotate([0,0,-45]) cube([spacing1,100,height*2],center=true);
        for(x=[2.5:spacing2:r]) {
            ThinCylinder(x,height,spacing1);
        }
    }
}

module ChamferCylinder(r,h,c=2) {
    cylinder(r=r,h=h-c);
    translate([0,0,h-c]) cylinder(r1=r,r2=r-c,h=c);
}

gOffset = 0.5;
module FanMount(w=40,r=4,thick=3) {
    // Bottom flat part
    difference() {
        union() {
            hull() {
                translate([0,gOffset,0]) for(x_scale=[1,-1])
                    for(y_scale=[1,-1])
                        scale([x_scale,y_scale,1])
                        translate([w/2-r,w/2-r])
                        cylinder(r=r,h=thick);
                translate([0,-20,0]) LowerHull(w,2,thick);
            }
            translate([0,gOffset,0]) for(x_scale=[1,-1])
                for(y_scale=[1,-1])
                scale([x_scale,y_scale,1])
                translate([16,16,0.01])
                    ChamferCylinder(5.6/2,thick+3.5,0.6);
        }
        translate([0,gOffset,0]) FanGrill(r=16,height=thick-1);
        // TOOD angle this
        /*for(x_scale=[1,-1])
            scale([x_scale,1,1])
            translate([16,-16,-0.01]) cylinder(d=3.4,h=100);
        */
    }
    // Top part
    difference() {
        translate([0,-20,0]) LowerHull(w,2,thick+11,4);
        //cube([40,40,40],center=true);
        for(x_scale=[1,-1])
            scale([x_scale,1,1])
            translate([6,-20-4.5,-1]) cylinder(d=2.9,h=100);
    }
}

/* For printing */
//translate([0,-40,0]) SpacerPair();
/* Assembly */

translate([0,-40,0]) translate([0,20,-12])
difference() {
    union() {
        translate([0,-20,12]) SpacerPair();
        //FanMount($fn=64);
    }
    for(x_scale=[1,-1]) scale([x_scale,1,1])
    translate([-31/2,-31/2,gSpacerPlusHeatsinkThick+gFanThick+2])
        rotate([0,atan2(0.5,32),0])
        cylinder(d=3.4,h=100,$fn=16,center=true);
}

difference() {
    FanMount($fn=64);
    for(x_scale=[1,-1]) scale([x_scale,1,1])
    translate([-31/2,-31/2,gSpacerPlusHeatsinkThick+gFanThick+2])
        rotate([0,atan2(0.5,32),0])
        cylinder(d=3.4,h=100,$fn=16,center=true);
}

/*
projection(cut=false) rotate([0,90,0]) {
translate([0,-20,12]) SpacerPair();
FanMount($fn=64);
}
*/
