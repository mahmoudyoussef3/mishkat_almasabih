# Testing

This guide describes the testing approach for the Mishkat Al-Ahadith Flutter app.

## Test goals

Tests should protect the parts of the app that are easiest to break and hardest to notice by eye:

- domain and business logic
- repository and data mapping behavior
- Cubit state transitions
- critical widget rendering and RTL layout

## What to test

### Unit tests
Use unit tests for pure Dart logic.

Good candidates include:

- use cases
- validators
- model mapping
- repository logic that can be isolated from Flutter UI

### Cubit tests
Test feature state changes when the state is driven by input or async work.

Verify:

- initial state
- loading state
- success state
- error state
- edge cases such as empty data or invalid input

### Widget tests
Use widget tests for UI that matters to users or is likely to regress.

Good targets include:

- screens with conditional rendering
- RTL-sensitive layouts
- reusable cards, rows, and list items
- components that depend on Cubit state

### Manual checks
Some flows are easier to confirm manually than by automated tests.

Examples:

- navigation flows
- Arabic layout correctness
- responsive breakpoints
- notification or platform-specific behavior

## Repo layout

The repository already has a focused `test/core/` area and a large `lib/features/` tree.

A practical rule is:

- keep feature tests close to the feature they cover when that structure already exists
- put shared test helpers in `test/core/`
- avoid inventing a new test layout if the current one already works for the area you are touching

## Test priorities

If you can only test a small slice, prioritize in this order:

1. business logic
2. data mapping and repository behavior
3. Cubit state transitions
4. widget rendering for critical screens

## Writing good tests

- One behavior per test case.
- Keep tests deterministic.
- Do not rely on timing, random data, or external services.
- Mock boundaries such as APIs, storage, and platform services.
- Assert the state or output that matters to the user, not implementation details.

## Validation workflow

For a normal change, prefer this order:

1. format the changed files if needed
2. run the narrowest affected tests
3. run a broader test or analyzer pass only if the narrow check fails or the change is risky

## Notes for this repo

- Favor tests around features with business rules, such as search, hadith data, prayer times, reminders, and authentication.
- If a bug fix changes behavior, add or update a test that reproduces the issue first.
- Keep test helpers lightweight and reusable.
