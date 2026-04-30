# Implementation Plan: MVP Launch Readiness

**Branch**: `001-mvp-launch-readiness` | **Date**: 2026-04-30 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-mvp-launch-readiness/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

Make FormSathi launch-ready by replacing the launcher-home flow with persistent
Info, Docs, Tools, and Settings navigation; adding first-run privacy messaging,
PIN app lock, secure local storage, and delete-all-data controls; upgrading
documents to typed form records; and connecting saved documents to smart exports
for signature, passport photo, Aadhaar/PAN PDF, and certificate/marksheet PDF
targets. Standalone tools will also gain crop, custom dimensions, and target-KB
validation so saved-document and one-off workflows share the same form-ready
processing behavior.

## Technical Context

**Language/Version**: Dart SDK >=3.11.0 <4.0.0, Flutter stable  
**Primary Dependencies**: flutter_bloc Cubit, equatable, get_it, go_router, Hive,
hive_flutter, path_provider, image_picker, image, pdf, share_plus,
permission_handler, uuid, path, collection, cross_file  
**Storage**: Hive boxes for structured metadata; app-local file storage under
`app_data/documents` and `app_data/processed`; secure storage/key handling added
for app lock and encrypted sensitive data  
**Testing**: flutter_test unit/widget tests, Cubit state tests with existing
test harness patterns, plus manual device checks for camera/gallery/share,
resume import, app resume lock, and destructive data wipe  
**Target Platform**: iOS and Android mobile app  
**Project Type**: Flutter mobile app, offline-first, no backend  
**Performance Goals**: Main tab switches feel immediate; common smart exports
complete within 2 minutes; large image processing reports progress and never
silently loses originals  
**Constraints**: Offline only; no account, cloud sync, backend, premium,
reminders, checklist, broad PDF tools, favorites, or localization in this MVP
feature; preserve existing saved data through migration where possible  
**Scale/Scope**: One app with four primary tabs, 8 launch document types,
4 smart export families, existing My Info/Documents/Tools/Settings features, and
local-only storage for typical student/applicant document sets

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Offline-First Privacy**: PASS. Plan keeps all data local, adds privacy
  messaging, PIN app lock, secure local storage, and delete-all-data. No account,
  backend, cloud sync, or network behavior is planned.
- **Feature-First Clean Architecture**: PASS. Changes stay in `lib/app/`,
  `lib/core/`, and existing feature slices: `home`, `my_info`, `documents`,
  `tools`, and `settings`. Shared storage, lock, processing, and deletion helpers
  live in `lib/core/services/`; feature behavior remains behind Cubits, use
  cases, repositories, data sources, and DI.
- **Reliable Document and Media Processing**: PASS. Originals are preserved
  unless explicitly deleted. Smart exports define target document type, output
  format, size limit, crop/aspect needs, validation, and recoverable failure
  states. Generated outputs stay in app-local processed directories.
- **Testable User Journeys**: PASS. Each story maps to unit/service tests,
  Cubit tests, widget tests, and manual checks for device-only flows. Automated
  gaps are documented in quickstart.
- **Accessible Mobile UX**: PASS. Plan requires persistent bottom navigation,
  type-first document add, preview actions, privacy settings, lock states,
  loading/error/success/empty states, and reuse of the existing theme/widgets.
- **Dependencies and Permissions**: PASS WITH JUSTIFICATION. Existing camera,
  gallery, file, and share behavior remains. Secure storage/encryption and crop
  support require dependency review during implementation; additions are scoped
  to privacy and launch-critical form-ready exports.

## Project Structure

### Documentation (this feature)

```text
specs/001-mvp-launch-readiness/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── ui-flows.md
│   └── local-services.md
└── tasks.md
```

### Source Code (repository root)

```text
lib/
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── di.dart
├── core/
│   ├── enums/
│   ├── errors/
│   ├── services/
│   ├── theme/
│   ├── utils/
│   └── widgets/
└── features/
    ├── home/
    │   └── presentation/
    ├── my_info/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    ├── documents/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    ├── tools/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    └── settings/
        └── presentation/

test/
├── app/
├── core/
└── features/
    ├── my_info/
    ├── documents/
    ├── tools/
    └── settings/

android/ and ios/
└── permission or secure-storage configuration only if required
```

**Structure Decision**: Use the existing FormSathi Flutter feature-first clean
architecture. Do not create a new top-level app shell package or backend. Add a
navigation shell under `lib/app/` or `lib/features/home/presentation/` while
keeping feature page ownership in existing feature folders. Add shared services
only for cross-feature concerns such as app lock, secure storage, file wipe,
media processing, and export orchestration.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | N/A |

## Phase 0 Research Summary

See [research.md](./research.md). All technical unknowns are resolved for
planning: bottom navigation will use go_router shell-style navigation, app lock
starts with PIN, secure local data uses an encrypted local approach, document
types drive export actions, smart exports validate final size, and target-KB
processing shares one export pipeline across Docs and Tools.

## Phase 1 Design Summary

See [data-model.md](./data-model.md), [contracts/ui-flows.md](./contracts/ui-flows.md),
[contracts/local-services.md](./contracts/local-services.md), and
[quickstart.md](./quickstart.md).

## Post-Design Constitution Check

- **Offline-First Privacy**: PASS. Data model includes local privacy settings,
  lock credential metadata, secure saved documents, wipe behavior, and no remote
  entities.
- **Feature-First Clean Architecture**: PASS. Contracts define UI and local
  service boundaries without bypassing repositories/Cubits.
- **Reliable Document and Media Processing**: PASS. Export preset, processed
  output, crop request, target limits, original preservation, and failure states
  are modeled explicitly.
- **Testable User Journeys**: PASS. Quickstart lists story-level verification,
  automated checks, and manual device checks.
- **Accessible Mobile UX**: PASS. UI contracts require type-first add, preview
  actions, status feedback, lock flow, and destructive confirmation states.
- **Dependencies and Permissions**: PASS. Dependency additions are limited to
  secure storage/encryption and crop/file import support where implementation
  confirms current packages are insufficient.
