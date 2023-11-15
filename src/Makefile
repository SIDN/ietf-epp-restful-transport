MMARK :=mmark
TXT := $(patsubst %.md,%.txt,$(wildcard *.md))
XML := $(patsubst %.md,%.xml,$(wildcard *.md))
HTML := $(patsubst %.md,%.html,$(wildcard *.md))
PDF := $(patsubst %.md,%.pdf,$(wildcard *.md))



txt: $(TXT)

%.txt: %.xml
	xml2rfc --text --v3 ../docs/$< -p ../rfc

html: $(HTML)

%.html: %.xml
	xml2rfc --html --v3 ../docs/$< -p ../rfc

xml: $(XML)

%.xml: %.md
	$(MMARK) $< > ../docs/$(basename $<).xml

pdf: $(PDF)

%.pdf: %.xml
	xml2rfc --pdf --v3 ../docs/$< -p ../rfc

.PHONY: clean
clean:
	rm -f *.txt *.xml

all: txt html pdf 