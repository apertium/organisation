docs: $(wildcard docs-source/*)
	cd docs-source; raco pkg install; cd .. ; raco setup -p apertium-platform-doc; cp -r docs-source/doc/index/*.html docs/index/; cp -r docs-source/doc/index/*.svg docs/index/; cp -r docs-source/doc/index/*.png docs/index/
