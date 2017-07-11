SRCDIR = src
BLDDIR = public_html
# Path to public server (can be any path that rsync understands).
PUBDIR = vanderkroef:

# Toolbox
COPY = cp
CSSMINI = yuicompressor
LATEX = latexmk -xelatex -use-make -cd -f
DOT = dot
LESS = lessc
RSYNC = rsync -vaz
CONVERT = convert

SITE_DATA=$(SRCDIR)/site.json
CONTENT_TEMPLATE=$(SRCDIR)/page-template.html 

# Icons for menu items
# source: http://freebiesbooth.com/hand-drawn-web-icons
# mirror: http://www.iconfinder.com/search/?q=iconset%3AHand_Drawn_Web_Icon_Set
MENUICONS = $(SRCDIR)/images/home.png \
	$(SRCDIR)/images/projects.png \
	$(SRCDIR)/images/about.png \
	$(SRCDIR)/images/resume2.png 

# List of output files.
IMAGES = $(SRCDIR)/images/blueprint.png \
	$(SRCDIR)/images/menu.png \
	$(SRCDIR)/images/knot1.png \
	$(SRCDIR)/images/knot2.png \
	$(SRCDIR)/images/equations1.png \
	$(SRCDIR)/graphs/calc1.svg \
	$(SRCDIR)/graphs/calc2.svg \
	$(SRCDIR)/graphs/calc3.svg \
	$(SRCDIR)/images/map.svg

ICONS =	$(SRCDIR)/images/icons/email.png \
	$(SRCDIR)/images/icons/feed.png \
	$(SRCDIR)/images/icons/pdf.png

CSS =	$(SRCDIR)/css/style.css \
	$(SRCDIR)/css/screen.css \
	$(SRCDIR)/css/print.css \
	$(SRCDIR)/css/ie.css

FILES = $(SRCDIR)/cv/resume.pdf \
	$(SRCDIR)/files/interpreter.tar.bz2 \
	$(SRCDIR)/files/celticknots.jar \
	$(SRCDIR)/files/equations.jar \
	$(SRCDIR)/files/pub_bram_vanderkroef_net.gpg 

CONTENT = $(SRCDIR)/about.html \
	$(SRCDIR)/celticknots.html \
	$(SRCDIR)/equations.html \
	$(SRCDIR)/index.html \
	$(SRCDIR)/interpreter.html \
	$(SRCDIR)/projects.html \
	$(SRCDIR)/clessc.html \
	$(SRCDIR)/geneticalgorithm.html


OTHER = $(SRCDIR)/robot.txt \
	$(SRCDIR)/images/favicon.ico

PUBLISHED_FILES = $(IMAGES) $(CSS) $(FILES) $(CONTENT) $(OTHER)

all : build

build : $(PUBLISHED_FILES)

%.yml : %.md $(SITE_DATA)
	cat $(SITE_DATA) | jq \
--arg title "$(shell grep '^# ' $< | cut -c 2-)" \
--arg body "$(shell cmark $< | sed 's|\"|\\"|g')" \
'.title = $$title|.body= $$body' > $@

#'

# Compile org-files to html
%.html : %.yml $(CONTENT_TEMPLATE)
	mustache $< $(CONTENT_TEMPLATE) > $@

# Compile css files
%.css : %.less
	$(LESS) $< -o $@

# Compile CV pdf from latex source.
%.pdf : %.tex $(SRCDIR)/cv/awesome-cv.cls
	cd $(dir $<); \
	$(LATEX) $(notdir $<)

# Build menu.png from icon files.
$(SRCDIR)/images/menu.png : $(MENUICONS)
	$(CONVERT) $(MENUICONS) -scale 64x64 -append $@

# Compile graphs with Graphviz
%.svg : %.dot
	$(DOT) -Tsvg $<  -o $@

# Copy favicon.ico
%.ico : %.png
	$(CONVERT) $< -scale 32x32 $@

# Create output directories.
install :
	install -d $(prefix)/images
	install -d $(prefix)/images/icons
	install -d $(prefix)/css
	install -d $(prefix)/files
	install $(CONTENT) $(prefix)
	install $(IMAGES) $(prefix)/images/
	install $(FILES) $(prefix)/files/
	install $(OTHER) $(prefix)

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
