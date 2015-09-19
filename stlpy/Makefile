.PHONY: test

test:
	nosetests

# Discard stderr because it spews autorelease warnings
files/%_ascii.stl: files/%.scad
	openscad -o $@ $< 2> /dev/null

# TODO gen _binary.stl using meshlab or some other converter
