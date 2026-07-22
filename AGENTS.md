# AGENTS.md

Guidance for coding agents working in this repository.

## What to optimize for
- Make the smallest change that solves the request.
- Keep changes consistent with the existing Flutter and RTL-friendly architecture.
- Prefer working inside the owning feature instead of making broad cross-cutting edits.
- Avoid refactoring unrelated code unless the user explicitly asks.

## Project rules to follow
- Presentation, domain, and data responsibilities must stay separated.
- Use `get_it` for dependency injection.
- Keep shared code in `lib/core/` when it is reused in multiple places.
- Use `EdgeInsetsDirectional` and other RTL-safe APIs for UI work.
- Use `flutter_bloc`/`Cubit` for feature state, not new state libraries.
- Do not introduce `Freezed` or `build_runner` patterns for new code.

## Before editing
- Inspect the nearest file, feature, or failing behavior first.
- Form one local hypothesis about what controls the behavior.
- Choose the smallest edit that can validate that hypothesis.

## Validation
- After edits, run the narrowest useful check first.
- Prefer a focused test, analyzer run, or format pass over broad validation.
- If a change touches Flutter UI, check the affected feature path first.

## Good places to look
- `CLAUDE.md` for strict repo rules.
- `.github/copilot-instructions.md` for Copilot-specific guidance.
- `lib/core/di/` for dependency registration.
- `lib/core/routing/` for navigation.
- `lib/features/` for feature-specific implementations.

## Output expectations
- Report exactly what changed.
- Call out any validation you could not run.
- Mention residual risks only if they matter to the requested change.
