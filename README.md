# blog

Source for [miketalbot.io/blog](https://miketalbot.io/blog), built with [Quarto](https://quarto.org).

## Writing

- One folder per post under `posts/`, with the text in `index.md` (or `index.qmd` if it runs R code) and images alongside it.
- Unfinished posts live in `_drafts/`, which is git-ignored so drafts never reach this public repo (they exist only on your machine, so back them up separately). Loose ideas live in `_ideas/`. Quarto ignores `_`-prefixed folders, so neither shows up in the preview or on the site. To publish a draft, move its folder into `posts/` and give it a `date:`.
- Supporting analysis that shouldn't be rendered goes in a `_`-prefixed folder (e.g. `_drafts/rivers-dont-read-maps/_analysis/`). Large `.rds` data files are git-ignored.

## Style guide

Personable, not performative. Before publishing, check a post against these:

- **One idea per post.** Aim for 1,200–1,800 words. If a tangent needs a footnote to justify itself, cut it.
- **Don't take digs.** Critique ideas, not people.
- **Don't explain the joke.** If it needs explaining, cut it.
- **Show, don't vouch.** Let stories and specifics carry your experience; skip lines that assess your own skills.
- **Leave politics out** unless it's what the post is about.
- **Check the facts in the asides.** Throwaway numbers and definitions need the same care as the main argument.
- **Draft fast, publish slow.** Leave at least a day between finishing a draft and publishing it, then reread it top to bottom.

## Building

```sh
quarto preview                            # local preview of the site with live reload
quarto render _drafts/<post>/index.md     # render one draft next to its source (never added to the site),
                                          # then open _drafts/<post>/index.html; `quarto preview` fails on drafts
quarto render                             # build the site into _site/
```

Pushing to `main` renders and deploys the site with GitHub Actions. Posts that execute code are rendered locally first; commit the resulting `_freeze/` directory so CI doesn't need R.

Because this repo is named `blog` and the user site (`realmiketalbot.github.io`) uses the custom domain `miketalbot.io`, GitHub Pages serves it at `miketalbot.io/blog/`.

## Styling

The blog mirrors [miketalbot.io](https://github.com/realmiketalbot/realmiketalbot.github.io), and the two share no code, so changes to one need copying to the other:

- `styles/site.css` holds the colour tokens from the main site's `src/styles/global.css`, plus the header, footer, grid/hydrograph banner and post styling. `styles/light.scss` and `styles/dark.scss` feed the same colours to Quarto's Bootstrap theme.
- `_includes/header.html` and `_includes/footer.html` copy `Header.astro` and `Footer.astro` (nav links, social links, icons).
- `_includes/theme-sync.html` shares the light/dark choice with the main site through `localStorage`.

