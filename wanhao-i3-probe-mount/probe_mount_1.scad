// enlarged to account for shrink
g3mm = 3.45;
g3mmnut = 5.85;
g2mm = 2.0;
gNutChamfer = 0.5;

module NutTrap(x,h=100) {
    cylinder(d=x/0.866,h=h,$fn=6);
    translate([0,0,-0.01])
        cylinder(d1=(x+gNutChamfer)/0.866,d2=x/0.866,h=gNutChamfer,$fn=6);
}

module NutTrapSupport(d,h,cylinder_wall_offset=0.1) {
    cylinder(d=d+cylinder_wall_offset*2,h=h,$fn=16);
}

module RoundedCube(dims,r=10) {
    hull()
        for(x_scale=[1,-1])
        for(y_scale=[1,-1])
        scale([x_scale,y_scale,1])
        translate([dims[0]/2-r,dims[1]/2-r,0])
        cylinder(r=r,h=dims[2]);
}

module ChamferHole(r,h=100,c=0.5,top_c=0) {
    cylinder(r=r,h=h);
    translate([0,0,-0.01])
        cylinder(r1=r+c,r2=r,h=c);
    if(top_c != 0 )
        translate([0,0,h-c+0.01])
        cylinder(r1=r,r2=r+c,h=top_c);
}


module Main() {
    difference() {
        union() {
            translate([10,-3,0]) RoundedCube([75,20,7],3,$fn=32);
            translate([37,-3,7]) ChamferHole(8,6,$fn=64);
        }
        translate([0,0,5]) RoundedCube([52,20,7],2,$fn=32);
        for(x=[-20,20])
            translate([x,0,0]) {
                NutTrap(g3mmnut, 3);
                translate([0,0,5.01]) scale([1,1,-1]) ChamferHole(g3mm/2,2,$fn=32);
            }
        translate([37,-3,0]) ChamferHole(6.1,7+6,top_c=0.5,$fn=32);
    }
    for(x=[-20,20])
        translate([x,0,0]) NutTrapSupport(g3mm,3);
}

Main();
