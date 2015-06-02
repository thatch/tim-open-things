/* http://www.thingiverse.com/thing:859960 */

difference() {
    union() {
        translate([-6, -4, 0]) cube([12, 20, 6]);
        translate([-4, -4, 1]) cube([8, 8, 11]);
    }
    translate([0,0,5.99]) cylinder(r=4.3, h=100, $fn=8);
    translate([0, 12, -1]) cylinder(r=2, h=100, $fn=32);
}
