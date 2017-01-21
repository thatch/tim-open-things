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

translate([84/2+25+8,84/2+25+8]) union() {
difference() {
    difference() {
        srr([84,84],8);
        // for heat-press, waterblock mounting
        corner_circles([84,84], 2.5);
        // through holes for... whatever
        corner_circles([84,72], 1.6);
    }
    rr([40,40],2);
}
rr([28,28],2);
}
//cylinder(d=87,h=10);


