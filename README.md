# JuDoc

| Status | Coverage |
| :----: | :----: |
| [![Build Status](https://travis-ci.org/tlienart/JuDoc.jl.svg?branch=master)](https://travis-ci.org/tlienart/JuDoc.jl) | [![codecov.io](http://codecov.io/github/tlienart/JuDoc.jl/coverage.svg?branch=master)](http://codecov.io/github/tlienart/JuDoc.jl?branch=master) |

JuDoc is a simple **static site generator** (SSG) oriented towards technical blogging (code, maths, ...) and written in Julia.
The base syntax is markdown but it allows a subset of LaTeX (`\newcommand...`) and uses KaTeX to render the maths.
I use it to generate [my website](https://tlienart.github.io).

### Quick demo

(_for more detailed instructions, read the Install section further on_)

* `add https://github.com/tlienart/JuDoc.jl` in Julia ≥ 1.0.
* `npm install -g browser-sync` (to live-preview)

```julia
julia> using JuDoc

julia> newsite("MyNewSite")
✓ Website folder generated at MyNewSite (now the current directory).
→ Use `serve()` to render the website and see it in your browser.

julia> serve()
→ Starting the engine (give it 1-2s)...
✓ Now live-serving at http://localhost:8000
✓ Watching input folder, press CTRL+C to stop the server.
```

You can now modify the files in `MyNewSite/src` and see the changes being live-rendered in your browser.

### Features

**Supported**
* allows LaTeX-like definition of commands (via `\newcommand{..}[.]{..}`)
* allows easy inclusion of user-defined div-blocks via `@@divname ... @@` and raw-html via `~~~ ... ~~~`
* maths rendered via [KaTeX](https://katex.org/), code via [highlight.js](highlightjs.org)
* seamless offline editing
* within-page hyper-references for equations and citations
* simple html templating
* fast rendering (~5ms per page on warm session)
* live preview (partly via [`browsersync`](https://browsersync.io/))
* minified output (via [`css-html-js-minify`](https://github.com/juancarlospaco/css-html-js-minify))

**Coming**
* more CSS  themes (two are available, the aim is to get ±6 good ones as per [#112](https://github.com/tlienart/JuDoc.jl/issues/112), _suggestion/contribution for other ones are welcome_)
* live rendering via [LiveServer.jl](https://github.com/asprionj/LiveServer.jl) instead of browser-sync, LiveServer is WIP with [Jonas](https://github.com/asprionj).
* pre-rendering of code highlighting and katex for faster online page loading
* customisable bibliography styles
* docs

#### Templates

```julia
using JuDoc
newsite("site-name", template="template-name")
serve()
```

where the supported templates are currently:

| Name          | Adapted from  | Comment  |
| ------------- | -------------| -----    |
| `"basic"`     | N/A ([example](https://tlienart.github.io/)) | minimal cruft, no extra JS |
| `"pure-sm"`   | Pure "Side-Menu" ([example](https://purecss.io/layouts/side-menu/)) | small JS for the responsive menu  |
| `"vela"`      | Grav "Vela" ([example](https://demo.matthiasdanzinger.eu/vela/)) | JQuery + JS for the side menu |

## Why

There are a lot of SSGs out there; some pretty big and established ones like [Hugo](https://gohugo.io/), [Pelican](https://blog.getpelican.com/) or [Jekyll](https://github.com/jekyll/jekyll).

In the past, I tried [Jemdoc](http://jemdoc.jaboc.net/) which I thought was nice particularly because of it simplicity.
However it is not very fast, does not allow live preview, and does not work with KaTeX (at least natively).

I also tried some of the other SSGs: Hugo, Jekyll, [Hakyll](https://jaspervdj.be/hakyll/) and [Gutenberg](https://github.com/Keats/gutenberg) but while these projects are awesome, I never felt really comfortable using them for technical notes and was looking for something that would hopefully feel quite close to LaTeX while being quite simple.

The list of goals was then to build something

* simple like Jemdoc,
* that can do live-preview with near-instantaneous rendering of modifications,
* that generates efficient webpages with as little cruft as possible,
* that allows latex-like commands,
* in Julia.

JuDoc is an attempt at meeting these criterion, help to make this better is always welcome!

## Installation

### The engine

To install JuDoc, you need [Julia](https://julialang.org/) (1.0 or above) and JuDoc (which is currently unregistered):

```julia
] # enter package mode
(v 1.0) > add https://github.com/tlienart/JuDoc.jl
```

### Rendering

To render your site locally, `serve()` uses [`browser-sync`](https://browsersync.io/) which allows you to directly see the modifications you make in your browser.
It is not necessary to install it i.e.: you could just run JuDoc and use another server or push the pages on GitHub and see how they get rendered there but it's easier to see how your website renders locally with any modifications you make being applied live.
To install [`browser-sync`](https://browsersync.io/) just run

```
npm install -g browser-sync
```

(which requires you to have [`npm`](https://www.npmjs.com/get-npm) but it's unlikely you don't.)

### Minifying

The files generated by JuDoc are pretty simple and thus pretty light already but they can still be compressed a bit more.
For this we use the simple [`css-html-js-minify`](https://github.com/juancarlospaco/css-html-js-minify) which can be installed via `pip`:

```
pip install css-html-js-minify
```

Again, it's not a required dependency, it is however encoded in `publish()` so if you use that, JuDoc will assume that you have it.

**Remark** there are more sophisticated minifiers out there however the script above is simple and has the added advantage that it doesn't clash with KaTeX which, for instance, [`html-minifier`](https://github.com/kangax/html-minifier) does as far as I can tell.

## Contributing

Initially I wrote this project for myself but I'm now hoping it may be of use to others too and as a result, contributions to make this project better would be very welcome!

Some notes on how to contribute are gathered [there](https://github.com/tlienart/JuDoc.jl/blob/master/CONTRIBUTING.md).
