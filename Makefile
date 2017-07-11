SRCDIR = src
BLDDIR = public_html
# Path to public server (can be any path that rsync understands).
PUBDIR = vanderkroef:

# Toolbox
COPY = cp
CSSMINI = yuicompressor
LATEX = xelatex
DOT = dot
LESS = lessc
RSYNC = rsync -vaz
CONVERT = convert
RM = rm
RMDIR = rmdir

# Icons for menu items
# source: http://freebiesbooth.com/hand-drawn-web-icons
# mirror: http://www.iconfinder.com/search/?q=iconset%3AHand_Drawn_Web_Icon_Set
MENUICONS = $(SRCDIR)/images/home.png \
	$(SRCDIR)/images/projects.png \
	$(SRCDIR)/images/about.png \
	$(SRCDIR)/images/resume2.png 

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
	$(BLDDIR)/images/calc1.svg \
	$(BLDDIR)/images/calc2.svg \
	$(BLDDIR)/images/calc3.svg \
	$(BLDDIR)/images/map.svg 

CSS = $(BLDDIR)/css \
	$(BLDDIR)/css/style.css \
	$(BLDDIR)/css/screen.css \
	$(BLDDIR)/css/print.css \
	$(BLDDIR)/css/ie.css

FILES = $(BLDDIR)/files \
	$(BLDDIR)/files/resume.pdf \
	$(BLDDIR)/files/interpreter.tar.bz2 \
	$(BLDDIR)/files/celticknots.jar \
	$(BLDDIR)/files/equations.jar \
	$(BLDDIR)/files/pub_bram_vanderkroef_net.gpg 

CONTENT = $(BLDDIR)/about.html \
	$(BLDDIR)/celticknots.html \
	$(BLDDIR)/equations.html \
	$(BLDDIR)/index.html \
	$(BLDDIR)/interpreter.html \
	$(BLDDIR)/projects.html \
	$(BLDDIR)/clessc.html \
	$(BLDDIR)/geneticalgorithm.html

CONTENT_TEMPLATE=$(SRCDIR)/page-template.html 

OTHER = $(BLDDIR)/robot.txt \
	$(BLDDIR)/favicon.ico

PUBLISHED_FILES = $(IMAGES) $(CSS) $(FILES) $(CONTENT) $(OTHER)

all : build

build : $(BLDDIR) $(PUBLISHED_FILES)

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

$(SRCDIR)/%.yml : $(SRCDIR)/%.md $(SRCDIR)/site.json
	cat $(SRCDIR)/site.json | jq \
--arg title "$(shell grep '^# ' $< | cut -c 2-)" \
--arg body "$(shell cmark $< | sed 's|\"|\\"|g')" \
'.title = $$title|.body= $$body' > $@

#'

# Compile org-files to html
$(BLDDIR)/%.html : $(SRCDIR)/%.yml $(CONTENT_TEMPLATE)
	mustache $< $(CONTENT_TEMPLATE) > $@

# Compile css files
$(BLDDIR)/css/%.css : $(SRCDIR)/css/%.less
	$(LESS) $< -o $@

# Minify css files.
$(BLDDIR)/css/%.css : $(SRCDIR)/css/%.css 
	$(CSSMINI) $< -o $@

# Compile CV pdf from latex source.
$(BLDDIR)/files/resume.pdf : $(SRCDIR)/cv/resume.tex $(SRCDIR)/cv/awesome-cv.cls
	cd $(SRCDIR)/cv; \
	$(LATEX) --output-directory ../../$(BLDDIR)/files resume.tex

# Copy images
$(BLDDIR)/images/% : $(SRCDIR)/images/%
	$(COPY) $<  $@

# Build menu.png from icon files.
$(BLDDIR)/images/menu.png : $(MENUICONS)
	$(CONVERT) $(MENUICONS) -scale 64x64 -append $@

# Compile graphs with Graphviz
$(BLDDIR)/images/%.svg : $(SRCDIR)/graphs/%.dot
	$(DOT) -Tsvg $<  -o $@

# Copy files
$(BLDDIR)/files/% : $(SRCDIR)/files/% 
	$(COPY) $< $@

# Copy robot.txt file.
$(BLDDIR)/robot.txt : $(SRCDIR)/robot.txt
	$(COPY) $< $@

# Copy favicon.ico
$(BLDDIR)/favicon.ico : $(SRCDIR)/images/favicon.png
	$(CONVERT) $< -scale 32x32 $@

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
