# blog

Source for [miketalbot.io/blog](https://miketalbot.io/blog), built with [Quarto](https://quarto.org).

## Writing

- One folder per post under `posts/`, with the text in `index.md` (or `index.qmd` if it runs R code) and images alongside it.
- Mark unfinished posts `draft: true` in the front matter. Drafts show in `quarto preview` but are left out of the published site and the RSS feed.
- Loose ideas live in `_ideas/`, which Quarto ignores.
- Supporting analysis that shouldn't be rendered goes in a `_`-prefixed folder (e.g. `posts/rivers-dont-read-maps/_analysis/`). Large `.rds` data files are git-ignored.

## Building

```sh
quarto preview   # local preview with live reload, drafts visible
quarto render    # build the site into _site/
```

Pushing to `main` renders and deploys the site with GitHub Actions. Posts that execute code are rendered locally first; commit the resulting `_freeze/` directory so CI doesn't need R.

Because this repo is named `blog` and the user site (`realmiketalbot.github.io`) uses the custom domain `miketalbot.io`, GitHub Pages serves it at `miketalbot.io/blog/`.
