/* Note that the factory bins have draft which make them injection moldable; we
 * don't need that. */

/* The little circles that the legs fit into to keep the bins from moving around */
gLegCircleSize = 18;

/* Most of the bins have X in this orientation. */
gGridX = 40;
gGridY = 55;

/* So the bins don't fit *too* tightly together */
gTopSlop = 0.6;
// TODO I'm not sure this works, maybe because of poylgon circles?
gExtWidth = 0.45;

//gHeight=47.8; // for HF
gHeight=40.9; // for Stanley

module RoundRect(w,h,r=1) {
    hull()
    for(x_scale=[1,-1]) for(y_scale=[1,-1])
    scale([x_scale,y_scale])
    translate([(w-r)/2,(h-r)/2]) circle(r=r);
}

// TODO h for HF
// TODO locating feet, maybe a really short screw?
// TODO bottom inside rounding
module Bin(x=1,y=1,wall=gExtWidth*3) {
    linear_extrude(height=gHeight) difference() {
        RoundRect(x*gGridX-gTopSlop,y*gGridY-gTopSlop,3,$fn=32);
        RoundRect((x*gGridX)-(wall*2)-gTopSlop,(y*gGridY)-(wall*2)-gTopSlop,3-wall,$fn=32);
    }
    // Floor
    linear_extrude(height=2)
    RoundRect(x*gGridX-gTopSlop,y*gGridY-gTopSlop,3,$fn=32);
}

Bin(4,1);


