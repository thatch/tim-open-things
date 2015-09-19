import os.path
import sys
import struct
import optparse

AXES = {'x': 0, 'y': 1, 'z': 2}

class NotAscii(ValueError): pass

class Mesh(object):
    def __init__(self, filename=None):
        # TODO hide vertex_cache
        self.vertex_cache = {}
        self.vertices = []
        self.facets = []

        if filename:
            # TODO something that doesn't require rewinding
            with open(filename, 'rb') as f:
                try:
                    self.load_ascii(f)
                except NotAscii:
                    f.seek(0, 0)
                    self.load_binary(f)

    def load_ascii(self, fo):
        # TODO use a better storage system, like halfedges
        for face in parse_ascii(fo):
            t = []
            for v in face:
                idx = self.vertex_cache.get(v, None)
                if idx is None:
                    idx = len(self.vertex_cache)
                    self.vertex_cache[v] = idx
                    self.vertices.append(v)
                t.append(idx)
            # N.b. The facets list only contains indices
            self.facets.append(tuple(t))

    def load_binary(fo):
        # TODO
        raise NotImplementedError

    def write_stl(self, filename):
        with open(filename, 'w') as fo:
            fo.write('solid foo\n')
            for face in self.facets:
                # TODO output normal
                fo.write('facet normal 0 0 -1\n')
                for idx in face:
                    fo.write('vertex %f %f %f\n' % self.vertices[idx])
                fo.write('endfacet\n')
            fo.write('endsolid foo\n')

    def scale(self, vector=(1,1,1)):
        """Scale the mesh, in place."""
        if len(vector) != 3:
            raise ValueError("Invalid 3-vector: %r" % (vector,))
        new_vertices = []
        for v in self.vertices:
            new_vertices.append(tuple(a * b for a, b in zip(vector, v)))
        self.vertices = new_vertices
        self._fix_vertex_cache()

    def stretch(self, dimension, stretch_start, stretch_end, delta):
        """Stretch the object in the specified dimension.

        All vertices with dimension coord > stretch_end will be moved by
        delta; coord < stretch_start will be left alone, and those in
        between will be linearly interpolated.
        """

        if isinstance(dimension, int):
            d = dimension
        else:
            d = AXES[dimension]

        new_vertices = []
        for v in self.vertices:
            if v[d] > stretch_end:
                new_v = list(v)
                new_v[d] += delta
                new_vertices.append(tuple(new_v))
            elif v[d] > stretch_start:
                new_v = list(v)
                new_v[d] = lerp2(
                    stretch_start, stretch_end, stretch_start, stretch_end +
                    delta, v[d])
                new_vertices.append(tuple(new_v))
            else:
                new_vertices.append(v)

        self.vertices = new_vertices
        self._fix_vertex_cache()
   
    def _fix_vertex_cache(self): 
        self.vertex_cache = dict((v, k) for k, v in enumerate(self.vertices))

    # TODO is_manifold
    # TODO split, merge
    # TODO put_on_platform
    # TODO bounding_box(es)

    # TODO tests for these two methods
    def bounding_box(self):
        mins = [None] * 3
        maxes = [None] * 3
        for v in self.vertex_cache.values():
            mins = min_elementwise(mins, v)
            maxes = max_elementwise(maxes, v)
        return (mins, maxes)

    def _reachability(self):
        """Returns sets of facet indices."""
        seen = set()
        sets = []
        for face in self.facets:
            for i in face:
                if i in seen:
                    pass
            

def min_elementwise(a, b):
    v = []
    for ai, bi in zip(a, b):
        if ai is None:
            v.append(bi)
        elif bi is None:
            v.append(ai)
        else:
            v.append(min(ai, bi))
    return v
 

def max_elementwise(a, b):
    v = []
    for ai, bi in zip(a, b):
        if ai is None:
            v.append(bi)
        elif bi is None:
            v.append(ai)
        else:
            v.append(max(ai, bi))

    return v

def lerp(a, b, x):
    if x < 0:
        x = 0
    elif x > 1:
        x = 1
    return a + (b-a) * x

def lerp2(a, b, c, d, x):
    """Interpolate x E a->b onto c->d."""
    return lerp(c, d, (x-a) / float(b-a))

def parse_ascii(fo):
    """Parses facets out of the ascii file opened as fo.  Yields them."""
    # TODO check normals
    # TODO skip 0-size faces before parsing float

    solid = fo.readline()
    if not solid.lower().startswith('solid'):
        raise NotAscii()

    vertices = []
    for line in fo:
        line = line.strip()
        if line == 'endfacet':
            yield tuple(vertices)
        elif line.startswith('facet'):
            del vertices[:]
        elif line.startswith('vertex'):
            vertices.append(tuple(map(float, line.split()[1:])))

def parse_xyz_floats(text):
    components = text.split()
    if len(components) not in (1, 3):
        raise ValueError('Expected 1 or 3 components, got %r' % (text,))

    if len(components) == 1:
        return (float(components[0]),) * 3
    else:
        return map(float, components)
   

def parse_floats_with_axis(text):
    components = text.split()
    axis = None
    rest = []
    for c in components:
        if c.lower() in AXES:
            if axis is not None:
                raise ValueError('Axis already set once in %r' % (text,))
            axis = AXES[c.lower()]
        else:
            rest.append(float(c))

    return axis, rest

    
def main(argv=None):
    if argv is None:
        argv = sys.argv[1:]

    parser = optparse.OptionParser()
    parser.add_option('-o', '--output',
                      help='Save output to FILE', metavar='FILE')
    parser.add_option('--scale', help='''\
Scale by either one float or 3 of them''')
    parser.add_option('--stretch', help='''\
Stretch using params of the form "X 1 2 3" where X is dimension, 1 is lower
boundary, 2 is upper boundary, and 3 is the amount to add''')

    (options, args) = parser.parse_args(argv)
    if len(args) != 1:
        raise Exception('Expected exactly one positional argument, the input filename')
    m = Mesh(args[0])

    # TODO document order of operations.
    if options.scale:
        x = parse_xyz_floats(options.scale)
        m.scale(x)
    if options.stretch:
        d, x = parse_floats_with_axis(options.stretch)
        m.stretch(d, *x)
    if options.output:
        m.write_stl(options.output)
    else:
        print "Not writing output, specify --output"

if __name__ == '__main__':
    main()
