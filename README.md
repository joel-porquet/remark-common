# Overview

My build system and common files for remark slides.

# Dependencies

This build system depends on:
- The [Perl Template Toolkit](http://www.template-toolkit.org/) for the
  templating engine. On Archlinux, it can be installed very easily: `pacman -S
  perl-template-toolkit`.
- Chromium for PDF generation.
- `fc-scan` for embedding fonts in CSS
    - Solves [CORS](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing)
      issues with Firefox

# Usage

The typical use-case is to have this repo as submodule (and subfolder) of your
slides repo. Eg:

```
$ tree
.
├── common      <= the submodule
├── slides
│   ├── index.md
│   └── local.css
├── Makefile
└── template.md
```

## Root makefile

In the "root" Makefile, you need to specify which folders contain the
markdown-formatted slides and which dependencies are global to all slides. Eg:

```mk
## Source directories
src := slides

## Extra dependencies (optional)
dep := template.md

## Include common rules
include common/Rules.mk
```

## Global template

Having a root `template.md` is not necessary but very useful if you're making a
set of slide decks that share the same title page for example. Here is what this
file could contain:

`template.md`:
```
[% INCLUDE "common/template.html" %]
[% BLOCK content %]

class: center, middle

# [% title %]

.Large[*Author*]

.footnote[[CC BY-NC-SA 4.0 International Licence](https://creativecommons.org/licenses/by-nc-sa/4.0/)]

---
[% PROCESS slides %]

[% END %]
```

In this case, here is what `slides/index.md` would contain too:
```
[% INCLUDE "template.md" title="Course Introduction" %]
[% BLOCK slides %]

# First slide

Blabla

---

# Second slide

Blabla

[% END %]
```

## Local CSS

The `local.css` file is optional. It contain local CSS rules that only apply to
a deck of slides. It's loaded after `common/style/base.css` so it can override
CSS rules.

