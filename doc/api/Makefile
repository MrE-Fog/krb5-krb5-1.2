.SUFFIXES: .tex .dvi .ps

SHELL=/bin/sh

STYLES=changebar.sty fixunder.sty functions.sty
LIBTEX= library.tex intro.tex tables.tex errors.tex krb5.tex ccache.tex \
	rcache.tex keytab.tex libos.tex free.tex

DESTEX= libdes.tex

all: library.ps libdes.ps


libdes.dvi: $(DESTEX) $(STYLES)

library.ps: library.dvi

clean:
	rm -f *.toc *.log *.idx *.ind *.aux lib1.stamp

really-clean: clean
	rm -f *.dvi *.ps


library.dvi:  lib1.stamp $(LIBTEX) $(STYLES)
	latex library

lib1.stamp: $(LIBTEX) $(STYLES)
	touch library.ind
	latex library
	texindex library.idx
	date > lib1.stamp

.tex.dvi:
	latex $*


.dvi.ps:
	dvips $*.dvi -o

