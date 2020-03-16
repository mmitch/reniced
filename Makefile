PKGNAME=reniced
VERSION=$(shell grep 'reniced [0-9]' reniced \
	| head -n 1 | sed -e 's/^\s*reniced\s*//' -e 's/\s*$$//')

DISTDIR=$(PKGNAME)-$(VERSION)
DISTFILE=$(DISTDIR).tar.gz

BINARIES=reniced
CONFIG=reniced.conf
DOCUMENTS=COPYRIGHT HISTORY README.md

FILES=$(BINARIES) $(CONFIG) $(DOCUMENTS)

TESTDIR=test

MANDIR=./manpages
POD2MANOPTS=--release=$(VERSION) --center=$(PKGNAME) --section=1

.PHONY: test

all:	dist README.md

clean:
	rm -f *~
	rm -f $(TESTDIR)/*~
	rm -rf $(MANDIR)

README.md: reniced
	pod2markdown reniced README.md

generate-manpages:
	rm -rf $(MANDIR)
	mkdir $(MANDIR)
	for FILE in $(BINARIES); do pod2man $(POD2MANOPTS) $$FILE $(MANDIR)/$$FILE.1; done

dist:	test clean generate-manpages
	rm -rf $(DISTDIR)
	mkdir $(DISTDIR)
	cp $(FILES) $(DISTDIR)
	cp $(MANDIR)/* $(DISTDIR)
	tar -czvf $(DISTFILE) $(DISTDIR)
	rm -rf $(DISTDIR)

test:
	cd $(TESTDIR); ./run-tests
