import sys
import os

import stl

DUMP = 1
HISTOGRAM = 2

def main(argv):
    # TODO args, like show-histogram
    mode = DUMP
    if argv[0] == '--show-histogram':
        argv.pop(0)
        mode = HISTOGRAM
    filename = argv[0]
    mesh = stl.Mesh(filename)

def extract_planes(mesh):
    # TODO handle multiple 2d polys at the same Z
    planes = {}  # index: Z position
    tree = {}
    vertex_seen = set()
    # Basic algo: walk facet edges as long as they stay at the same Z
    for f in mesh.facets:
        for i1, i2 in ((0, 1), (1, 2), (2, 0)):
            j1 = min(i1, i2)
            j2 = max(i1, i2)
            tree.setdefault(j1, set()).add(j2)
            

        
        


    


if __name__ == '__main__':
    main(sys.argv[1:])
