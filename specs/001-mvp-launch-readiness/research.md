# Research: MVP Launch Readiness

## Decision: Use Persistent Bottom Navigation with Route-State Preservation

Rationale: The current home card launcher adds a step for repeated use. The app
already uses named routes for Info, Docs, Tools, and Settings, so a shell-style
navigation surface can preserve the existing page ownership while making the
primary areas reachable in one tap.

Alternatives considered:
- Keep home cards and add shortcuts: rejected because it does not solve repeated
  navigation friction.
- Replace routing entirely: rejected because existing go_router usage is adequate
  and lower-risk to evolve.

## Decision: Make PIN App Lock the MVP Privacy Baseline

Rationale: PIN lock is required by the spec and has predictable behavior across
iOS and Android. Biometric unlock can be layered on later if it does not delay
the baseline. Lock should gate sensitive Info and Docs content on cold start and
after inactivity when enabled.

Alternatives considered:
- Biometric-only lock: rejected because not every device or user supports it.
- No app lock with only masking: rejected because documents and full personal
  details remain visible.

## Decision: Secure Local Data with Encrypted Metadata and Protected Files

Rationale: The constitution requires offline privacy and the spec calls for
secure local storage. Hive metadata boxes should be opened with encryption where
practical, using a locally protected key. Saved document and processed files need
protection appropriate for app-local data; implementation should either encrypt
file contents or store them in a protected app directory with an encryption path
for sensitive document files.

Alternatives considered:
- Plain Hive plus app lock: rejected because app lock alone does not protect
  stored metadata if app data is inspected.
- Cloud or account backup: rejected as out of scope and contrary to the MVP
  privacy model.

## Decision: Introduce Typed Document Records Rather Than Only Categories

Rationale: The current `DocumentCategory` gives labels but does not drive
metadata or export behavior. A document type concept must map Signature,
Passport Photo, Aadhaar, PAN, Marksheet, Certificate, Resume, and Other to
allowed sources, optional side/page metadata, and smart export presets.

Alternatives considered:
- Extend category labels only: rejected because export behavior would remain
  scattered and fragile.
- Create separate document models per type: rejected for MVP because shared
  fields and migrations are simpler with a typed record plus optional metadata.

## Decision: Share One Target-KB Export Pipeline Across Docs and Tools

Rationale: Saved-document smart exports and standalone tools both need crop,
resize, compress, validate final size, save output, and show final size. A shared
processing service reduces inconsistent output behavior and keeps original files
preserved.

Alternatives considered:
- Add separate algorithms in each page: rejected because target-size rules would
  diverge.
- Quality-only presets: rejected because online forms usually specify maximum KB.

## Decision: Use Type-Specific Preview Actions as the Primary Smart Export Entry

Rationale: Users should not jump from a saved document to generic tools. Preview
actions can show only relevant exports, for example Signature under 20 KB or
Aadhaar/PAN PDF, while keeping Tools available for one-off files.

Alternatives considered:
- Keep all exports under Tools: rejected because it makes the document vault feel
  disconnected from form-ready outputs.
- Auto-export on save: rejected because users often need to inspect/crop/choose
  pages before generating an upload file.

## Decision: Keep Deferred Feature Classes Out of MVP Implementation

Rationale: Backup/export vault, localization, favorites, premium, reminders,
checklists, and broad PDF utilities do not block launch readiness and would
increase scope. Settings should remove the visible future-scope section because
it makes the app look unfinished.

Alternatives considered:
- Include all gap-analysis P1/P2 items now: rejected because it dilutes the
  P0 launch blockers.
- Leave future scope visible: rejected because it does not help users complete
  forms or build trust.
