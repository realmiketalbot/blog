---
title: 'Stop submitting Slurm jobs one at a time'
subtitle: 'Use job arrays instead'
date: 2199-02-01
categories:
  - research-computing
  - how-to
---

A short how-to. One `sbatch --array` instead of a loop that submits hundreds of near-identical jobs.

Points to cover:

- `#SBATCH --array=0-199%20`: the range, and `%20` to cap how many run at once (be kind to the queue).
- `$SLURM_ARRAY_TASK_ID` to pick each task's input. A clean pattern: one YAML config per task (I generate mine from R), indexed by the task ID.
- One job ID for the whole batch: `squeue` shows it compactly, `scancel 12345_[5-10]` cancels a slice, `sacct -j 12345` reports on all of it.
- Chaining a second array with `--dependency=afterok:<jobid>` (or `aftercorr` to pair task N with task N), e.g. train then predict.
- Output files per task with `%A_%a` in `--output`.
- Why it matters: less scheduler load, easier bookkeeping, one place to change resources.

Real example to draw on: model training and prediction both run as array jobs, with prediction waiting on training via a dependency.
