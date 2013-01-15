%.inc.scad: %.inc
	./bezcompiler $< 

%.stl: %.scad
	openscad -o $@ $<

.PHONY: examples
examples: examples/fifthorder.stl examples/bez.stl
