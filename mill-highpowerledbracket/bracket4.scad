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
    translate([84/2+25+8,84/2+25+8]) union() {
    difference() {
        difference() {
            srr([80,80],8);
            // solder tabs
            rr([54,26], 3);
            // for heat-press, waterblock mounting
            corner_circles([80,80], 2.5);
            // through holes for... whatever
            corner_circles([65,65], 1.6);
            // dogbone fillets for some sharp corners
            for(y_scale=[1,-1])
                for(x_scale=[1,-1]) scale([x_scale,y_scale])
                translate([11.5,20]) circle(d=3);
        }
        difference() {
            rr([40,40],2);

            // scallops, bottom-left edge at 14
            for(x_scale=[1,-1])
                for(y_scale=[1,-1])
                    scale([x_scale,y_scale])
                        translate([14+10,14+10]) srr([10,10], 6);
        }
    }
    // -6 gives us the correct OD using outside pathing (necessary to get overlap
    // in cammill)
    circle(d=20-6,$fn=120);
    //rr([28,28],2);
    }
}

main();
translate([96+3.1,0]) main();
