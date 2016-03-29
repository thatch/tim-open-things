module FourChamfer(sizes,chamfer) {
    m = max(sizes) + 1;
    for(y_scale=[1,-1])
    for(z_scale=[1,-1])
        scale([1,y_scale,z_scale])
        translate([0,sizes[1]/2+sin(45)*m-chamfer,sizes[2]/2])
        rotate([45,0,0])
        cube([m,m,m], center=true);
}

module FaceMark(surface, n) {
    spacing = 4;
    width = (n-1) * spacing;
    left = width / 2;
    for(i=[0:n-1])
        translate([surface-2, -left+i*spacing, 0])
        rotate([0,90,0])
        cylinder(d=3,h=50,$fn=8);
}

module ChamferCube(sizes,chamfer) {
    difference() {
        cube(sizes,center=true);
        FourChamfer(sizes, chamfer);
        rotate([0,0,90])
            FourChamfer([sizes[1], sizes[0], sizes[2]], chamfer);
        rotate([90,90,0])
            FourChamfer([sizes[2], sizes[0], sizes[1]], chamfer);
        translate([0,0,-sizes[2]/2-1])
            cylinder(r=sizes[2]/2-chamfer-2,h=sizes[2]+2);
        
        // X face mark
        translate([0,0,10]) FaceMark(sizes[0]/2, 1);
        
        // Y face mark
        translate([0,0,10]) rotate([0,0,90]) FaceMark(sizes[1]/2,2);
    }
}

translate([0,0,25]) ChamferCube([50,50,50],5);