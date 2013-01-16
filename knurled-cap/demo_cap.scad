include <cap.scad>;

// Note that I get a very strange behavior with F5 mode, a fixed polygon covers
// half my screen and some of the tee part is missing.  When rendering in F6
// mode, everying behaves.
union() {
  Knob($fn=100);
  translate([20,0,0])
    Knob(knobType=1, $fn=100);
}

// vim: ft=c sw=2 sts=2 ts=2 et
