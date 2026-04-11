#lang pollen

◊(define-meta title "Blog")

◊(require pollen/pagetree pollen/template pollen/core racket/string)

◊; Load the pagetree from the blog/ subfolder.
◊; Posts are listed there as bare filenames (e.g., my-post.html).
◊(define blog-ptree
    (dynamic-require "blog/index.ptree" 'doc))

◊; For each post, read its metas and build a txexpr entry.
◊; The href prepends "blog/" so links resolve correctly from the root.
◊(define (render-blog-entries)
    (for/list ([page (in-list (pagetree->list blog-ptree))])
      (define page-source
        (string-append "blog/" (symbol->string page) ".pm"))
      (define page-metas (dynamic-require page-source 'metas))
      (define pg-title
        (or (select-from-metas 'title page-metas) (symbol->string page)))
      (define pg-date
        (or (select-from-metas 'date page-metas) ""))
      (define pg-datetime
        (or (select-from-metas 'datetime page-metas) ""))
      `(div ((class "blog-entry"))
            (a ((class "blog-entry-title")
                (href ,(string-append "blog/" (symbol->string page))))
               ,pg-title)
            (span ((class "blog-entry-date"))
                  (time ((datetime ,pg-datetime)) ,pg-date)))))

◊commentary-topic{Et Cetera}

◊(define blog-entries (pagetree->list blog-ptree))

◊(if (null? blog-entries)
    `(p "Nothing here yet!")
    `(div ((class "blog-index")) ,@(render-blog-entries)))