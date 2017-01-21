$fn=32;
HEIGHT=6.3;

module corner_circles(dims, r) {
    for(x_scale=[1,-1])
        for(y_scale=[1,-1])
            scale([x_scale,y_scale])
            translate([dims[0]/2,dims[1]/2]) circle(r=r);
}

module srr(dims,r) {
    hull()
    corner_circles(dims,r);
}

module rr(dims, r) {
    hull()
    for(x_scale=[1,-1])
        for(y_scale=[1,-1])
            scale([x_scale,y_scale])
            translate([dims[0]/2-r,dims[1]/2-r]) circle(r=r);
}

module main() {
    translate([84/2+25,84/2+25]) union() {
        difference() {
            srr([80,80], 8+3);
        difference() {
    difference() {
        srr([80,80],8);
        // through holes for... whatever
        corner_circles([65,65], 1.6);
    }
    // -6 gives us the correct OD using outside pathing (necessary to get overlap
    // in cammill)
    circle(d=20,$fn=120);
    }
    } }
}

main();
//translate([96+3.1,0]) main();
