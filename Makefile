# $Id: Makefile,v 1.1 2005-04-16 21:43:45 mitch Exp $

VERSION=$(shell grep \$Id: Makefile,v 1.1 2005-04-16 21:43:45 mitch Exp $//')
DISTDIR=renice-$(VERSION)
DISTFILE=$(DISTDIR).tar.gz

BINARY=renice
CONFIG=renice.conf
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
