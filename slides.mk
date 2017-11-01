## No implicit rules
MAKEFLAGS += -rR

## Get current directory where this very file is located
current_dir := $(dir $(lastword $(MAKEFILE_LIST)))

## Enable second expansion
# This enables having access to $@ in the pre-requisites of our rules
.SECONDEXPANSION:

## Define and check external programs
TPAGE := tpage
ifeq (,$(shell command -v $(TPAGE) 2>/dev/null))
$(error Could not find executable '$(TPAGE)' in PATH. \
	You probably want to install the Perl Template Toolkit)
endif

## Find all files under a directory
find_files = $(shell find $(1) -type f)

## List of markdown files and resulting html files
md := $(filter %.md,$(call find_files,$(src)))
html := $(md:%.md=%.html)
pdf := $(html:%.html=%.pdf)

## Extra dependencies for all targets
dep += $(addprefix $(current_dir),template.html)

## Font generation
fontdir := $(addprefix $(current_dir),fonts)
fontcss := $(fontdir)/fonts.css

## Command management and quiet mode
ifneq ($(V),1)
Q = @
quiet = quiet_
else
Q =
quiet =
endif

echo-cmd = $(if $($(quiet)cmd_$(1)),\
	echo '  $($(quiet)cmd_$(1))';)
cmd = @$(echo-cmd) $(cmd_$(1))

## Our main rule building all our targets
all: $(fontcss) $(html)

# Font generation rule
quiet_cmd_fonts = FONTS $@
      cmd_fonts = $(fontdir)/genfonts.sh \
				  $^ > $@
$(fontcss): $(fontdir)/*.ttf
	$(call cmd,fonts)

# Get relative path between destination folder $1 and base folder $2
dir_relpath = $(shell perl -e "use File::Spec; print File::Spec->abs2rel('$(1)','$(2)');")

## Markdown to HTML rule
quiet_cmd_tpage = TPAGE $@
      cmd_tpage = $(TPAGE) \
				  --define common=$(call dir_relpath,$(current_dir),$(@D)) \
				  --include_path=$(current_dir) \
				  $< > $@
%.html: %.md $(dep)
	$(call cmd,tpage)

pdf: all $(pdf)

## HTML to pdf rule
quiet_cmd_pdfgen = PDF $@
      cmd_pdfgen = chromium --headless --disable-gpu \
				  --print-to-pdf=$@ \
				  file://$(abspath $<) \
				  2>/dev/null
%.pdf: %.html $(call find_files,$(current_dir))
	$(call cmd,pdfgen)

## PDF Automatic dependencies
# Make targets be dependent on all local files (except themselves and the
# markdown source to avoid circular dependency)
pdf_auto_dep = $(1): $(filter-out $(1) $(1:%.pdf=%.md),$(call find_files,$(dir $(1))))
$(foreach f,$(html),$(eval $(call auto_dep,$(f))))


## Clean rule
clean:
	$(Q)rm -f $(fontcss) $(html) $(pdf)
