GENERATED_FILES = \
	d3.js \
	d3.min.js \
	component.json \
	package.js

WORMLY_D3_FILES = src/start.js \
	src/compat/date.js \
	src/compat/style.js \
	src/core/array.js \
	src/core/class.js \
	src/core/document.js \
	src/core/functor.js \
	src/core/identity.js \
	src/core/noop.js \
	src/core/ns.js \
	src/core/rebind.js \
	src/core/source.js \
	src/core/subclass.js \
	src/core/target.js \
	src/core/true.js \
	src/core/vendor.js \
	src/event/mouse.js \
	src/event/touch.js \
	src/event/touches.js \
	src/layout/stack.js \
	src/svg/area.js \
	src/svg/axis.js \
	src/svg/line.js \
	src/time/format.js \
	src/end.js

all: $(GENERATED_FILES)

.PHONY: clean all test publish

test:
	@npm test

src/start.js: package.json bin/start
	bin/start > $@

d3.zip: LICENSE d3.js d3.min.js
	zip $@ $^

d3.js: $(shell node_modules/.bin/smash --ignore-missing --list src/d3.js) package.json
	@rm -f $@
	node_modules/.bin/smash src/d3.js | node_modules/.bin/uglifyjs - -b indent-level=2 -o $@
	@chmod a-w $@

d3-wormly.js: $(WORMLY_D3_FILES)
	@rm -f $@
	node_modules/.bin/smash --ignore-missing $(WORMLY_D3_FILES) | node_modules/.bin/uglifyjs - -b indent-level=2 -o $@
	@chmod a-w $@

d3.min.js: d3.js bin/uglify
	@rm -f $@
	bin/uglify $< > $@

%.json: bin/% package.json
	@rm -f $@
	bin/$* > $@
	@chmod a-w $@

package.js: bin/meteor package.json
	@rm -f $@
	bin/meteor > package.js
	@chmod a-w $@

publish:
	npm publish
	meteor publish && rm -- .versions

clean:
	rm -f -- $(GENERATED_FILES)

# No change.
