module thin_wall_cube(dims, thick=1) {
    /* centers in XY */
    inner_dim0 = dims[0] - thick * 2;
    inner_dim1 = dims[1] - thick * 2;
    difference() {
        translate([-dims[0]/2,-dims[1]/2,0])
            cube(dims);
        translate([-inner_dim0/2,-inner_dim1/2,-1])
            cube([inner_dim0, inner_dim1, dims[2] + 2]);
    }
}

module arrow(l=10, w=3, r=1) {
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
    

union () {
    thin_wall_cube([10,12,7]);
    translate([0,6.2,5]) rotate([90,0,0])
        linear_extrude(height=1)
        arrow(l=4,$fn=16);
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
