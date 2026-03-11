# Workflow

## 1. Open a task

Create a task folder as soon as the user gives a concrete instruction.

```bash
./scripts/new_task.sh "<task title>" <paper|gpu|general> [slug]
```

This creates:

- `tasks/active/<task-id>/plan.md`
- `tasks/active/<task-id>/notes.md`
- `tasks/active/<task-id>/result.md`

It also appends an entry to `tasks/index.md` and `logs/activity.md`.

If the title is mostly non-ASCII text, pass an explicit ASCII slug as the third argument when you care about the experiment directory name.

## 2. Place the runnable work

- Paper reproduction code belongs in `experiments/papers/<paper-slug>/`
- GPU probes and benchmarks belong in `experiments/gpu/<feature-slug>/`

Recommended experiment structure:

- `README.md`: scope, status, how to run, current findings
- `src/`: code
- `configs/`: configs if needed
- `notes/`: extra supporting notes

## 3. Record execution details

Use the task files consistently:

- `plan.md`: what success means
- `notes.md`: commands, observations, blockers, data points
- `result.md`: short conclusion and next step

When environment details matter:

```bash
./scripts/capture_env.sh tasks/active/<task-id>/env.md
```

## 4. Close the task

When the work is complete enough to stand on its own:

```bash
./scripts/close_task.sh <task-id>
```

This moves the task to `tasks/completed/`, updates the task index, and appends a close event to the activity log.

## Practical rules

- If a user request spans multiple experiments, keep one main task and link the related experiment paths in `plan.md`.
- If a task is blocked, document the blocker and leave the task in `tasks/active/`.
- If results are partial but useful, write them up anyway and mark the remaining gap explicitly.
