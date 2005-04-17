# $Id: Makefile,v 1.5 2005-04-17 10:36:49 mitch Exp $

VERSION=$(shell grep \$$Id: reniced \
	| head -n 1 | sed -e 's/^.*,v //' -e 's/ .*$$//')

DISTDIR=reniced-$(VERSION)
DISTFILE=$(DISTDIR).tar.gz

BINARY=reniced
CONFIG=reniced.conf
DOCUMENTS=COPYRIGHT

FILES=$(BINARY) $(CONFIG) $(DOCUMENTS)

all:	dist

clean:
	-rm -f *~

dist:	clean
	-rm -rf $(DISTDIR)
	mkdir $(DISTDIR)
	cp $(FILES) $(DISTDIR)
	tar -c $(DISTDIR) -zvf $(DISTFILE)
	rm -rf $(DISTDIR)
