/* p = linear distance in Z */
module spring_sphere(r, wr, p, pitch_per_turn) {
  rotate([0,0,360/pitch_per_turn*p])
    translate([r,0,p]) sphere(r=wr);
}

/* l = length in Z */
/* TODO flattened turns at end */
module spring(r, wr, l, pitch_per_turn) {
  assign(delta=pitch_per_turn/12) {
    for(i=[0:delta:l]) {
      hull() {
        spring_sphere(r, wr, i, pitch_per_turn);  
        spring_sphere(r, wr, i+delta, pitch_per_turn);  
      }
    }
  }
}
