"""
Test of surface quality vs step down and feedrate.

Defaults are for HDPE.  Start/end gcode are for Carvey.

TODO: Remove reliance on print, output to a file
TODO: More configurability (maybe even engrave legend)
"""

BEGIN = """\
$h
G90
G21
G28
G21 G38.2 Z-71 F80
G10 L20 P1 X16 Y-11 Z12.7
G54
G0 Z20
G0 X20 Y20
M3 S12000
"""

END = """\
G90
G21
G53 G0 Z-1
G54
G30
M5
G4 P0.1
"""

box_x = 20
box_y = 15
box_z = 5
stepover = 2
box_space = 5
clamp_offset = 14

def frange(a, b, n=1.0):
    """Like range() but supports floats."""
    while a < b:
        yield a
        a += n

def print_box(a, b):
    """Pocket operation.  Does not do corner cleanup.
    
    a and b are lower-left position, and it uses the globals box_* to know how
    big the box should be.

    TODO: Cutter size compensation
    TODO: Offset inner part vs perimeter
    TODO: Either Z lift or avoid diagonal.
    TODO: Climb vs conventional
    """
    # middle first, then perim
    t = 1
    m = 0
    while t < box_y:
        if m:
            print "g1 x%f y%f" % (a, b+t)
            print "g1 x%f" % (a + box_x,)
        else:
            print "g1 x%f y%f" % (a + box_x, b+t)
            print "g1 x%f" % (a,)
        m = 1 - m
        t += stepover

    for c in ((0, 0), (box_x, 0), (box_x, box_y), (0, box_y)):
        print "g1 x%f y%f" % (a + c[0], b + c[1])

def main():
    print BEGIN
    for x_idx, feedrate in enumerate((250, 500, 750, 1000, 1250, 1500)):
        for y_idx, depth in enumerate((2.0, 1.0, 0.5, 0.2)):
            x = ((box_x + box_space) * x_idx + clamp_offset)
            y = ((box_y + box_space) * y_idx + clamp_offset)
            print "g0 x%fy%f" % (x, y)
            print "g0 z1"
            print "g1 f%d" % (feedrate,)
            for z in frange(depth, box_z, depth):
                print "g1 z%f" % (-z,)
                print_box(x, y)
            print "g0 z1"
    print END

if __name__ == '__main__':
    main()
