SRCDIR = src
BLDDIR = public_html
# Path to public server (can be any path that rsync understands).
PUBDIR = vanderkroef:

# Toolbox
COPY = cp
CSSMINI = yuicompressor
LATEX = pdflatex
DOT = dot
LESS = lessc
EMACS = emacs -q --no-site-file
RSYNC = rsync -vaz
RM = rm
RMDIR = rmdir

# List of output files.
IMAGES = $(BLDDIR)/images \
	$(BLDDIR)/images/blueprint.png \
	$(BLDDIR)/images/menu.png \
	$(BLDDIR)/images/knot1.png \
	$(BLDDIR)/images/knot2.png \
	$(BLDDIR)/images/equations1.png \
	$(BLDDIR)/images/icons \
	$(BLDDIR)/images/icons/email.png \
	$(BLDDIR)/images/icons/feed.png \
	$(BLDDIR)/images/icons/pdf.png \
	$(BLDDIR)/images/calc1.png \
	$(BLDDIR)/images/calc2.png \
	$(BLDDIR)/images/calc3.png

CSS = $(BLDDIR)/css \
	$(BLDDIR)/css/style.css \
	$(BLDDIR)/css/screen.css \
	$(BLDDIR)/css/print.css \
	$(BLDDIR)/css/ie.css

FILES = $(BLDDIR)/files \
	$(BLDDIR)/files/curiculum_vitae.pdf \
	$(BLDDIR)/files/interpreter.tar.bz2 \
	$(BLDDIR)/files/celticknots.jar \
	$(BLDDIR)/files/equations.jar \
	$(BLDDIR)/files/pub_bram_vanderkroef_net.gpg 

ORGFILES = $(BLDDIR)/about.html \
	$(BLDDIR)/celticknots.html \
	$(BLDDIR)/equations.html \
	$(BLDDIR)/index.html \
	$(BLDDIR)/interpreter.html \
	$(BLDDIR)/projects.html

OTHER = $(BLDDIR)/robot.txt \
	$(BLDDIR)/favicon.ico

all : build

build : $(BLDDIR) $(IMAGES) $(GRAPHS) $(CSS) $(FILES) $(ORGFILES) $(OTHER)

# Create output directories.
$(BLDDIR) :
	mkdir $(BLDDIR)

$(BLDDIR)/images :
	mkdir $(BLDDIR)/images

$(BLDDIR)/images/icons :
	mkdir $(BLDDIR)/images/icons

$(BLDDIR)/css :
	mkdir $(BLDDIR)/css

$(BLDDIR)/files :
	mkdir $(BLDDIR)/files

# Compile org-files to html
$(BLDDIR)/%.html : $(SRCDIR)/%.org
	$(EMACS) -batch -l build.el $<

# Compile css files
$(BLDDIR)/css/%.css : $(SRCDIR)/css/%.less
	$(LESS) $< -o $@

# Minify css files.
$(BLDDIR)/css/%.css : $(SRCDIR)/css/%.css 
	$(CSSMINI) $< -o $@

# Compile CV pdf from latex source.
$(BLDDIR)/files/curiculum_vitae.pdf : $(SRCDIR)/cv/curiculum_vitae.tex
	cd $(SRCDIR)/cv; \
	$(LATEX) --output-directory ../../$(BLDDIR)/files curiculum_vitae.tex

# Copy images
$(BLDDIR)/images/% : $(SRCDIR)/images/%
	$(COPY) $<  $@

# Compile graphs with Graphviz
$(BLDDIR)/images/%.png : $(SRCDIR)/graphs/%.dot
	$(DOT) -Tpng $<  -o $@

# Copy files
$(BLDDIR)/files/% : $(SRCDIR)/files/% 
	$(COPY) $< $@

# Copy robot.txt file.
$(BLDDIR)/robot.txt : $(SRCDIR)/robot.txt
	$(COPY) $< $@

# Copy favicon.ico
$(BLDDIR)/favicon.ico : $(SRCDIR)/favicon.ico
	$(COPY) $< $@

# Cleanup build dir
clean :
	$(RM) $(BLDDIR)/images/icons/*
	$(RMDIR) $(BLDDIR)/images/icons
	$(RM) $(BLDDIR)/images/*
	$(RMDIR) $(BLDDIR)/images
	$(RM) $(BLDDIR)/css/*
	$(RMDIR) $(BLDDIR)/css
	$(RM) $(BLDDIR)/files/*
	$(RMDIR) $(BLDDIR)/files
	$(RM) $(BLDDIR)/*
	$(RMDIR) $(BLDDIR)

# publish build dir to server
publish : build
	$(RSYNC) $(BLDDIR)/ $(PUBDIR)