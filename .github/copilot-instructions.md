# Copilot Project Instructions

Purpose: SafeTravel App – multi-step safety registration flow (Flutter) with structured feature folders. Keep contributions consistent, minimal, and incremental.

## Architecture & Structure
- Entry point: `lib/main.dart` sets global `ThemeData` (seed color `0xFF0D47A1`, fontFamily `Inter` assumed) and launches `RegistrationScreen`.
- Feature-first layout: `lib/features/<domain>/presentation/...` currently only `auth` with multi-step registration widgets.
- Reusable UI primitives live under `lib/core/widgets/` (many stubs are empty and intended for extension: `custom_text_field.dart`, `custom_button.dart`, `step_icon.dart`). Prefer filling these before scattering one-off UI logic.
- Step workflow: `RegistrationScreen` maintains `_currentStep` + a `PageController` and a fixed ordered list of step widgets (`StepPersonal`, `StepTravel`, `StepEmergency`, `StepHealth`). Navigation uses `animateToPage`; last step routes to `RegistrationCompleteScreen` (not yet inspected—create if missing before wiring new steps).
- Progress indication: `stepper_progress.dart` exists but is empty. Implement centralized progress UI there (accepts `currentStep` and derive total from list length).

## Current Gaps / Intentional Stubs
- Empty widget files in `core/widgets` and some step widgets (`step_emergency.dart`, `step_health.dart`). When implementing, keep styling consistent with existing InputDecoration & button theming.
- No data layer (no repositories, models, state management). If adding, start with lightweight plain Dart models inside `lib/features/auth/domain/models/` and keep state local or via `ChangeNotifier` before introducing heavier solutions.

## UI & Styling Conventions
- Colors: Primary Deep Blue `Color(0xFF0D47A1)`, secondary `0xFF42A5F5`, neutral surfaces `0xFFF4F6F8`, white cards, light grey borders `Colors.grey.shade300`.
- Buttons: Use `ElevatedButton` styled globally. For secondary actions (back), use `OutlinedButton` with grey border. Avoid inlining custom styles—extend global themes if variation is needed.
- Text inputs: Always use `CustomTextField` (fill this abstraction instead of adding raw `TextField`s). Honor existing padding and border radius (8). Add suffix icons via parameters.

## Adding a New Registration Step (Example Pattern)
1. Create `step_<name>.dart` under `auth/presentation/widgets/` returning a `SingleChildScrollView` with padded Column (follow `StepPersonal`).
2. Insert it into the `_steps` list in `RegistrationScreen` maintaining logical order.
3. Update progress indicator logic in `StepperProgress` if you add dynamic labeling.
4. Keep each step self-contained; cross-step shared validation belongs in a forthcoming controller (do not prematurely add global state).

## Navigation & Flow
- Forward/back handled internally—do not expose global navigation helpers for steps.
- Completion uses `Navigator.pushReplacement` to a completion screen: maintain replacement semantics to prevent back navigation into wizard.

## Assets & Fonts
- Images + fonts declared under `assets/images/` and `assets/fonts/` in `pubspec.yaml`. Use relative asset references. Add new asset folders by updating `pubspec.yaml` once—avoid hardcoding paths outside assets root.

## Linting & Quality
- Lints: Default `flutter_lints` only. Before proposing code that violates style, prefer following existing patterns (e.g., double quotes currently used in `pubspec.yaml`, Dart files mostly use single quotes—stay consistent per file).
- Run locally: `flutter analyze` and `flutter test` (only default widget test present). Add focused tests under `test/` for any non-trivial logic you introduce.

## Safe Changes Guidance
- Prefer extending empty stubs rather than introducing new parallel widgets doing the same job.
- Keep state local unless 2+ sibling steps require shared mutation; then introduce a lightweight state holder (e.g., `RegistrationData` model passed via InheritedWidget/Provider—document reasoning in PR).
- Avoid premature package additions; core dependencies are minimal (`flutter_svg`, `cupertino_icons`). Justify any new dependency in PR notes.

## Commit & PR Tips for Agents
- One logical concern per PR (e.g., “Implement StepEmergency UI” or “Add reusable CustomTextField implementation”).
- Include a concise summary of user-visible changes plus any follow-up TODOs left inline as `// TODO(username):` comments.

## Quick Checklist Before Submitting
- [ ] No raw `TextField`/`ElevatedButton` styling duplication—use abstractions or theme.
- [ ] New step added to `_steps` and progress reflects correct total.
- [ ] Navigation still prevents swiping (PageView has `NeverScrollableScrollPhysics`).
- [ ] Analyzer passes; no unused imports.

Clarify any missing patterns before broad refactors; this document should track real (not aspirational) conventions.
