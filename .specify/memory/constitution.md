<!--
Sync Impact Report
Version change: template -> 1.0.0
Modified principles:
- Template principle 1 -> I. Offline-First Privacy
- Template principle 2 -> II. Feature-First Clean Architecture
- Template principle 3 -> III. Reliable Document and Media Processing
- Template principle 4 -> IV. Testable User Journeys
- Template principle 5 -> V. Accessible Mobile UX
Added sections:
- Product and Technology Constraints
- Development Workflow and Quality Gates
Removed sections:
- None
Templates requiring updates:
- UPDATED .specify/templates/plan-template.md
- UPDATED .specify/templates/spec-template.md
- UPDATED .specify/templates/tasks-template.md
- REVIEWED .specify/templates/commands/*.md (directory absent; no command templates to update)
- REVIEWED README.md (already aligned; no edit required)
- REVIEWED form_sathi_technical_architecture.md (already aligned; no edit required)
- REVIEWED AGENTS.md (generic Spec Kit guidance remains valid; no edit required)
Follow-up TODOs:
- None
-->
# FormSathi Constitution

## Core Principles

### I. Offline-First Privacy
FormSathi MUST keep user information, documents, generated images, and PDFs on the
device by default. Features MUST work without login, backend services, cloud sync,
or network access unless a future specification explicitly justifies the exception
and documents user consent, data flow, storage location, and deletion behavior.

Rationale: The app stores form-filling identity data and personal documents for
students and job applicants, so privacy and offline reliability are product
requirements rather than implementation details.

### II. Feature-First Clean Architecture
Application code MUST follow the existing feature-first clean architecture:
presentation with Flutter UI and Cubits, domain entities/use cases/repository
contracts, and data models/data sources/repository implementations. Shared code
MUST live under `lib/core/` only when it is reused across features, and dependency
registration MUST remain centralized in `lib/app/di.dart`.

Rationale: The current structure keeps form data, document management, and tools
independently understandable while preserving simple state flows for an offline app.

### III. Reliable Document and Media Processing
Document, image, and PDF workflows MUST preserve source files unless the user
explicitly deletes them, save generated outputs in the app-local directory
structure, and surface recoverable errors in the UI. Processing features MUST
define target constraints such as dimensions, quality, file size, page order, and
output format before implementation.

Rationale: The primary user value is preparing files for real forms; silent data
loss, unclear output constraints, or broken generated files directly invalidate the
workflow.

### IV. Testable User Journeys
Every feature specification MUST define independently testable user journeys and
acceptance scenarios. Implementation plans MUST identify the Flutter test level
needed for the change: unit tests for pure domain/services, Cubit tests for state
transitions when behavior changes, widget tests for visible interaction changes,
and manual device checks for platform permissions or picker/share flows that cannot
be covered reliably in automated tests.

Rationale: User workflows such as saving personal data, previewing documents,
resizing images, and generating PDFs must remain demonstrable in isolation as the
app grows.

### V. Accessible Mobile UX
Screens and components MUST be optimized for mobile form-filling tasks: clear
labels, readable contrast, predictable navigation, copy/share affordances where
useful, empty/error/loading states, and touch targets appropriate for iOS and
Android. UI changes MUST reuse the existing theme, shared widgets, constants, and
navigation patterns unless the plan documents a deliberate design system change.

Rationale: FormSathi is used for repeated, detail-oriented tasks where clarity,
low friction, and trust matter more than decorative UI novelty.

## Product and Technology Constraints

FormSathi targets Flutter stable with Dart null safety for iOS and Android. The
approved stack is Flutter, `flutter_bloc` Cubits, `get_it`, `go_router`, Hive,
`path_provider`, `image_picker`, `image`, `pdf`, `share_plus`, and
`permission_handler`, with additions requiring plan-level justification.

Persistent app data MUST use Hive for structured metadata and app-local file
storage for documents and processed outputs. New storage locations, permissions,
or externally shared files MUST be documented in the feature plan and surfaced to
users through clear UI behavior.

The app MUST remain backend-free and account-free unless a ratified feature
explicitly changes the product direction. Any future cloud backup or sync feature
requires a constitution compliance review before planning.

## Development Workflow and Quality Gates

Feature work MUST proceed through specification, planning, and task generation
before implementation when the change affects product behavior, architecture, data
storage, permissions, or user-visible workflows. Small copy, styling, or isolated
bug fixes may proceed directly, but they still must comply with this constitution.

Each plan MUST complete a Constitution Check covering offline privacy, architecture
boundaries, document/media reliability, test strategy, mobile UX, and dependency or
permission changes. Any violation MUST be recorded in Complexity Tracking with the
simpler alternative that was rejected.

Before a change is considered complete, `flutter analyze` and the relevant
automated tests SHOULD pass. If an automated check cannot run or a platform
behavior requires manual validation, the result and remaining risk MUST be recorded
in the implementation summary.

## Governance

This constitution supersedes conflicting project guidance. Feature specifications,
plans, task lists, code reviews, and implementation summaries MUST check compliance
with the principles above.

Amendments require a written change to this file, a Sync Impact Report, and updates
to affected Spec Kit templates or runtime guidance. Versioning follows semantic
versioning: MAJOR for incompatible governance or principle redefinitions, MINOR for
new principles or materially expanded guidance, and PATCH for clarifications or
non-semantic wording changes.

Compliance is reviewed during planning and again before completion. Approved
exceptions MUST be explicit, scoped to the feature, and revisited before related
future work proceeds.

**Version**: 1.0.0 | **Ratified**: 2026-04-30 | **Last Amended**: 2026-04-30
