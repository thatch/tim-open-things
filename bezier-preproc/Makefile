%.inc.scad: %.inc
	./bezcompiler $<

%.stl: %.scad %.inc.scad
	openscad -o $@ $<

.PRECIOUS: %.inc.scad

.PHONY: examples
examples: examples/fifthorder.stl examples/bez.stl examples/cubicspline.stl
