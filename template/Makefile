TYPST ?= typst
BOOK_SOURCE := main.typ
BOOK_PDF := build/book.pdf
SOURCES := $(shell find . -type f \( -name '*.typ' -o -name '*.bib' \))
VERSION ?=
PROJECTS ?= .

.PHONY: all build update-package clean

all: build

build: $(BOOK_PDF)

$(BOOK_PDF): $(SOURCES)
	mkdir -p build
	$(TYPST) compile --root . $(BOOK_SOURCE) $(BOOK_PDF)

update-package:
	@test -n "$(VERSION)" || { echo 'Usage: make update-package VERSION=0.2.0'; exit 2; }
	python3 scripts/update-package-version.py "$(VERSION)" $(PROJECTS)

clean:
	rm -rf build
