EXAMPLE_NAMES = bez fifthorder cubicspline roundedcorners
EXAMPLE_STLS = $(patsubst %,examples/%.stl,$(EXAMPLE_NAMES))

%.inc.scad: %.inc
	./bezcompiler $<

%.stl: %.scad %.inc.scad
	openscad -o $@ $<

.PRECIOUS: %.inc.scad

.PHONY: examples
examples: $(EXAMPLE_STLS)

.PHONY: clean
clean:
	rm -f examples/*.inc.scad examples/*.stl
