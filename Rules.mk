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
find_files = $(shell find $(1) -type f 2>/dev/null)

## List of markdown files and resulting html files
md := $(filter %.md,$(call find_files,$(src)))
html := $(md:%.md=%.html)
print := $(md:%.md=%.print.html)
pdf := $(print:%.print.html=%.pdf)

## Extra dependencies for all targets
dep += $(addprefix $(current_dir),template.html)
dep += $(addprefix $(current_dir),tt2/srcfile.tt)

## Font generation
fontdir := $(addprefix $(current_dir),style)
fontext := $(addprefix $(current_dir),vendor/katex/fonts)
fontttf := $(filter %.ttf,$(call find_files,$(fontdir)))
fontttf += $(filter %.ttf,$(call find_files,$(fontext)))
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
$(fontcss): $(fontttf)
	$(call cmd,fonts)

# Get relative path between destination folder $1 and base folder $2
dir_relpath = $(shell perl -e "use File::Spec; print File::Spec->abs2rel('$(1)','$(2)');")

## Markdown to HTML rule
quiet_cmd_tpage = TPAGE $@
      cmd_tpage = $(TPAGE) \
				  --eval_perl \
				  --define incslides=$(INCSLIDES) \
				  --define common=$(call dir_relpath,$(current_dir),$(@D)) \
				  --include_path=$(current_dir) \
				  --include_path=$(@D) \
				  $< > $@
%.html: INCSLIDES := false
%.html: %.md $(dep) $$(call find_files,$$(@D)/code)
	$(call cmd,tpage)

## HTML print main rule
print: $(fontcss) $(print)

%.print.html: INCSLIDES := true
%.print.html: %.md $(dep) $$(call find_files,$$(@D)/code)
	$(call cmd,tpage)

## PDF main rule
pdf: print $(pdf)

## HTML to pdf rule
quiet_cmd_pdfgen = PDF $@
      cmd_pdfgen = chromium --headless --disable-gpu \
				  --print-to-pdf=$@ \
				  file://$(abspath $<) \
				  2>/dev/null
%.pdf: %.print.html $(call find_files,$(current_dir))
	$(call cmd,pdfgen)

## PDF export
export: pdf
	mkdir -p exports
	cp -u $(pdf) exports
	zip -r exports/archive.zip exports/*.pdf

## PDF Automatic dependencies
# Make targets be dependent on all local files (except themselves and the
# markdown source to avoid circular dependency)
pdf_auto_dep = $(1): $(filter-out $(1) $(1:%.pdf=%.md),$(call find_files,$(dir $(1))))
$(foreach f,$(html),$(eval $(call auto_dep,$(f))))


## Clean rule
clean:
	$(Q)rm -f $(fontcss) $(html) $(print) $(pdf)
