<!DOCTYPE html>
◊;; --------------------------------------------------------------------------
◊;; Per-page values pulled from the current page's metas
◊;; --------------------------------------------------------------------------
◊(define here-title
    (or (select-from-metas 'title here) (symbol->string here)))
◊(define here-description
    (or (select-from-metas 'description here) site-tagline))
◊(define full-title
    (string-append (capitalize-first-letter here-title) " | " site-name))
◊(define canonical-url
    (string-append canonical-base "/" (symbol->string here)))
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="format-detection" content="telephone=no">

  <script type="text/javascript" src="/functions.js"></script>

  <meta content="◊|full-title|" name="title" />
  <meta content="◊|here-description|" name="description" />
  <meta content="website" property="og:type" />
  <meta content="◊|canonical-url|" property="og:url" />
  <meta content="◊|full-title|" property="og:title" />
  <meta content="◊|here-description|" property="og:description" />
  ◊;; TODO: add og:image once a site image is available, e.g.:
  ◊;; <meta content="https://alexandernnoori.com/images/og-image.jpg" property="og:image" />
  <meta content="summary_large_image" property="twitter:card" />
  <meta content="◊|twitter-handle|" property="twitter:site" />
  <meta content="◊|canonical-url|" property="twitter:url" />
  <meta content="◊|full-title|" property="twitter:title" />
  <meta content="◊|here-description|" property="twitter:description" />
  ◊;; TODO: <meta content="https://alexandernnoori.com/images/og-image.jpg" property="twitter:image" />

  <link rel="icon" href="/favicon.ico" />
  <link rel="stylesheet" type="text/css" media="all" href="/fonts/fonts.css" />
  <link rel="stylesheet" type="text/css" media="all" href="/styles.css" />

  <title>◊|full-title|</title>

  <style type="text/css">
    #switcher {
      margin-top: 12px;
      border: 1px solid gray;
      box-shadow: 2px 2px;
      cursor: default;
      text-align: center;
      padding-top: 0.2em;
      padding-bottom: 0.2em;
    }
  </style>
</head>

<body id="body" class="body-text_century-supra">

  <div id="switcher">◊(render-switcher here)</div>

  <div id="content">

    <div id="doc">◊(->html doc)</div><a id="links"></a>
    <div class="gap" style="height:1em"></div>
    <ul class="children"></ul>

  </div>

  <div id="toolbar" class="">

    <div id="navtable">

      <div>
        <a class="box-link" href="colophon.html"><span class="arrow">←</span>&nbsp;colophon</a>
      </div>

      <div class="center">
        <a class="box-link" href="/">home</a>
      </div>

      <div>
        <a class="box-link" href="/ANabaviNoori_CV.pdf">curriculum vitae&nbsp;<span class="arrow">→</span></a>
      </div>

    </div>
  </div>

</body>

</html>
