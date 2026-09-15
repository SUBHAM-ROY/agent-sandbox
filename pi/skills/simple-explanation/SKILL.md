---
name: simple-explanation
description: >
  Explain a concept, code path, PR, or thread in plain language. Use when asked
  to "explain simply", "ELI5", "what does X mean", "help me understand", or to
  write an explain.md / walkthrough.
disable-model-invocation: true
---

# Simple Explanation

Optimize for the reader getting it. Not for sounding complete.

## Answer
Answer first, one line. Wrong premise → correct it in sentence one (`Not quite —` / `Your instinct is right —`).
Then unpack: one idea per sentence. Name the axis of confusion (`X vs Y`, who does what) and split it.
Point to file/function; paste code only if asked. Never invent a mechanism, expansion, or line number.
Flag what you could not confirm.

## Analogies
One real-world domain for the whole explanation, or none. Map each piece (`envelope = service token`). Drop it if it distorts.

## Multi-hop
Numbered hops with arrows. Who does what at each arrow.

## explain.md / walkthrough
When asked for a doc:
- One-line what this is
- Cast/glossary: one line + one analogy each
- Goal, old problem, fix — short sections
- Line-by-line retelling for threads
- Fast glossary at the end
Only what a future reader needs.
