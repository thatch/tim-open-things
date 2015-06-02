r=10;
h=10;
thick = 1;

difference() {
    cylinder(r=r,h=h);
    translate([0,0,-1]) cylinder(r=r-thick,h=h+2);
}
