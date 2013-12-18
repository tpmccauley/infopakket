.PHONY: all distclean clean gh-pages latexmk-recursive distclean-recursive clean-recursive

TEXFILES=$(wildcard *.tex)
TARGETS=$(patsubst %.tex,%.pdf,$(TEXFILES))
DIRECTORIES=$(dir $(wildcard */))

# '-recursive' rules are based on a Makefile by Santiago Gonzalez Gancedo
# https://github.com/sangonz/latex_makefile
# which was a modified version of a Makefile by Johannes Ranke,
# which was based on Makesfiles by Tadeusz Pietraszek

all: latexmk-recursive
distclean: clean distclean-recursive
clean: clean-recursive

latexmk-recursive:
	for dir in $(DIRECTORIES); do \
        if ls $$dir/*.tex &> /dev/null; then \
            cd $$dir; \
            latexmk -quiet -pdf *.tex; \
            cd ..; fi; done

distclean-recursive:
	for dir in $(DIRECTORIES); do \
        if ls $$dir/*.tex &> /dev/null; then \
            cd $$dir; \
            rm -f *.pdf; \
            cd ..; fi; done

clean-recursive:
	for dir in $(DIRECTORIES); do \
        if ls $$dir/*.tex &> /dev/null; then \
            cd $$dir; \
            rm -f *.aux *.log *.bbl *.blg *.brf *.cb *.ind *.idx *.ilg \
                  *.inx *.ps *.dvi *.toc *.out *.lot *~ *.lof *.ttt *.fff \
                  *.mp *.mpo *.1 *.synctex *.synctex.gz *.fdb_latexmk *.fls; \
            cd ..; fi; done


# Add to allow only from master branch: ifeq ($(strip $(shell git branch --list | grep \*\ master | wc -l)), 1)

gh-pages:
#ifeq ($(strip $(shell git status --porcelain | wc -l)), 0)
	git checkout gh-pages
	git rm -rf .
	git clean -dxf
	git checkout HEAD .nojekyll .gitignore
	git checkout master index.html
	git checkout master Makefile
	git checkout master $(DIRECTORIES)
	$(MAKE) all
	mkdir pdf
	mv -fv */*.pdf pdf/
	rm -rf $(DIRECTORIES)
	#git add -A
	#git commit -m "Generated gh-pages for `git log master -1 --pretty=short --abbrev-commit`"
	#git checkout master
#else
#	$(error Working tree is not clean, please commit all changes.)
#endif
