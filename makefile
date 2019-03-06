docs: apertium-platform-doc/index.scrbl apertium-platform-doc/introduction.scrbl
	cd apertium-platform-doc; raco pkg install; cd .. ; raco setup -p apertium-platform-doc; cp -r apertium-platform-doc/doc/index/*.html docs/index/;
