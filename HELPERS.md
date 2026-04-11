# Pollen helper functions

A full rundown of the helper functions defined in `pollen.rkt` for this project, grouped by purpose.

## Page titles and section headings

- `◊title-block[(title-from-metas metas)]{subhead text}` — the standard top-of-page hanging title. Emits `<title-block><topic>TITLE</topic><short-rule>SUBHEAD</short-rule></title-block>` and gets the compact 125% bolder treatment.
- `◊small-title-block[(title-from-metas metas)]{subhead text}` — same structure but uses `<topic class="small">` inside; mirrors the Colophon page pattern.
- `◊title-from-metas[metas]` — helper that pulls a page's `title` meta value out for use as the first argument to either title-block.
- `◊big-topic{…}` — standalone `<topic>` slab in uppercase Advocate C41 with a top border. The next paragraph gets bumped to 115% as a lede.
- `◊small-topic{…}` — standalone `<topic class="small">`: italic (or bold in Hermes Maia/Concourse), 170%, no uppercasing.
- `◊commentary-topic{…}` — standalone `<topic class="commentary">`: 2.1rem, bottom border instead of top.
- `◊subhead["anchor-id"]{section name}` — anchored mid-page subheading. Renders `<div class="subhead" id="anchor-id"><a href="#anchor-id">section name</a></div>`.

## Inline semantic text

- `◊first-use{term}` — marks the first use of a term (small-caps treatment from CSS).
- `◊phrase{a phrase}` — generic phrase marker.
- `◊glyph{"}` — wraps a single character or short glyph for special styling.
- `◊book{Practical Typography}` — italic book title.
- `◊no-hyphens{Jessica.}` — suppresses auto-hyphenation inside the span.
- `◊sc{pollen}` — inline small-caps via `font-variant: small-caps`.
- `◊monospaced{~/projects/site}` — non-code monospace run (file paths, field names).
- `◊code{<q>}` — HTML `<code>` element for actual code snippets.
- `◊q-tag{Hello}` — HTML `<q>` element (named `q-tag` to avoid clashing with Racket's built-in `q`).
- `◊run-in{Windows}` — inline label used inside asides to lead off a sub-paragraph (Windows / Mac OS / etc.).
- `◊program{Word}` — program-name label inside how-to instructions.
- `◊instruction{File → Options → …}` — instruction body following a program label.
- `◊ui{File}` — UI element label (menu items, button names) with the bracket-arrow styling.
- `◊sig{Xander}` — inline signature element with per-body-font styling.

## Asides and sidebar content

- `◊aside{single paragraph of margin note}` — auto-detects single vs. multi-paragraph; when source contains blank lines it splits each chunk into its own `<p>` via decode-paragraphs, otherwise wraps the whole thing in one `<p>`.
- `◊image-aside["images/headshot.jpg"]` — convenience for an aside containing only an image.

## Cross-references and links

- `◊xref["other-page.html"]{anchor text}` — internal cross-reference styled as the small-caps blue link used throughout the site.
- `◊link["https://…" "anchor text"]` — external link.

## Block structures

- `◊indented{…}` — generic block-level indent for pull-outs and quotes.
- `◊figure["images/chart.jpg"]` or `◊figure["path.jpg" "alt text"]` — top-level (non-aside) image paragraph with optional alt text.
- `◊howto["How to do the thing"]{…paragraphs…}` — boxed how-to block with the bold uppercase header label and content beneath.
- `◊qa[#:q "question text" #:source "attribution"]{answer body…}` — FAQ pair. The `#:source` keyword is optional. Renders the full `<div class="qa">` with `faq-question`, `faq-answer`, and optional `faq-answer-source` paragraphs.
- `◊btw{first paragraph` / blank line / `second paragraph}` — "by the way" trailing notes block; each blank-line-separated paragraph becomes a bullet.

## Tables

- `◊shortcut-table[…rows…]` — keyboard-shortcut table with the standard `<table class="shortcut">` styling. Each row is a list whose elements become cells.
- `◊table-clean{…}` — minimal borderless table style.
- `◊table-less-dense{…}` — bordered with generous padding.
- `◊table-dense{…}` — bordered with tight padding (compact data tables).
- `◊table-cluttered{…}` — heavy 0.2em borders, intentionally over-styled (used in the typography pages as a counterexample).
- `◊sigblock{…}` — letter-style signature wrapper, `<table class="sigblock">`.

## Optical typography

- `◊hang-dquo{That's a quote.}` — opening double-curly-quote with hanging punctuation. Pushes the `"` glyph into the left gutter so the first letter aligns to the column edge.
- `◊hang-squo{tis the season}` — same trick for opening single curly quotes, with a narrower shift to match the `'` glyph width.

## Inline font overrides (25 helpers)

Each wraps content in a `<span>` and switches the font family for that run. Italic and bold inside still work because each `@font-face` registers all four weights/styles under one family name.

**Body face romans (8):** `◊in-equity`, `◊in-concourse`, `◊in-heliotrope`, `◊in-triplicate`, `◊in-valkyrie`, `◊in-hermes-maia`, `◊in-century-supra`, `◊in-advocate` (Advocate also applies uppercase + letter-spacing automatically; strip those from the CSS class for raw glyphs).

**Monospace (1):** `◊in-triplicate-code` for the Triplicate Code monospace family.

**Small-caps cuts (4):** `◊in-equity-caps`, `◊in-century-supra-caps`, `◊in-concourse-caps`, `◊in-heliotrope-caps`. Note: feed these *lowercase* text — the caps faces redraw lowercase letters as small capitals.

**Concourse optical sizes (6):** `◊in-concourse-t2`, `◊in-concourse-t3`, `◊in-concourse-t3-index`, `◊in-concourse-t7`, `◊in-concourse-t8`, `◊in-concourse-c4`. The `t` numbers are optical weights (lighter to heavier display); `c4` is the caps-only display cut; `t3-index` is a tabular variant for index pages.

**Heliotrope optical sizes (3):** `◊in-heliotrope-t3`, `◊in-heliotrope-t8`, `◊in-heliotrope-c6`.

**Advocate condensed widths (3):** `◊in-advocate-c43`, `◊in-advocate-c53`, `◊in-advocate-c63` — c41 (the default in `◊in-advocate`) is narrowest, ascending to c63 widest. All inherit the uppercase + letter-spacing treatment.

## Site config and rendering plumbing

These are defined in `pollen.rkt` but you mostly interact with them by editing the constants at the top of the file rather than calling them in `.pm` source:

- `site-name`, `site-tagline`, `canonical-base`, `twitter-handle` — site-wide metadata constants used by the template.
- `switcher-links` — the list of `(label . href)` pairs that builds the top navbar (Research / Teaching / CV / Contact / Blog). Edit this list to change navbar items.
- `render-switcher` — function called from the template that turns `switcher-links` into the `<div id="switcher">` HTML string.

## Quick mental model

Roughly speaking, the helpers fall into three buckets:

1. **Structural** — titles, asides, howtos, tables, qa. These emit the HTML scaffolding the redesign expects.
2. **Semantic inline** — first-use, book, phrase, sc, no-hyphens, etc. These tag meaning so the CSS can style consistently.
3. **Typographic** — hang-dquo, in-* font overrides. These are escape hatches for fine-grained control when you want a specific visual effect.

For day-to-day writing you'll mostly reach for `◊title-block`, `◊xref`, `◊aside`, `◊first-use`, `◊book`, `◊no-hyphens`, and the four block helpers (`indented`, `figure`, `howto`, `qa`); the rest are there when you need them.
