# Quickstart: MVP Launch Readiness

## Prerequisites

- Flutter stable SDK available locally.
- iOS Simulator or Android Emulator for manual flows.
- Existing dependencies installed with `flutter pub get`.

## Run the App

```bash
flutter pub get
flutter run
```

## Automated Checks

Run before and after implementation:

```bash
flutter analyze
flutter test
```

Expected focused test coverage:
- Navigation shell and selected tab behavior.
- First-run privacy state.
- PIN setup, unlock, change, disable, and timeout state transitions.
- Last-4 masking for Aadhaar/PAN and short/empty values.
- Document type assignment and migration from existing generic records.
- Export preset selection and target-size validation.
- Delete-all-data repository/service behavior.
- User-safe error mapping for picking, processing, sharing, and storage failures.

## Manual Story Checks

### Story 1: Navigate Core Areas Quickly

1. Install/run the app with clean data.
2. Complete the privacy intro.
3. Confirm Info, Docs, Tools, and Settings are reachable in one tap.
4. Open a document or tool flow, switch tabs, and verify return behavior is
   understandable without the old launcher.

### Story 2: Trust the Offline Privacy Model

1. Confirm first-run privacy explains local storage, no account/cloud, app lock,
   generated files, and delete-all-data.
2. Enable PIN lock.
3. Restart the app and verify locked content is hidden until unlock.
4. Verify Aadhaar/PAN are masked with readable last-4 style.
5. Delete all data from Settings and confirm Info, Docs, and recent outputs are
   empty.

### Story 3: Add Typed Form Documents

1. From Docs, tap Add.
2. Select Signature, Passport Photo, Aadhaar, PAN, Marksheet, Certificate,
   Resume, and Other across test runs.
3. Confirm type selection happens before source selection.
4. Save at least one identity document with side/page metadata.
5. Confirm metadata such as type, title, file size, and notes appears in preview.

### Story 4: Export Common Form Files from Preview

1. Save a Signature document and export under 20 KB.
2. Save a Passport Photo and export under 50 KB after crop/aspect adjustment.
3. Save Aadhaar/PAN pages and export a PDF.
4. Save a Certificate or Marksheet and export a PDF under 300 KB.
5. Confirm success shows final size and failure explains why target was not met.
6. Confirm original documents remain available after every export attempt.

### Story 5: Use Improved Standalone Tools

1. Open Compress Image and generate outputs for 20 KB, 50 KB, 100 KB, and 300 KB
   targets.
2. Open Resize Image, enter custom dimensions, and validate final size.
3. Open Image to PDF, reorder pages, and review output size warning/compression
   behavior.
4. Share a generated output from each tool.

## Device-Only Checks

These flows require simulator/device validation:
- Camera permission and cancellation.
- Gallery/file picker cancellation.
- Share sheet availability.
- App resume after inactivity timeout.
- Low-storage or missing-file behavior where practical.
- Destructive data wipe with real files present.

## Completion Criteria

- All success criteria in `spec.md` are demonstrable.
- `flutter analyze` passes.
- Relevant `flutter test` targets pass.
- Manual device checks are recorded with pass/fail notes.
- No cloud, account, premium, reminders, checklist, favorites, broad PDF tools,
  backup/export vault, or localization work is included in this feature.
