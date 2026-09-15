---
name: review-pr
description: >
  Review this branch's diff against master/main. Use when asked to review a PR,
  review changes, check the diff, or comment on code quality.
disable-model-invocation: true
---

# Review PR

Prioritized review. Write files, not a chat dump.

## Base
`origin/master` if it exists, else `origin/main`.
If `review.md` has `**Reviewed:** \`<sha>\``, this is a re-review: diff `<sha>...HEAD` instead.

## Diff
`git diff <base>...HEAD --stat`, then the full diff. Then read every changed file in full — hunks are not enough.

## Re-review
Report only what changed since `<sha>`. Carry each prior finding as fixed / unfixed / superseded; list new findings separately. Don't re-list unchanged findings in full.
`files.md`: add/update only files touched since `<sha>`; leave the rest.
Mark every "since `<sha>`" addition as its own italic paragraph.
At most two parts: up through the previous sha, and what's new. Before the new italic block, fold the old italic "since" into the regular body.

## Findings → `review.md`
Header: `**Reviewed:** \`<sha>\`` (`git rev-parse HEAD`).
Severity: **RED** must-fix (bugs, data loss, security, silent prod fail) · **ORANGE** should · **YELLOW** consider · **GREEN** nit.
Each comment: file + line range, snippet, issue, suggested fix. Be detailed; don't collapse distinct issues.
End with what the PR does well, if it does.

## Overview → `files.md`
3–5 sentences from the code, not the PR description or commits. Problem + mechanism.
Then 2–3 lines per file, story order: entry → wiring → core → tests → docs.

## Chat
Point at `review.md` and `files.md`. Do not paste them.
