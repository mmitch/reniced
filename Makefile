# $Id: Makefile,v 1.4 2005-04-16 21:48:35 mitch Exp $

VERSION=$(shell grep \$$Id: reniced \
	| head -n 1 | sed -e 's/^.*,v //' -e 's/ .*$$//')

DISTDIR=reniced-$(VERSION)
DISTFILE=$(DISTDIR).tar.gz

BINARY=reniced
CONFIG=reniced.conf
MANPAGE=

FILES=$(BINARY) $(CONFIG) $(MANPAGE)

all:	dist

clean:
	-rm -f *~

dist:	clean
	-rm -rf $(DISTDIR)
	mkdir $(DISTDIR)
	cp $(FILES) $(DISTDIR)
	tar -c $(DISTDIR) -zvf $(DISTFILE)
	rm -rf $(DISTDIR)
