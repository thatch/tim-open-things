include <cap.scad>;

// Note that I get a very strange behavior with F5 mode, a fixed polygon covers
// half my screen and some of the tee part is missing.  When rendering in F6
// mode, everying behaves.

M5_head = 8.8/2;
M5_tall = 5;
M5_pegrad = 4/2;

num_caps = 1;

union() {
  for(i=[1:num_caps]) {
    translate([i*40, 0, 0])
      Knob(outerRad=M5_head*1.65, pegRad=M5_pegrad, capRad=M5_head,
           chamfer=0.9, $fn=100);
  }
}

// vim: ft=c sw=2 sts=2 ts=2 et
