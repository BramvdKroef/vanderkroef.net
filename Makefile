SRCDIR = src

PREFIX=/srv/http
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

CONTENT = $(SRCDIR)/about.html \
	$(SRCDIR)/celticknots.html \
	$(SRCDIR)/clessc.html \
	$(SRCDIR)/equations.html \
	$(SRCDIR)/geneticalgorithm.html \
	$(SRCDIR)/index.html \
	$(SRCDIR)/interpreter.html \
	$(SRCDIR)/projects.html

IMAGES = $(SRCDIR)/graphs/calc1.svg \
	$(SRCDIR)/graphs/calc2.svg \
	$(SRCDIR)/graphs/calc3.svg \
	$(SRCDIR)/images/menu.png \
	$(SRCDIR)/images/blueprint.png \
	$(SRCDIR)/images/knot1.png \
	$(SRCDIR)/images/knot2.png \
	$(SRCDIR)/images/equations1.png \
	$(SRCDIR)/images/map.svg \
	$(SRCDIR)/images/icons/email.png \
	$(SRCDIR)/images/icons/feed.png \
	$(SRCDIR)/images/icons/pdf.png 

CSS = 	$(SRCDIR)/css/style.css \
	$(SRCDIR)/css/screen.css \
	$(SRCDIR)/css/print.css \
	$(SRCDIR)/css/ie.css

FILES = $(SRCDIR)/cv/resume.pdf \
	$(SRCDIR)/files/interpreter.tar.bz2 \
	$(SRCDIR)/files/celticknots.jar \
	$(SRCDIR)/files/equations.jar \
	$(SRCDIR)/files/pub_bram_vanderkroef_net.gpg 

OTHER = $(SRCDIR)/robot.txt \
	$(SRCDIR)/images/favicon.ico

BUILD_FILES = $(CONTENT) \
	$(SRCDIR)/graphs/calc1.svg \
	$(SRCDIR)/graphs/calc2.svg \
	$(SRCDIR)/graphs/calc3.svg \
	$(SRCDIR)/images/menu.png \
	$(SRCDIR)/css/style.css \
	$(SRCDIR)/cv/resume.pdf \
	$(SRCDIR)/images/favicon.ico

PUBLISHED_FILES = $(CONTENT) $(IMAGES) $(CSS) $(FILES) $(OTHER)

.PHONY: all build install clean publish

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
install : $(PUBLISHED_FILES)
	install -d $(DESTDIR)$(PREFIX)/vanderkroef.net/images
	install -d $(DESTDIR)$(PREFIX)/vanderkroef.net/css
	install -d $(DESTDIR)$(PREFIX)/vanderkroef.net/files
	install $(CONTENT) $(DESTDIR)$(PREFIX)/vanderkroef.net/
	install $(IMAGES)  $(DESTDIR)$(PREFIX)/vanderkroef.net/images/
	install $(CSS)     $(DESTDIR)$(PREFIX)/vanderkroef.net/css/
	install $(FILES)   $(DESTDIR)$(PREFIX)/vanderkroef.net/files/
	install $(OTHER)   $(DESTDIR)$(PREFIX)/vanderkroef.net/

uninstall :
	$(DESTDIR)$(PREFIX)/vanderkroef.net/*.html
	$(DESTDIR)$(PREFIX)/vanderkroef.net/images/*
	$(DESTDIR)$(PREFIX)/vanderkroef.net/css/*.css
	$(DESTDIR)$(PREFIX)/vanderkroef.net/files/*
	$(DESTDIR)$(PREFIX)/vanderkroef.net/{robots.txt,favicon.ico}
	rmdir $(DESTDIR)$(PREFIX)/vanderkroef.net/images/
	rmdir $(DESTDIR)$(PREFIX)/vanderkroef.net/css/
	rmdir $(DESTDIR)$(PREFIX)/vanderkroef.net/files/
	rmdir $(DESTDIR)$(PREFIX)/vanderkroef.net/

# Cleanup build dir
clean :
	rm $(BUILD_FILES)
	latexmk -CA	

# publish build dir to server
#publish : build
#	$(RSYNC) $(BLDDIR)/ $(PUBDIR)
