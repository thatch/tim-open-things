.PHONY: all
all: ring_ascii.stl

# Discard stderr because it spews autorelease warnings
%_ascii.stl: %.scad
	openscad -o $@ $< 2> /dev/null

