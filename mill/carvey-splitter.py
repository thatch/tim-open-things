"""Writes out<n>.nc based on toolchanges.
"""

import sys
import re

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

def main(args):
    onum = 1
    fo = None

    for line in file(args[0], 'r'):
        if line.startswith('%') or line.startswith('('): continue

        # this one will crash against the clamp
        if line.startswith('G0X0.0000Y'): continue

        # this one causes an extra first file, and we set it anyway
        if line.startswith('G21'): continue

        if line.startswith('M6'):
            if fo:
                fo.write(END)
                fo.close()
                fo = None
            continue

        if fo is None:
            fo = file('out%d.nc' % onum, 'wb')
            onum += 1
            fo.write(BEGIN)
        fo.write(line)

    if fo:
        fo.write(END)
        fo.close()

if __name__ == '__main__':
    main(sys.argv[1:])
