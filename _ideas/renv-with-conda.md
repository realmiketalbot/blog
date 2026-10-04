---
title: 'renv inside a conda environment'
subtitle: 'Who owns which packages when R comes from conda'
date: 2199-02-01
categories:
  - research-computing
---

Follow-up to the Positron-on-HPC post. Conda supplies R and the compiled C libraries (GDAL, PROJ, GEOS); renv pins the R packages per project. The trap: renv's cache can shadow conda's copy of a compiled package. Real example: `sf.so` loaded from `~/.cache/R/renv/...` failed with `libgdal.so.38: cannot open shared object file` even though that exact library was in the env. Conda-forge's `sf.so` carries a relative RPATH to the env's `lib/` (verified with `readelf -d`); the renv-compiled copy probably didn't (unverified).

Options to cover: renv external libraries pointing at the conda library plus ignored packages, vs. rebuilding from source against the env, vs. recreating the env. Which split did the other project settle on? Its `.Rprofile`/`renv/settings.json` will show.

