# blog

Source for [miketalbot.io/blog](https://miketalbot.io/blog), built with [Quarto](https://quarto.org).

## Writing

- One folder per post under `posts/`, with the text in `index.md` (or `index.qmd` if it runs R code) and images alongside it.
- Unfinished posts live in `_drafts/` and loose ideas in `_ideas/`. Quarto ignores `_`-prefixed folders, so neither shows up in the preview or on the site. To publish a draft, move its folder into `posts/` and give it a `date:`.
- Supporting analysis that shouldn't be rendered goes in a `_`-prefixed folder (e.g. `_drafts/rivers-dont-read-maps/_analysis/`). Large `.rds` data files are git-ignored.

## Building

```sh
quarto preview   # local preview with live reload, drafts visible
quarto render    # build the site into _site/
```

Pushing to `main` renders and deploys the site with GitHub Actions. Posts that execute code are rendered locally first; commit the resulting `_freeze/` directory so CI doesn't need R.

Because this repo is named `blog` and the user site (`realmiketalbot.github.io`) uses the custom domain `miketalbot.io`, GitHub Pages serves it at `miketalbot.io/blog/`.

## Styling

The blog mirrors [miketalbot.io](https://github.com/realmiketalbot/realmiketalbot.github.io), and the two share no code, so changes to one need copying to the other:

- `styles/site.css` holds the colour tokens from the main site's `src/styles/global.css`, plus the header, footer, grid/hydrograph banner and post styling. `styles/light.scss` and `styles/dark.scss` feed the same colours to Quarto's Bootstrap theme.
- `_includes/header.html` and `_includes/footer.html` copy `Header.astro` and `Footer.astro` (nav links, social links, icons).
- `_includes/theme-sync.html` shares the light/dark choice with the main site through `localStorage`.

