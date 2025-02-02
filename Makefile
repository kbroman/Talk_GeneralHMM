STEM = generic_hmm

FIGS = Figs/hs.pdf \
	   Figs/ri8.pdf \
	   Figs/genome_reconstr.pdf \
	   Figs/qtl_scan.png \
	   Figs/do_genome.pdf \
	   Figs/hmm.pdf \
	   Figs/founder_pop.pdf \
	   Figs/cc_xchr_reconstr.pdf \
	   Figs/do_qtl.pdf \
	   Figs/ri8X.pdf

R_OPTS=--no-save --no-restore --no-init-file --no-site-file

all: docs/$(STEM).pdf docs/$(STEM)_notes.pdf

docs/%.pdf: %.pdf
	cp $^ $@

$(STEM).pdf: $(STEM).tex header.tex $(FIGS)
	xelatex $^

Figs/%.pdf: R/%.R
	cd R;R CMD BATCH $(R_OPTS) $(<F)

Figs/%.png: R/%.R
	cd R;R CMD BATCH $(R_OPTS) $(<F)

$(STEM)_notes.pdf: $(STEM)_notes.tex header.tex $(FIGS)
	xelatex $<
	pdfnup $@ --nup 1x2 --no-landscape --paper letterpaper --frame true --scale 0.9
	mv $(STEM)_notes-nup.pdf $@

$(STEM)_notes.tex: $(STEM).tex Ruby/createVersionWithNotes.rb
	Ruby/createVersionWithNotes.rb $< $@

clean:
	rm *.aux *.log *.nav *.out *.snm *.toc *.vrb
