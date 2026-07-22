# Flutter Code Review Skill

This skill defines a structured self-review checklist for Flutter projects using clean architecture, Cubit state management, and Firebase.

It is used to verify code quality, correctness, and safety before completing a task or opening a PR.

---

## When to use this skill

Use this skill when:

- user says "task done"
- user says "work is done"
- user says "finished"
- user requests "review this"
- before commit or PR
- verifying implementation correctness

---

## Review Mode

This is a **read-only review process**.

Do NOT modify code.

Use:

- git diff
- git status
- project files
- existing architecture rules

---

## Checklist

## 1 — Correctness

- Root cause is correctly identified and fully fixed
- Solution matches the task requirements
- Edge cases handled:
  - null
  - empty
  - loading
  - error states
- No silent failures
- Errors propagate properly through layers

---

## 2 — Architecture Compliance

- Clean architecture is respected:
  - presentation → domain → data
- No business logic in UI layer
- Cubits depend on use cases only
- Domain layer has NO Flutter imports
- Shared logic is in `core/`
- No duplicated logic across features

---

## 3 — Safety

- No breaking existing features or flows
- No performance regressions:
  - unnecessary rebuilds
  - missing const usage
  - heavy build methods
- No security issues:
  - hardcoded secrets
  - unsafe input handling
  - sensitive logs
- No unused imports or dead code
- Controllers and focus nodes properly disposed

---

## 4 — Code Quality

- Code is readable and clean
- Functions and files are small and focused
- No unnecessary duplication
- Dart naming conventions followed
- Imports are clean and ordered

---

## Output Format

After review, respond with:

```md
## Review Summary
PASS / NEEDS_CHANGES

## What changed
- ...

## Why it changed
- ...

## Safety & correctness
Explain why the solution is safe and correct

## Checklist result

### Correctness
PASS / FAIL

### Architecture
PASS / FAIL

### Safety
PASS / FAIL

### Code Quality
PASS / FAIL

## Action items (if any)
1. ...
```