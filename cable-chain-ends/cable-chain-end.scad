// 13 wide
// 3.9 post
// 10 tall

w1 = 13;
w2 = w1 + 4;
h1 = 10;
h2 = 12;

difference() {
  translate([-w2/2,0,0]) cube([w2,20,h2]);
  translate([-w1/2,-1,-1]) cube([w1,30,h1+1]);
  translate([-50,16,8]) cube([100,2,100]);
}

for(x_scale=[1,-1]) 
    scale([x_scale,1,1]) 
translate([w1/2-0.99,4,5]) rotate([0,90,0]) cylinder(d=3.9,h=1);