/* Note that the factory bins have draft which make them injection moldable; we
 * don't need that. */

/* The little circles that the legs fit into to keep the bins from moving around */
gLegCircleSize = 18;

/* Most of the bins have X in this orientation. */
gGridX = 40;
gGridY = 55;

/* So the bins don't fit *too* tightly together */
gTopSlop = 0.6;
// TODO This appears to have rounding issues with s3d; add 0.01 for it
gExtWidth = 0.4;
gWall = gExtWidth*3;

// TODO test print for HF, Stanley sizes
//gHeight=47.8; // for HF
gHeight=40.9; // for Stanley
gBaseThick=2;
gFilletRad=3;

gPegHole = 2.5;
gPegHead = 6;
gPegCircle = 18; // measure hole in base, and subtract 1mm for intentional slop
gPegDepth = 8;

module RoundRect(w,h,r=1) {
    hull()
    for(x_scale=[1,-1]) for(y_scale=[1,-1])
    scale([x_scale,y_scale])
    translate([w/2-r,h/2-r]) circle(r=r);
}
module Corner(r,e=1) {
    translate([-r,-r]) difference() {
        square([r+e,r+e]);
        circle(r=r,$fn=128);
    }
}
module Ess(w,h,r) {
    difference() {
        square([w,h]);
        // cut corner
        translate([w,h]) Corner(r);
    }
    // add corners
    translate([w,0]) rotate([0,0,180]) Corner(r,0);
    translate([0,h]) rotate([0,0,180]) Corner(r,0);
}

module Fillet(a, r) {
    intersection() {
        difference() {
            hull() {
                translate([-a,a]) circle(r=a);
                translate([a,-a]) circle(r=a);
            }
            hull() {
                translate([a,r]) circle(r=r);
                translate([r,a]) circle(r=r);
            }
        }
        square([a,a]);
    }
}
e=0.001;
module BaseOutline(x,y,wall,feet) {
    inside_wall_w = (x*gGridX)-(wall*2)-gTopSlop;
    inside_wall_h = (y*gGridY)-(wall*2)-gTopSlop;
    ///RoundRect(x*gGridX-gTopSlop,y*gGridY-gTopSlop,3,$fn=32);
    difference() {
        RoundRect(inside_wall_w,inside_wall_h,3-wall,$fn=32);
        for(x_scale=[1,-1]) for(y_scale=[1,-1])
            scale([x_scale,y_scale])
            translate([-inside_wall_w/2-e,-inside_wall_h/2-e]) Fillet(11, 3, $fn=32);
    }
}

module BaseFillet(x,y,wall,feet) {
    translate([0,0,gFilletRad]) minkowski() {
        sphere(r=gFilletRad,$fn=32);
        linear_extrude(convexity=2,height=1) offset(delta=-gFilletRad) BaseOutline(x,y,wall,feet);
    }
}



module Bin(x=1,y=1,wall=gWall,feet=true,cutaway=false) {
    inside_wall_w = (x*gGridX)-(wall*2)-gTopSlop;
    inside_wall_h = (y*gGridY)-(wall*2)-gTopSlop;
    difference() {
        union() {
            linear_extrude(height=gHeight,convexity=4) difference() {
                RoundRect(x*gGridX-gTopSlop,y*gGridY-gTopSlop,3,$fn=128);
                RoundRect(inside_wall_w,inside_wall_h,3-wall,$fn=32);
            }
            // Floor
            linear_extrude(height=gBaseThick+gFilletRad)
            RoundRect(x*gGridX-gTopSlop,y*gGridY-gTopSlop,3,$fn=32);
            if(feet) {
                linear_extrude(height=gPegDepth+2,convexity=4)
                for(x_scale=[1,-1]) for(y_scale=[1,-1])
                    scale([x_scale,y_scale])
                    translate([-inside_wall_w/2,-inside_wall_h/2]) Fillet(11, 3, $fn=32);
                //Ess(6,6,3);
            }
        }
        if(feet) {
            for(x_scale=[1,-1]) for(y_scale=[1,-1])
                scale([x_scale,y_scale])
                translate([(x*gGridX-gTopSlop)/2,(y*gGridY-gTopSlop)/2,-1])
                rotate([0,0,180+45]) translate([(gPegCircle-gPegHead)/2,0])
                cylinder(d=gPegHole,h=gPegDepth+1,$fn=32);
            translate([0,0,gBaseThick]) BaseFillet(x,y,wall,true);
        }
        if(cutaway) {
            translate([-inside_wall_w/2,-inside_wall_h/2,-1])
            rotate([0,0,-45]) translate([0,-1,0]) cube([12,12,20]);
        }
    }
}

Bin(4,1);
