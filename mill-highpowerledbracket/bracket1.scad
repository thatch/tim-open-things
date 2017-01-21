$fn=120;
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

difference() {
    translate([0,0,-HEIGHT])
    linear_extrude(height=HEIGHT,convexity=8)
    difference() {
        srr([84,84],8);
        rr([28,28],2);
        // for heat-press, waterblock mounting
        corner_circles([84,84], 2.5);
        // through holes for... whatever

        corner_circles([84,72], 1.6);
    }
    translate([0,0,-1])
        linear_extrude(height=100,convexity=3)
        rr([40,40],2);
}
//cylinder(d=87,h=10);


