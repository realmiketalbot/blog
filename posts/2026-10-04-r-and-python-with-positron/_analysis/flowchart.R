# Draws the laptop -> login node -> compute node diagram in the site's
# light and dark colours. Run from the post folder:
#   Rscript _analysis/flowchart.R

library(grid)
library(ragg)
library(systemfonts)

# IBM Plex, as on the site, if it's installed; otherwise R's default fonts
has_plex <- any(grepl("IBM Plex Sans", system_fonts()$family))
sans <- if (has_plex) "IBM Plex Sans" else "sans"
mono <- if (has_plex) "IBM Plex Mono" else "mono"

# Colour tokens from styles/site.css
themes <- list(
  dark = list(
    fg = "#e6edf3", muted = "#a3b0bd", subtle = "#8391a0",
    surface = "#11171e", line = "#243040",
    accent = "#38bdf8", accent_soft = "#38bdf81f"
  ),
  light = list(
    fg = "#0f172a", muted = "#475569", subtle = "#64748b",
    surface = "#f6f8fa", line = "#d9dee4",
    accent = "#0369a1", accent_soft = "#0369a11a"
  )
)

nodes <- data.frame(
  x = c(0.15, 0.53, 0.845),
  title = c("Laptop", "Login node", "Compute node"),
  sub1 = c("Positron", "a doorway", "R and Python"),
  sub2 = c("the window", "nothing heavy runs here", "the data"),
  key = c(FALSE, FALSE, TRUE)
)
box_w <- 0.245
box_h <- 0.46
box_y <- 0.45

# A rounded rectangle as one closed polygon (grid.roundrect leaves a small
# notch where its outline closes). x, y and the sizes are npc; r is in points.
rounded_box <- function(x, y, width, height, r, gp) {
  corner <- function(cx, cy, from) {
    a <- seq(from, from + pi / 2, length.out = 12)
    list(x = unit(cx, "npc") + unit(r * cos(a), "pt"),
         y = unit(cy, "npc") + unit(r * sin(a), "pt"))
  }
  inset_x <- convertWidth(unit(r, "pt"), "npc", valueOnly = TRUE)
  inset_y <- convertHeight(unit(r, "pt"), "npc", valueOnly = TRUE)
  l <- x - width / 2 + inset_x; rr <- x + width / 2 - inset_x
  b <- y - height / 2 + inset_y; t <- y + height / 2 - inset_y
  cs <- list(corner(rr, b, -pi / 2), corner(rr, t, 0),
             corner(l, t, pi / 2), corner(l, b, pi))
  grid.polygon(
    x = do.call(unit.c, lapply(cs, `[[`, "x")),
    y = do.call(unit.c, lapply(cs, `[[`, "y")),
    gp = gp
  )
}

draw_diagram <- function(col) {
  grid.newpage()

  # The cluster, drawn as a dashed outline around the two nodes
  cluster_left <- 0.355
  grid.roundrect(
    x = cluster_left, y = 0.49, width = 0.63, height = 0.74, just = c("left", "centre"),
    r = unit(10, "pt"),
    gp = gpar(col = col$subtle, fill = NA, lty = "22", lwd = 1.4)
  )
  grid.text(
    "HPC CLUSTER", x = 0.375, y = 0.80, just = c("left", "center"),
    gp = gpar(fontfamily = sans, fontface = "bold",
              fontsize = 11, col = col$subtle)
  )

  # Arrows, each labelled with how the hop is made
  for (i in 1:2) {
    x0 <- nodes$x[i] + box_w / 2 + 0.012
    x1 <- nodes$x[i + 1] - box_w / 2 - 0.012
    grid.segments(
      x0, box_y, x1, box_y,
      arrow = arrow(length = unit(8, "pt"), type = "closed"),
      gp = gpar(col = col$muted, fill = col$muted, lwd = 2)
    )
    # The first arrow crosses into the cluster, so label it outside the border
    label_x <- if (x0 < cluster_left) (x0 + cluster_left) / 2 else (x0 + x1) / 2
    grid.text(
      "ssh", x = label_x, y = box_y + 0.065,
      gp = gpar(fontfamily = mono, fontsize = 13, col = col$muted)
    )
  }

  # The three machines; the compute node, where the work happens, is accented
  for (i in seq_len(nrow(nodes))) {
    n <- nodes[i, ]
    rounded_box(
      x = n$x, y = box_y, width = box_w, height = box_h, r = 8,
      gp = gpar(
        col = if (n$key) col$accent else col$line,
        fill = if (n$key) col$accent_soft else col$surface,
        lwd = if (n$key) 2.2 else 1.4
      )
    )
    grid.text(
      n$title, x = n$x, y = box_y + 0.1,
      gp = gpar(fontfamily = sans, fontface = "bold",
                fontsize = 19, col = col$fg)
    )
    grid.text(
      n$sub1, x = n$x, y = box_y - 0.03,
      gp = gpar(fontfamily = sans, fontsize = 14,
                col = if (n$key) col$accent else col$muted)
    )
    grid.text(
      n$sub2, x = n$x, y = box_y - 0.115,
      gp = gpar(fontfamily = sans, fontsize = 14,
                col = if (n$key) col$accent else col$muted)
    )
  }
}

for (theme in names(themes)) {
  agg_png(
    sprintf("images/setup-%s.png", theme),
    width = 10, height = 3.4, units = "in", res = 200,
    background = "transparent"
  )
  draw_diagram(themes[[theme]])
  invisible(dev.off())
}
