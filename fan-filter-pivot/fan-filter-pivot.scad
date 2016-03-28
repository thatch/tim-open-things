/* Fits the standard Hakko FA400 filters, holes for 120mm fan */

module XYCenteredCube(size) {
    translate([-size[0]/2, -size[1]/2]) cube(size);
}

module XYCenteredClippedCube(size, clip) {
    difference() {
        XYCenteredCube(size);
        for(rotate=[0,90,180,270]) {
            rotate([0,0,rotate])
            linear_extrude(100)
            polygon(points=[
                [size[0]/2 - clip, size[1]/2],
                [size[0]/2, size[1]/2 - clip],
                [size[0] / 2, size[1] / 2]]);
        }
    }
}

module ThinWallCube(dims, thick=1.2) {
    /* dims is outer size, centers in XY */
    inner_dim0 = dims[0] - thick * 2;
    inner_dim1 = dims[1] - thick * 2;
    difference() {
        translate([-dims[0]/2,0,0])
            cube(dims);
        translate([-inner_dim0/2,thick,-1])
            cube([inner_dim0, inner_dim1, dims[2] + 2]);
    }
}

module Arch(dims) {
    r = dims[0] / 2;
    translate([-dims[0]/2,0])
        square([dims[0], dims[1]-r]);
    translate([0,dims[1]-r])
        circle(r=r);
}

module ThinWallArch(dims, thick=1.2) {
    /* origin is at outer middle of square end (X). dims is total outer. */
    linear_extrude(height=dims[2]) difference() {
        Arch(dims);
        translate([0,thick]) Arch([dims[0]-thick*2, dims[1]-thick*2]);
    }
}

module Roundover(r=3,h=100) {
/* origin is  middle in z, and outer edge */
translate([-r,-r,-h/2]) difference() {
cube([r+r,r+r,h]);
translate([0,0,-1]) cylinder(r=r,h=h+2);
}
}

/* rear */
translate([-20,0,0]) {
cube([6.5,30,6]);
cube([6.5,3,8]);
}

/* front */
translate([-30,10,0])
difference() {
    cube([6.5,20,6]);
    translate([0,0,6]) rotate([90,0,0]) rotate([0,-90,0]) Roundover($fn=100);
}

translate([0,0,0]) {
cube([8,12,8]);
translate([4,20,4]) rotate([0,22.5,0]) rotate([90,0,0]) cylinder(r=3.5,h=10,$fn=8);
}

/*ThinWallArch([10,16,6], $fn=100);
translate([20,0,0]) ThinWallCube([10,16,6]);
*/

module Arrow(l=10, w=3, r=1) {
    /* stem */
    hull() {
        circle(r=r);
        translate([0,-l]) circle(r=r);
    }
    /* left */
    hull() {
        circle(r=r);
        translate([-w, -w]) circle(r=r);
    }
    /* right */
    hull() {
        circle(r=r);
        translate([w, -w]) circle(r=r);
    }
}

    
/*translate([-70,-70])
    cube([140,140,6]);
// inset for filter
translate([0,0,2])
    XYCenteredCube([130,130,10]);
// holes
for(rotate=[0:90:360])
    rotate([0,0,rotate])
    translate([105/2, 105/2,-1]) cylinder(r=2.6,h=100);
*/
module Main() {
union () {
    ThinWallCube([10,12,7]);
    translate([0,6.2,5]) rotate([90,0,0])
        linear_extrude(height=1)
        Arrow(l=4,$fn=16);
}

/* back leg */
translate([-3.5,-4.5,-20])
    cube([7,5,40]);
/* back top retainer */
translate([-3.5,-6,15])
    cube([7,4,5]);
/* back piece */
translate([-130/2,-6,-131])
    cube([130,6.5,130]);

/* front leg */
translate([-3.5,1,-20])
    cube([7,3.5,28]);
/* front piece */
translate([-130/2,2,-131])
    cube([130,6.5,130]);

}
