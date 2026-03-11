# Repository Instructions

## Goal

This repository is a chat-driven research sandbox for:

- reproducing code and claims from papers
- testing GPU features, kernels, compilers, and libraries
- keeping a durable written record of every task

## Required Workflow For Codex

When the user asks for work in this repository, follow this sequence unless there is a strong reason not to:

1. Open or reuse a task under `tasks/active/`.
2. Record the task in `tasks/index.md`.
3. Put code and experiment-specific assets under `experiments/papers/` or `experiments/gpu/`.
4. Persist operational notes in the task folder instead of leaving details only in chat.
5. Update `logs/activity.md` when a task is opened or closed.
6. When a task is self-contained and complete, move it to `tasks/completed/` and mark the index accordingly.

## Task Folder Contract

Each task folder should contain:

- `plan.md`: scope, acceptance criteria, execution plan
- `notes.md`: commands run, observations, blockers, decision log
- `result.md`: concise outcome, artifact paths, next actions

Optional files:

- `env.md`: environment snapshot
- extra task-specific scratch files if they help the work

## Experiment Placement Rules

- Paper reproductions go under `experiments/papers/<paper-slug>/`
- GPU feature tests go under `experiments/gpu/<feature-slug>/`
- Reusable utilities can live in `scripts/` or a clearly named shared directory

Do not leave runnable code only inside a task folder if it is part of a reusable experiment.

## Recording Rules

For paper reproduction work, capture:

- paper title and target figure/table/claim
- source repository or reference implementation
- exact commit/tag/version when known
- environment details that affect reproducibility
- pass/fail status and blockers

For GPU feature work, capture:

- GPU model
- driver/CUDA/runtime version
- framework/library version
- feature under test
- benchmark or validation command
- observed behavior and limitations

## Operating Style

- Favor small, durable checkpoints over ad hoc exploration
- Keep experiment READMEs current when behavior changes
- Summarize failures clearly; failed repros are still useful outputs
- Do not delete prior notes unless they are plainly wrong and replaced
- Prefer appending dated notes over rewriting history

## Commit Guidance

- Prefer one commit per stable task checkpoint
- Do not commit large binary artifacts unless the user asks for it
- Keep generated outputs in `artifacts/` or external storage when they are too large
