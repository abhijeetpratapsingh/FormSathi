# Local Service Contracts: MVP Launch Readiness

These contracts define local application boundaries for implementation planning.
All services are offline-only.

## Privacy and Lock Service

Responsibilities:
- Read/write privacy settings.
- Set up, verify, change, and disable PIN lock.
- Determine whether the app is locked.
- Record unlock time and evaluate inactivity timeout.

Inputs:
- PIN entry and confirmation
- App lifecycle events
- User settings actions

Outputs:
- Lock state: locked, unlocked, setupRequired, disabled
- User-safe failure messages

Rules:
- Raw PIN is not persisted.
- Enabling lock requires confirmed PIN.
- Disabling lock requires verification or destructive reset.

## Secure Local Storage Service

Responsibilities:
- Provide encrypted/protected metadata storage where required.
- Manage local protection key lifecycle.
- Support migration from existing plain records where possible.

Inputs:
- Existing My Info, document, and processed-file records
- Privacy setting state

Outputs:
- Opened secure boxes or equivalent protected storage handles
- Migration result with success/failure counts

Rules:
- Failed migration must not delete existing readable data.
- No remote storage is introduced.

## Document Repository Contract

Responsibilities:
- Save typed document records.
- Read/filter/search documents.
- Update title, type, side/page metadata, and notes.
- Delete document record and file.
- Support migration from category-only records.

Inputs:
- Saved Document
- Document type assignment
- Metadata updates

Outputs:
- Sorted document list
- Saved document detail
- Delete result

Rules:
- Existing document ids remain stable during migration.
- Missing file paths surface recoverable errors.

## Export Orchestration Service

Responsibilities:
- Convert document preview actions and standalone tool actions into export
  requests.
- Apply crop, resize, compression, PDF generation, and target-size validation.
- Save generated output and recent processed file metadata.

Inputs:
- Export Request
- Export Preset
- Saved Document sources or standalone paths

Outputs:
- Processed Output
- Final size and dimensions/page count when available
- User-safe failure when target cannot be met

Rules:
- Source files are read-only during export.
- Success with a target requires final size at or below the target.
- Failure preserves original files and any existing successful outputs.

## Local Data Wipe Service

Responsibilities:
- Delete My Info records.
- Delete document records and files.
- Delete processed output records and files.
- Reset privacy and lock state as required for a clean app.

Inputs:
- Explicit user confirmation

Outputs:
- Wipe Result

Rules:
- Wipe is never started from a non-confirmed tap.
- Partial failures are reported and can be retried.
- App surfaces empty Info, Docs, and recent processed lists after success.
