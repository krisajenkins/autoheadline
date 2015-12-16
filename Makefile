all: dist dist/elm.js dist/favicon.ico dist/loading_wheel.gif dist/interop.js dist/index.html dist/vendor dist/style.css dist/bootstrap.min.css

dist:
	@mkdir $@

dist/%.css: static/%.css dist
	cp $< $@

dist/%.css: static/%.less dist
	lessc $< > $@

dist/%.less: static/%.less dist
	cp $< $@

dist/%.html: static/%.html dist
	cp $< $@

dist/%.png: static/%.png dist
	cp $< $@

dist/%.gif: static/%.gif dist
	cp $< $@

dist/%.ico: static/%.ico dist
	cp $< $@

dist/%.js: static/%.js dist
	cp $< $@

dist/elm.js: src/* dist
	elm-make --warn src/Main.elm --output=$@

elm.js: src/* elm-package.json
	elm-make src/Main.elm

test.html: test/* src/*
	elm-make test/Tests.elm --output=$@

dist/vendor:
	rsync -qrvcz --delete vendor/ dist/vendor/

dist/style:
	rsync -qrvcz --delete style/ dist/style/
