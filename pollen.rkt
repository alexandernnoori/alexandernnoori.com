#lang pollen/mode racket/base
(require (except-in "scribblings/pollen-rkt.scrbl"
                    hanging-topic
                    btw)
         pollen/tag
         pollen/core
         pollen/decode
         pollen/template
         txexpr
         racket/list)
(provide (all-from-out "scribblings/pollen-rkt.scrbl"))

(module setup racket/base
  (provide (all-defined-out)) ;; <- don't forget this line in your config submodule!
  (require pollen/setup racket/path)
  (define (omitted-path? p) (path-has-extension? p #".sh")))

;; ---------------------------------------------------------------------------
;; Site-wide configuration
;; ---------------------------------------------------------------------------

(provide site-name site-tagline canonical-base twitter-handle)
(define site-name       "Alexander Nabavi-Noori")
(define site-tagline    "Ph.D. Student, Harvard University")
(define canonical-base  "https://alexandernnoori.com")
(define twitter-handle  "@xandernn")

;; ---------------------------------------------------------------------------
;; Top-nav (switcher) links
;;
;; Edit this list to add/remove/reorder links in the top nav bar.
;; Each entry is (list href label). The template renders this list directly
;; at build time, so there's no JavaScript involved.
;; ---------------------------------------------------------------------------

(provide switcher-links render-switcher)

(define switcher-links
  '(("index.html"    "About")
    ("/research.html" "Research")
    ("/experience.html" "Experience")
    ("/blog.html"     "Blog")
    ("/contact.html"  "Contact")
    ("/ANabaviNoori_CV.pdf"       "CV")))

;; Render the switcher as an HTML string (for direct interpolation in a
;; preprocessor template). The currently active page (based on `here`) gets
;; an additional "active" class.
(define (render-switcher here-sym)
  (apply string-append
    (for/list ([link (in-list switcher-links)])
      (define href   (car link))
      (define label  (cadr link))
      (define active? (equal? (string->symbol href) here-sym))
      (format "<a class=\"~a\" href=\"~a\">~a</a>\n"
              (if active? "nav-link active" "nav-link")
              href
              label))))

;; ---------------------------------------------------------------------------
;; New-site tag functions
;;
;; The new site uses a small set of custom HTML element names as semantic
;; hooks for CSS styling. Each one becomes a thin tag function here.
;; ---------------------------------------------------------------------------
(define (doc->html doc)
  (apply string-append (map ->html (get-elements doc))))

(provide doc->html
        title-block small-title-block title-from-metas big-topic small-topic commentary-topic
         in-equity in-concourse in-heliotrope in-triplicate
         in-valkyrie in-hermes-maia in-century-supra in-advocate
         in-triplicate-code
         in-equity-caps in-century-supra-caps in-concourse-caps in-heliotrope-caps
         in-concourse-t2 in-concourse-t3 in-concourse-t3-index
         in-concourse-t7 in-concourse-t8 in-concourse-c4
         in-heliotrope-t3 in-heliotrope-t8 in-heliotrope-c6
         in-advocate-c43 in-advocate-c53 in-advocate-c63
         hang-dquo hang-squo indented figure qa sig sigblock sc monospaced
         table-clean table-less-dense table-dense table-cluttered
         first-use phrase glyph book aside image-aside
         run-in code q-tag program instruction ui
         subhead howto
         no-hyphens
         shortcut-table
         btw
         blockquote
         justified
         indented-justified)

;; title-block — replaces the old `hanging-topic`. Same visual placement
;; (left-column hanging label) but emits the new semantic markup:
;;   <title-block><topic>TITLE</topic><short-rule>SUBHEAD</short-rule></title-block>
;;
;; Usage in a .pm file:
;;   ◊title-block[(title-from-metas metas)]{Use them, don't confuse them}
(define (title-block title-text . subhead-elements)
  `(title-block
    (topic ,title-text)
    (short-rule ,@subhead-elements)))

;; small-title-block — same structure as title-block but uses
;; <topic class="small"> inside. Mirrors the reference HTML pattern
;;   <title-block><topic class="small">Colophon</topic>
;;                <short-rule>A note, …</short-rule></title-block>
;; Usage: ◊small-title-block[(title-from-metas metas)]{A note, …}
(define (small-title-block title-text . subhead-elements)
  `(title-block
    (topic ((class "small")) ,title-text)
    (short-rule ,@subhead-elements)))

;; Helper that pulls the raw title string out of a page's metas, so
;; title-block can be called as ◊title-block[(title-from-metas metas)]{...}.
(define (title-from-metas metas)
  (or (select-from-metas 'title metas) "(untitled)"))

;; Inline font-override helpers. Each wraps its content in a <span> with
;; a class defined in styles.css (`.font-equity`, `.font-concourse`, etc.)
;; so you can drop a phrase into a different face without changing the
;; whole page. Italics and bold still work inside — the @font-face rules
;; in fonts/fonts.css map all weights/styles onto the same family name.
(define (in-equity       . es) `(span ((class "font-equity"))       ,@es))
(define (in-concourse    . es) `(span ((class "font-concourse"))    ,@es))
(define (in-heliotrope   . es) `(span ((class "font-heliotrope"))   ,@es))
(define (in-triplicate   . es) `(span ((class "font-triplicate"))   ,@es))
(define (in-valkyrie     . es) `(span ((class "font-valkyrie"))     ,@es))
(define (in-hermes-maia  . es) `(span ((class "font-hermes-maia"))  ,@es))
(define (in-century-supra . es) `(span ((class "font-century-supra")) ,@es))
(define (in-advocate     . es) `(span ((class "font-advocate"))     ,@es))
(define (in-triplicate-code . es) `(span ((class "font-triplicate-code")) ,@es))

;; Small-caps variants.
(define (in-equity-caps        . es) `(span ((class "font-equity-caps"))        ,@es))
(define (in-century-supra-caps . es) `(span ((class "font-century-supra-caps")) ,@es))
(define (in-concourse-caps     . es) `(span ((class "font-concourse-caps"))     ,@es))
(define (in-heliotrope-caps    . es) `(span ((class "font-heliotrope-caps"))    ,@es))

;; Concourse optical-size / display cuts.
(define (in-concourse-t2       . es) `(span ((class "font-concourse-t2"))       ,@es))
(define (in-concourse-t3       . es) `(span ((class "font-concourse-t3"))       ,@es))
(define (in-concourse-t3-index . es) `(span ((class "font-concourse-t3-index")) ,@es))
(define (in-concourse-t7       . es) `(span ((class "font-concourse-t7"))       ,@es))
(define (in-concourse-t8       . es) `(span ((class "font-concourse-t8"))       ,@es))
(define (in-concourse-c4       . es) `(span ((class "font-concourse-c4"))       ,@es))

;; Heliotrope optical-size / display cuts.
(define (in-heliotrope-t3      . es) `(span ((class "font-heliotrope-t3"))      ,@es))
(define (in-heliotrope-t8      . es) `(span ((class "font-heliotrope-t8"))      ,@es))
(define (in-heliotrope-c6      . es) `(span ((class "font-heliotrope-c6"))      ,@es))

;; Advocate condensed widths (c41 is the default; c63 is widest).
(define (in-advocate-c43       . es) `(span ((class "font-advocate-c43"))       ,@es))
(define (in-advocate-c53       . es) `(span ((class "font-advocate-c53"))       ,@es))
(define (in-advocate-c63       . es) `(span ((class "font-advocate-c63"))       ,@es))

;; Trivial wrapper tags — each just produces <tagname>...</tagname>.
(define first-use (default-tag-function 'first-use))
(define phrase    (default-tag-function 'phrase))
(define glyph     (default-tag-function 'glyph))
(define book      (default-tag-function 'book))

;; aside — margin note. The new site's CSS targets `aside p`, so contents
;; must be wrapped in <p>. Supports multiple paragraphs: items in the .pm
;; source separated by blank lines become separate <p> elements via
;; decode-paragraphs.
(define (aside . elements)
  ;; If the source contains blank-line breaks, hand off to decode-paragraphs
  ;; so each chunk becomes its own <p>. Otherwise wrap the whole thing in a
  ;; single <p> manually — decode-paragraphs leaves single-paragraph content
  ;; unwrapped, which would defeat the `aside p` CSS selector.
  (define has-breaks?
    (for/or ([e (in-list elements)])
      (and (string? e) (regexp-match? #px"\n[ \t]*\n" e))))
  (if has-breaks?
      `(aside ,@(decode-paragraphs elements 'p))
      `(aside (p ,@elements))))

;; image-aside — convenience for an aside containing only an image.
;; Usage: ◊image-aside["images/headshot.jpg"]
(define (image-aside src)
  `(aside (p ((class "image")) (img ((src ,src))))))

;; big-topic — bare <topic>...</topic>. Renders as the big uppercase
;; Advocate C41 slab with a top border. The paragraph immediately
;; following also gets bumped to 115% (CSS `topic + p` rule), producing
;; a lede effect.
(define big-topic (default-tag-function 'topic))

;; small-topic — <topic class="small">...</topic>. Inherits the body
;; font, 170% size, italic (or bold in Hermes Maia / Concourse), no
;; uppercasing. Compact alternative to big-topic.
(define (small-topic . elements)
  `(topic ((class "small")) ,@elements))

;; commentary-topic — <topic class="commentary">...</topic>. 2.1rem,
;; no top border, bottom border instead, tighter line-height.
(define (commentary-topic . elements)
  `(topic ((class "commentary")) ,@elements))

;; Trivial wrapper tags for inline semantic elements.
(define run-in      (default-tag-function 'run-in))
(define code        (default-tag-function 'code))
(define program     (default-tag-function 'program))
(define instruction (default-tag-function 'instruction))
(define ui          (default-tag-function 'ui))

;; q-tag — HTML <q> element. Named q-tag to avoid colliding with Racket's
;; built-in `q`. Provided as `q-tag`; in .pm sources, call as ◊q-tag{...}.
(define q-tag (default-tag-function 'q))

;; subhead — anchored subheading. Renders as
;;   <div class="subhead" id="ID"><a href="#ID">TEXT</a></div>
;; Usage: ◊subhead["curly-quotes-on-the-web"]{Curly quotes on the web}
(define (subhead id . elements)
  `(div ((class "subhead") (id ,id))
        (a ((href ,(string-append "#" id))) ,@elements)))

;; hang-dquo — opening double-curly-quote with optical hanging margin.
;; Wrap the quote-and-following-text at the start of a paragraph:
;;   ◊hang-dquo{That's a quote.}
;; Emits the empty `pusher` span (which carries a negative margin to
;; eat into the gutter) followed by the `puller` span containing the
;; opening “ glyph and the rest of the run. Paired with CSS rules on
;; dquo-open-push / dquo-open-pull in styles.css.
(define (hang-dquo . elements)
  `(span ((class "hang-dquo"))
         (dquo-open-push)
         (dquo-open-pull "“" ,@elements)))

;; hang-squo — opening single-curly-quote with optical hanging margin.
;; Same idea as hang-dquo, narrower shift to match the ' glyph width.
;;   ◊hang-squo{tis the season}
(define (hang-squo . elements)
  `(span ((class "hang-squo"))
         (squo-open-push)
         (squo-open-pull "‘" ,@elements)))

;; indented — generic block-level indent for pull-outs and quotes.
(define (indented . elements)
  `(div ((class "indented")) ,@elements))

;; justified — wraps content in a div with justified text alignment.
(define (justified . elements)
  `(div ((class "justified")) ,@elements))

;; indented-justified — indented block with justified text alignment.
(define (indented-justified . elements)
  `(div ((class "indented-justified")) ,@elements))

;; blockquote — blockquote with background styling.
(define (blockquote . elements)
  `(blockquote ,@elements))

;; figure — a top-level image paragraph (not inside an aside).
;; Usage: ◊figure["images/chart.jpg"]
;;        ◊figure["images/chart.jpg" "Alt text for screen readers"]
(define figure
  (case-lambda
    [(src)     `(p ((class "image")) (img ((src ,src) (alt ""))))]
    [(src alt) `(p ((class "image")) (img ((src ,src) (alt ,alt))))]))

;; FAQ / Q&A pair. The reference HTML wraps a question/answer in
;; <div class="qa"> with <p class="faq-question">, <p class="faq-answer">,
;; and an optional <p class="faq-answer-source"> for attribution.
;; Usage:
;;   ◊qa[#:q "What is typography?"
;;       #:source "— Matthew Butterick"]{
;;     The visual component of the written word.
;;   }
(define (qa #:q question #:source [source #f] . answer-elements)
  `(div ((class "qa"))
        (p ((class "faq-question")) ,question)
        (p ((class "faq-answer")) ,@answer-elements)
        ,@(if source
              `((p ((class "faq-answer-source")) ,source))
              '())))

;; sig — inline signature element. <sig>...</sig> picks up per-body-font
;; styling from styles.css (lines 55–106).
(define sig (default-tag-function 'sig))

;; sigblock — letter-style signature table wrapper.
(define (sigblock . elements)
  `(sig ,@elements))

;; sc — small-caps inline. Shorter and body-font-agnostic; resolves
;; via the .sc CSS rule (font-variant: small-caps).
(define sc (default-tag-function 'sc))

;; monospaced — inline monospace run, distinct from semantic <code>.
;; For file paths, field names, keystrokes, etc.
(define monospaced (default-tag-function 'monospaced))

;; Table density helpers — thin wrappers that set the appropriate class.
;; Usage: ◊table-clean{◊tr{◊th{Name} ◊th{Score}} ◊tr{◊td{X} ◊td{99}}}
(define (table-clean       . es) `(table ((class "table-clean"))       ,@es))
(define (table-less-dense  . es) `(table ((class "table-less-dense"))  ,@es))
(define (table-dense       . es) `(table ((class "table-dense"))       ,@es))
(define (table-cluttered   . es) `(table ((class "table-cluttered"))   ,@es))

;; howto — boxed how-to block with a labeled header.
;;   <div class="howto"><div class="howto-name">NAME</div> ...children... </div>
;; Usage: ◊howto["How to do the thing"]{ ...paragraphs... }
(define (howto name . elements)
  `(div ((class "howto"))
        (div ((class "howto-name")) ,name)
        ,@elements))

;; no-hyphens — wrap content in <span class="no-hyphens">...</span> to
;; prevent end-of-line hyphenation on a specific word or phrase.
(define (no-hyphens . elements)
  `(span ((class "no-hyphens")) ,@elements))

;; shortcut-table — keyboard shortcut reference table at the top of certain
;; pages. Each row is a list of five elements:
;;   (list glyph-char name win-shortcut mac-shortcut html-entity)
;; The html-entity element can be a string or a txexpr (e.g., to wrap in
;; <code>).
;;
;; Usage:
;;   ◊(shortcut-table
;;     '("-" "hyphen"  "-"        "-"                       "-")
;;     `("–" "en dash" "alt 0150" "option + hyphen"         (code "&ndash;"))
;;     `("—" "em dash" "alt 0151" "option + shift + hyphen" (code "&mdash;")))
(define (shortcut-table . rows)
  `(table ((class "shortcut"))
    (thead
      (tr (th ((class "no-hyphens")))
          (th ((class "no-hyphens")))
          (th ((class "no-hyphens")) "Windows")
          (th ((class "no-hyphens")) "Mac OS")
          (th ((class "no-hyphens")) "HTML")))
    (tbody
      ,@(for/list ([row (in-list rows)])
          (define glyph-char (list-ref row 0))
          (define name       (list-ref row 1))
          (define win        (list-ref row 2))
          (define mac        (list-ref row 3))
          (define html       (list-ref row 4))
          `(tr
            (td (glyph ,glyph-char))
            (td ,name)
            (td ((class "instruction")) ,win)
            (td ((class "instruction")) ,mac)
            (td ((class "instruction")) ,html))))))

;; btw — "by the way" aside box that appears at the bottom of pages.
;; New structure:
;;   <div class="btw">
;;     <div class="btw-title">by the way</div>
;;     <ul>
;;       <li><p>item 1</p></li>
;;       <li><p>item 2</p></li>
;;     </ul>
;;   </div>
;;
;; Items in the .pm source are separated by blank lines, just like the
;; old btw and like numbered-list.
(define (btw . tx-elements)
  (define ul-tag-function (make-list-function 'ul))
  (define inner-ul (apply ul-tag-function tx-elements))
  `(div ((class "btw"))
        (div ((class "btw-title")) "by the way")
        ,inner-ul))