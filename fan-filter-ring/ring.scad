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

difference() {
    translate([-70,-70])
        cube([140,140,6]);
    // inset for filter
    translate([0,0,2])
        XYCenteredCube([130,130,10]);
    // through ~octagon
    translate([0,0,-1])
        XYCenteredClippedCube([120, 120, 10], 30);
    // holes
    for(rotate=[0:90:360])
        rotate([0,0,rotate])
        translate([105/2, 105/2,-1]) cylinder(r=2.6,h=100);
}
