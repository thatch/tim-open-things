gInnerGuide = 19;  // distance from top of hotend hole to bottom of bearings
gMountRad = 17/2;  // normally 16 for J-Head
gBoltSpacing = 25;  // each from center

gExtruderInset = 11;  // Bottom of extruder to top of hotend hole
gHotendInset = 4.5;  // Size of J-Head above lasercut part
gHotendGuide = 6;  // Top of J-Head to top of PTFE liner (where hollow setscrew is)

gMountsThick = 6;
gMountsWide = 10;
gHalfWidth = gMountsWide / 2;

// For McMaster 51055K972 (1/4" NPTF)
// slightly less than the screw thread on coupler
gScrewableInnerRad = 6.5+0.1;
// outer-inner=wall
gScrewableOuterRad = gScrewableInnerRad + 2.1;

gInnerTubeRadClearance = 2; // If using a 2-part liner, size of hole to let inner through

// TODO single layer bridging at bottom of gap
// TODO optional trap nuts on hotend side
// TODO tighten up mounting holes (they're loose on M4)
// TODO extend depth of screwable part (seems to bottom out about 1mm shy)

module PushFitting(screwDepth=14, screwRad=6.75, hexTall=6.3, hexShort=17.18/2, roundTall=3.3, roundRad=16.64/2,
    secondRad=14.5/2, secondTall=2, thirdRad=10/2, thirdTall=1.5) {
  difference() {
    union() {
      cylinder(r=hexShort/cos(30), h=hexTall, $fn=6);
      cylinder(r=roundRad, roundTall+hexTall, $fn=100);
      cylinder(r=secondRad, roundTall+hexTall+secondTall);
      cylinder(r=thirdRad, roundTall+hexTall+secondTall+thirdTall);
      translate([0,0,-screwDepth])
        cylinder(r=screwRad, h=screwDepth+1, $fn=100);
    }
    translate([0,0,-50]) cylinder(r=6.3/2, h=100);
  }
}

module CenteredRoundedCube(xyz, r=3) {
  hull() {
    for(x_scale=[-1,1])
      for(y_scale=[-1,1])
        translate([xyz[0]/2*x_scale, xyz[1]/2*y_scale, 0])
          cylinder(r=r, h=xyz[2]);
  }
}

module ExtruderMount(outerRad=false, zOffset=0) {
  difference() {
    union() {
      CenteredRoundedCube([gBoltSpacing*2+gHalfWidth*2, gMountsWide, gMountsThick], $fn=25);
      cylinder(r=gScrewableOuterRad, h=17+zOffset); // 1mm more than usual
      if(zOffset > 0) {
        cylinder(r=outerRad, h=zOffset);
        translate([0,0,zOffset])
          cylinder(r1=outerRad, r2=gScrewableOuterRad, h=outerRad-gScrewableOuterRad);
      }
    }
    translate([0,0,zOffset]) {
      translate([0,0,2]) cylinder(r=gScrewableInnerRad, h=15.1);
      translate([0,0,-50]) cylinder(r=gInnerTubeRadClearance, h=100, $fn=12);
    }
    for(x_scale=[-1,1])
      translate([gBoltSpacing*x_scale, 0, -1])
        cylinder(r=5/2, h=100);
  }
}

module HotendMount() {
  difference() {
    ExtruderMount(outerRad=gMountRad+4, zOffset=gHotendInset+2);
    translate([0,0,-1]) cylinder(r=gMountRad, h=gHotendInset+1, $fn=100);
  }
}

ExtruderMount();
translate([0,30,0]) HotendMount();

