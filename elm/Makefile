SRCDIR = src
ELM_FILES = $(shell find $(SRCDIR) -type f -name '*.elm' -not -name '.\#*')
OUTFILE = build/elm.js
OUTFILE_DEBUG = build/elm-debug.js
MAINFILE = $(SRCDIR)/Main.elm

default: bundle lint test

test:
	elm test

debug: $(OUTFILE_DEBUG)

elm-stuff/.stamp: elm-package.json
	elm-package install --yes && touch elm-stuff/.stamp

js: $(OUTFILE)

$(OUTFILE): $(ELM_FILES) elm-stuff/.stamp
	elm-make --yes $(MAINFILE) --output $(OUTFILE)

$(OUTFILE_DEBUG): $(ELM_FILES) elm-stuff/.stamp
	elm-make --yes --debug $(MAINFILE) --output $(OUTFILE_DEBUG)

clean-deps:
	rm -rf elm-stuff

clean:
	rm -f $(OUTFILE) $(OUTFILE_DEBUG)
	rm -rf elm-stuff/build-artifacts

realclean: clean clean-deps

watch:
	@make js || true
	@echo "Watching for changes..."
	@fswatch $(SRCDIR)/ | grep --line-buffered -v '.\#' | while read -r changed; do date; echo "MODIFIED: $$changed"; make js || true; done

# Install live-server with npm for convenient local development
live-server:
	live-server --ignorePattern=elm-stuff --ignorePattern='\\.\#' --ignorePattern='flycheck'

.PHONY: js debug bundle
.PHONY: test lint
.PHONY: clean clean-deps realclean
.PHONY: watch live-server
