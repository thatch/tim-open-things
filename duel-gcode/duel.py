# Inspired by http://www.thingiverse.com/thing:23792

import sys

# Offsets from the known zero position
EXTRUDER_OFFSET_Y = 0.0
EXTRUDER_OFFSET_X = 21.0

# Bed size, for making sure the print doesn't extend beyond
BED_X = 200
BED_Y = 200

INITIAL_LINES_TO_FIND_START_GCODE = 100

def findline(lst, a, b, needle):
    for i in range(a, b):
        if needle in lst[i]:
            return i
    raise ValueError("Needle %r not found" % (needle,))

def extract_param(line, key):
    parts = line.split()
    for p in parts:
        if p.startswith(key):
            return p[1:]
    raise ValueError('Key %r not found in line %r' % (key, line))

# This bit is so we don't have to change start.gcode
def replace_start_gcode(lines):
    bed_line = findline(lines, 0, INITIAL_LINES_TO_FIND_START_GCODE, "M109")
    head_line = findline(lines, 0, INITIAL_LINES_TO_FIND_START_GCODE, "M104")
    # Final temp
    bed_temp3 = extract_param(lines[bed_line], 'S')
    head_temp = extract_param(lines[head_line], 'S')
    # Initial temp
    bed_temp = '%g' % (float(bed_temp)-10,)
    # Heat extruder at this temp
    bed_temp2 = '%g' % (float(bed_temp)-5,)

    b = findline(lines, a, INITIAL_LINES_TO_FIND_START_GCODE, "end of start")
    start_gcode = open('start.gcode').read()
    start_gcode %= locals()
    return start_code.splitlines(), lines[b:]

def offset_gcode_line(line, dx, dy):
    # TODO comments
    parts = line.split()
    for i in range(len(parts)):
        if parts[i].startswith('X'):
            parts[i] = 'X%g' % (float(parts[i][1:]) + dx,)
        elif parts[i].startswith('Y'):
            parts[i] = 'Y%g' % (float(parts[i][1:]) + dy,)
    return ' '.join(parts)

def e_to_ab_line(line):
    parts = line.split()
    for i in range(len(parts)):
        if parts[i].startswith('E'):
            parts[i] = 'A%s B%s' % (parts[i][1:], parts[i][1:])
            break
    return ' '.join(parts)
    
def offset_movement(lines, dx, dy):
    for i in range(len(lines)):
        if lines[i].startswith('G1') or lines[i].startswith('G0'):
            lines[i] = offset_gcode_line(lines[i], dx, dy)
    return lines

def main(argv):
    # TODO arg parsing
    input_file, output_file = argv
    lines = open(input_file).read().splitlines()
    new_start, other_lines = replace_start_code(lines)
    with file(output_file, 'w') as output:
        output.write('\n'.join(new_start))
        output.write('\n')
            
        for line in other_lines:
            if line.startswith('G'):
                line = e_to_ab_line(line)
            output.write(line + '\n')

if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
