.PHONY: all
all: files/cube-ascii.stl files/demo-ascii.stl files/ramp-ascii.stl \
	files/cube-binary.stl files/demo-binary.stl files/ramp-binary.stl

.PHONY: test

test:
	nosetests

# Discard stderr because it spews autorelease warnings
files/%-ascii.stl: files/%.scad
	openscad -o $@ $< 2> /dev/null

files/%-binary.stl: files/%-ascii.stl
	convertSTL.rb $< $@
