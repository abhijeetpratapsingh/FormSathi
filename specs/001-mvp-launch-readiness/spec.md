# Feature Specification: MVP Launch Readiness

**Feature Branch**: `001-mvp-launch-readiness`  
**Created**: 2026-04-30  
**Status**: Draft  
**Input**: User description: "Implement all pending MVP gaps from the gap analysis: bottom navigation, onboarding/privacy, document type-driven smart exports, app lock, encryption or secure storage, delete-all-data, crop flows, target-KB compression, PDF export presets, settings cleanup, and related P0/P1 launch readiness improvements."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Navigate Core Areas Quickly (Priority: P1)

As a returning FormSathi user, I want persistent access to Info, Docs, Tools, and
Settings so I can move between repeated form-filling tasks without returning to a
launcher screen.

**Why this priority**: Frequent use is the app's core behavior. Extra navigation
steps make copying information, finding documents, and exporting files slower.

**Independent Test**: A user can open the app, switch between the four primary
areas from any main tab, and return to the previous task context without using a
home card launcher.

**Acceptance Scenarios**:

1. **Given** the user has completed first-run setup, **When** the app opens,
   **Then** the user sees persistent tabs for Info, Docs, Tools, and Settings.
2. **Given** the user is viewing a saved document, **When** they switch to Tools
   and return to Docs, **Then** the document context remains easy to resume.

---

### User Story 2 - Trust the Offline Privacy Model (Priority: P1)

As a user storing personal details and documents, I want clear privacy messaging,
app lock, secure local storage, masking, and delete-all-data controls so I can
trust the app with sensitive form data.

**Why this priority**: Privacy is a launch blocker because the app stores identity
details and personal documents.

**Independent Test**: A first-time user can understand that data stays on the
device, enable a PIN lock, see sensitive identifiers masked by default, unlock the
app after restart, and wipe local data from Settings.

**Acceptance Scenarios**:

1. **Given** a first-time user opens the app, **When** the privacy intro appears,
   **Then** it explains offline storage, app lock, deletion, and no account/cloud
   requirement in plain language.
2. **Given** app lock is enabled, **When** the app is opened from a cold start or
   resumed after the lock timeout, **Then** the user must unlock before viewing
   Info or Docs content.
3. **Given** a user chooses delete all data, **When** they confirm the destructive
   action, **Then** all saved personal info, document records, stored files, and
   processed outputs are removed from the app.

---

### User Story 3 - Add Typed Form Documents (Priority: P1)

As a student or applicant, I want to save documents by type such as Signature,
Passport Photo, Aadhaar, PAN, Marksheet, Certificate, and Resume so FormSathi can
offer the right actions for each item.

**Why this priority**: Generic categories are not enough for form-ready exports;
document type must drive guidance, metadata, and export actions.

**Independent Test**: A user can start from Docs, choose a document type first,
capture or import the file, review type-specific details, and save a record that
shows relevant actions in preview.

**Acceptance Scenarios**:

1. **Given** the user taps Add in Docs, **When** the add flow starts, **Then** the
   user chooses a document type before choosing camera, gallery, or file source.
2. **Given** the user saves an Aadhaar or PAN document, **When** they review it,
   **Then** the record supports front/back or page-side information where useful.
3. **Given** a user saves a certificate or marksheet, **When** they view metadata,
   **Then** file size, date added, and optional notes are available.

---

### User Story 4 - Export Common Form Files from Preview (Priority: P1)

As a user preparing an online form, I want one-tap smart exports from saved
document preview so I can create accepted files without manual trial and error.

**Why this priority**: Smart export is the core promise that turns stored
documents into form-ready outputs.

**Independent Test**: From a saved document preview, a user can export a signature
under 20 KB, passport photo under 50 KB, Aadhaar/PAN PDF, and certificate or
marksheet PDF under 300 KB, then share or save the result.

**Acceptance Scenarios**:

1. **Given** a saved Signature document, **When** the user chooses the under-20KB
   export, **Then** the app produces a file that reports success only if it meets
   the target size.
2. **Given** a saved Passport Photo document, **When** the user exports under
   50 KB, **Then** the user can crop or adjust the image before export and sees
   whether the result meets the target.
3. **Given** saved Aadhaar or PAN pages, **When** the user exports as PDF,
   **Then** the app creates a shareable PDF from the selected sides/pages.
4. **Given** a saved Certificate or Marksheet document, **When** the user exports
   PDF under 300 KB, **Then** the output is validated against the target before
   success is shown.

---

### User Story 5 - Use Improved Standalone Tools (Priority: P2)

As a user who has files outside the document vault, I want improved image resize,
compress, crop, and image-to-PDF tools with target file-size options so I can fix
one-off form uploads without saving every file as a document first.

**Why this priority**: Independent tools are already part of the MVP and should
match common form constraints, but saved document smart exports are higher
priority.

**Independent Test**: A user can open Tools, choose an image or multiple images,
crop when needed, set a target size such as 20 KB, 50 KB, 100 KB, or 300 KB, and
receive a validated output or a clear failure message.

**Acceptance Scenarios**:

1. **Given** a user opens Compress Image, **When** they choose a target size,
   **Then** the result states whether the output is within the target.
2. **Given** a user opens Resize Image, **When** they enter custom dimensions and
   a target size, **Then** the output respects the selected dimensions and reports
   the final size.
3. **Given** a user creates a PDF from images, **When** the selected images are
   likely to exceed the target, **Then** the user can compress before saving or
   receives a clear warning.

### Edge Cases

- The selected file is too large, corrupted, unsupported, or cannot be read.
- Compression cannot meet the requested target without unacceptable quality loss.
- The user cancels camera, gallery, file selection, crop, unlock, or delete flows.
- The device has low storage while saving generated files.
- The user forgets the app lock PIN and must reset the app by deleting local data.
- Sensitive values are present but empty, partially entered, or too short for
  last-4 masking.
- A multi-page export is missing a required side/page.
- The user attempts to share an output before generation completes.
- Existing saved documents have only generic categories and need a default type
  mapping or migration path.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The app MUST replace the main home-card launcher with persistent
  primary navigation for Info, Docs, Tools, and Settings.
- **FR-002**: The app MUST show a lightweight first-run privacy introduction that
  explains offline storage, no account requirement, app lock, delete controls, and
  how generated files are stored.
- **FR-003**: The app MUST provide a Settings privacy area with app lock controls,
  privacy explanation, delete-all-data action, and no visible future-scope
  marketing section.
- **FR-004**: The app MUST allow users to enable, verify, change, and disable a
  PIN-based app lock.
- **FR-005**: The app MUST protect sensitive Info and Docs content behind the app
  lock on app start and after a reasonable inactivity timeout when lock is enabled.
- **FR-006**: The app MUST mask sensitive identifiers by default using a readable
  last-4 style where applicable, while still allowing deliberate copy actions.
- **FR-007**: The app MUST store personal details, document metadata, and local
  document files using secure local storage appropriate for sensitive offline
  data.
- **FR-008**: The app MUST allow users to delete all local personal info,
  document records, document files, and processed outputs after explicit
  confirmation.
- **FR-009**: The document add flow MUST start with document type selection before
  source selection.
- **FR-010**: The app MUST support launch-critical document types: Signature,
  Passport Photo, Aadhaar, PAN, Marksheet, Certificate, Resume, and Other.
- **FR-011**: Document records MUST include type, title, file reference, date
  added, file size when available, and optional notes.
- **FR-012**: Document records for identity documents MUST support side/page
  information where front/back or multiple pages are relevant.
- **FR-013**: The document preview MUST show relevant metadata and actions for
  export, share, rename, delete, and type-appropriate processing.
- **FR-014**: Signature documents MUST support crop and export under 20 KB.
- **FR-015**: Passport Photo documents MUST support crop/aspect adjustment and
  export under 50 KB.
- **FR-016**: Aadhaar and PAN documents MUST support export to a shareable PDF
  from selected saved side/page images.
- **FR-017**: Marksheet and Certificate documents MUST support export to a
  shareable PDF under 300 KB.
- **FR-018**: Smart export results MUST show final file size and must not report
  success unless the requested size target is met.
- **FR-019**: If a target size cannot be met, the app MUST explain the failure in
  user-friendly language and preserve the original saved document.
- **FR-020**: Standalone image compression MUST support target-size presets for
  20 KB, 50 KB, 100 KB, and 300 KB, plus the existing quality-oriented choices.
- **FR-021**: Standalone image resize MUST support custom dimensions and optional
  target-size validation.
- **FR-022**: Standalone image-to-PDF MUST allow users to review selected pages,
  understand expected output size, and compress images before saving when needed.
- **FR-023**: The app MUST keep existing acceptable MVP behavior: per-field copy,
  copy-all, local document search/filter, basic preview, image-to-PDF creation,
  and recent processed files.
- **FR-024**: The app MUST standardize user-safe error messages and retry or
  cancel paths for file picking, processing, sharing, storage, and lock flows.
- **FR-025**: The app MUST avoid adding cloud backup, premium features,
  reminders, checklist features, favorites, broad PDF utilities, or localization
  as part of this MVP readiness feature.

### Constitution Requirements *(mandatory)*

- **Offline & Privacy**: The feature stores personal data, document metadata,
  saved document files, and generated outputs locally only. No account, backend,
  cloud, sync, or network behavior is included. Users can delete all local app
  data from Settings after confirmation.
- **Architecture Boundaries**: The feature affects the app's primary navigation,
  Info privacy behavior, document vault, document preview, standalone tools,
  app start/lock experience, and Settings controls.
- **Document/Media Handling**: Supported inputs include camera/gallery images and
  imported local files where relevant. Outputs include compressed images, resized
  images, and PDFs with target limits for signature, photo, Aadhaar/PAN, and
  certificate/marksheet workflows. Originals must be preserved unless the user
  deletes them.
- **Mobile UX & Accessibility**: Main flows require empty, loading, success,
  error, locked, and destructive-confirmation states. Actions must be reachable
  from mobile document preview without forcing users through standalone tools.
- **Testability**: Each priority story is independently verifiable through the
  acceptance scenarios above. Device-only flows such as camera/gallery selection,
  file sharing, and unlock-on-resume require manual validation in addition to
  automated checks where practical.

### Key Entities *(include if feature involves data)*

- **Document Type**: A supported form document classification such as Signature,
  Passport Photo, Aadhaar, PAN, Marksheet, Certificate, Resume, or Other. It
  determines metadata prompts and available export actions.
- **Saved Document**: A locally stored document record with type, title, file
  reference, date added, size details, optional side/page information, and notes.
- **Export Preset**: A named output target such as Signature under 20 KB,
  Passport Photo under 50 KB, Aadhaar/PAN PDF, or Certificate PDF under 300 KB.
- **Processed Output**: A generated image or PDF with source document reference,
  output type, final file size, creation date, and share/save status.
- **Privacy Settings**: User-controlled settings for first-run privacy
  acknowledgment, app lock status, lock timeout, and local data deletion.
- **App Lock Credential**: A local unlock credential used to protect sensitive app
  areas when app lock is enabled.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Returning users can reach Info, Docs, Tools, or Settings in one tap
  from the main app surface.
- **SC-002**: At least 95% of test users can explain where their data is stored
  and how to delete it after completing first-run setup.
- **SC-003**: Users can enable app lock and successfully unlock the app after a
  restart in under 30 seconds.
- **SC-004**: Users can add a Signature, Passport Photo, Aadhaar/PAN, and
  Certificate/Marksheet document type from Docs without using standalone tools.
- **SC-005**: Users can export a saved Signature under 20 KB and Passport Photo
  under 50 KB from document preview in under 2 minutes each, excluding initial
  capture time.
- **SC-006**: Users can export Aadhaar/PAN and Certificate/Marksheet PDFs from
  saved documents with clear success or failure feedback and no loss of originals.
- **SC-007**: At least 90% of supported smart export attempts either meet the
  selected size target or return a clear, actionable explanation.
- **SC-008**: Users can delete all local app data from Settings and verify that
  Info, Docs, and recent processed outputs are empty afterward.
- **SC-009**: Independent tool users can choose target sizes for compression and
  understand final output size before sharing or saving.
- **SC-010**: Existing acceptable MVP flows remain available and do not require
  more steps than before except where app lock is deliberately enabled.

## Assumptions

- The MVP will prioritize P0 launch blockers and include only P1 items that are
  directly necessary to make those flows usable.
- PIN lock is required for MVP; biometric unlock may be added only if it does not
  delay the PIN-based privacy baseline.
- Existing generic document records will remain usable and may be mapped to Other
  or prompted for type assignment when opened.
- Resume support for MVP means storing/importing and sharing the file; advanced
  resume editing or compression can wait.
- Language support, backup/export vault, favorites, broad PDF utilities, premium
  features, reminders, checklist features, and cloud sync are out of scope.
