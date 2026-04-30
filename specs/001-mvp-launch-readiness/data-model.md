# Data Model: MVP Launch Readiness

## Document Type

Represents the form-specific purpose of a saved file.

Fields:
- `id`: stable enum/string key, one of `signature`, `passportPhoto`, `aadhaar`,
  `pan`, `marksheet`, `certificate`, `resume`, `other`
- `label`: user-facing name
- `allowedSources`: camera, gallery, or file import options
- `requiresSide`: whether front/back or page-side metadata is relevant
- `supportedExportPresetIds`: list of export presets available from preview
- `defaultTitle`: title suggestion for newly added documents

Validation:
- Every saved document has exactly one document type.
- Existing category-only documents migrate to the closest type or `other`.
- Resume can accept imported local files; image-only export presets do not apply
  to resume unless future scope adds them.

## Saved Document

Represents a user-owned local document record and its stored file.

Fields:
- `id`: unique local identifier
- `title`: non-empty user-editable title
- `documentType`: Document Type key
- `category`: legacy or display category retained for compatibility
- `localPath`: app-local saved file path
- `originalFileName`: source file name when available
- `mimeType`: image, PDF, or unknown when unavailable
- `fileSizeBytes`: latest known stored file size
- `width`: image width when available
- `height`: image height when available
- `pageCount`: PDF/page count when available
- `side`: none, front, back, or page label for identity documents
- `notes`: optional user notes
- `createdAt`: created timestamp
- `updatedAt`: last metadata update timestamp

Relationships:
- Has one Document Type.
- Can have many Processed Outputs.
- Can be selected by one or more Export Requests.

Validation:
- `title`, `documentType`, `localPath`, `createdAt`, and `updatedAt` are required.
- `fileSizeBytes` must be non-negative when known.
- `side` is required only when the chosen document type and flow request it.
- Delete document removes its record and saved file after confirmation.
- Originals are preserved during export.

State transitions:
- `draftSelection` -> `metadataReview` -> `saved`
- `saved` -> `updated`
- `saved` -> `deleted`
- `saved` -> `exporting` -> `exported` or `exportFailed`

## Export Preset

Represents a named form-ready output target.

Fields:
- `id`: stable preset key
- `label`: user-facing action label
- `documentTypeIds`: document types this preset supports
- `outputKind`: image or PDF
- `targetBytes`: maximum size target when required
- `requiredCropMode`: none, freeform, signature, passportAspect, or page
- `defaultDimensions`: width/height when prescribed
- `qualityFloor`: lowest acceptable quality before failure
- `preserveOriginal`: always true for MVP

Validation:
- Signature under 20 KB targets image output and requires crop support.
- Passport Photo under 50 KB targets image output and requires aspect/crop
  support.
- Aadhaar/PAN PDF targets PDF output from selected sides/pages.
- Certificate/Marksheet PDF under 300 KB targets PDF output and validates size.
- Export success requires final file size to be at or below `targetBytes` when
  a target is defined.

## Export Request

Represents a user's request to generate an output from saved documents or
standalone tool inputs.

Fields:
- `id`: unique local identifier
- `sourceMode`: savedDocument or standaloneTool
- `sourceDocumentIds`: saved document ids when source mode is savedDocument
- `sourcePaths`: local input paths for standalone tools
- `presetId`: optional Export Preset id
- `customWidth`: optional target width
- `customHeight`: optional target height
- `customTargetBytes`: optional target size
- `cropRect`: optional crop rectangle
- `requestedAt`: timestamp

Validation:
- Request must contain at least one source document or source path.
- Crop rectangle must be inside the decoded image bounds.
- Custom dimensions must be positive when provided.
- PDF requests must have at least one selected page/source.

## Processed Output

Represents a generated file that can be previewed, shared, or deleted.

Fields:
- `id`: unique local identifier
- `sourceDocumentId`: optional source document id
- `type`: resized, compressed, or pdf
- `presetId`: optional Export Preset id
- `localPath`: app-local generated output path
- `fileSizeBytes`: final output size
- `width`: image width when output is an image
- `height`: image height when output is an image
- `pageCount`: PDF page count when output is a PDF
- `createdAt`: timestamp
- `status`: success or failed
- `failureMessage`: user-safe failure reason when failed

Relationships:
- May belong to one Saved Document.
- Is created by one Export Request.

Validation:
- Success output must have an existing `localPath`.
- Success with target bytes must be within target.
- Failed output must not delete or mutate source files.

## Privacy Settings

Represents local privacy state and user controls.

Fields:
- `firstRunPrivacySeen`: boolean
- `appLockEnabled`: boolean
- `lockTimeoutSeconds`: positive integer
- `lastUnlockedAt`: timestamp when available
- `sensitiveMaskingEnabled`: boolean
- `secureStorageVersion`: version key for local data migration

Validation:
- App lock cannot be enabled without a valid App Lock Credential.
- First-run privacy is shown until acknowledged.
- Delete-all-data resets privacy settings except any state required to show a
  clean first-run experience.

State transitions:
- `notIntroduced` -> `privacyAcknowledged`
- `lockDisabled` -> `lockSetup` -> `lockEnabled`
- `lockEnabled` -> `locked` -> `unlocked`
- `lockEnabled` -> `lockDisabled`

## App Lock Credential

Represents the local credential used for app lock.

Fields:
- `credentialId`: local identifier
- `pinVerifier`: protected verifier, not the raw PIN
- `createdAt`: timestamp
- `updatedAt`: timestamp
- `failedAttemptCount`: count since last success

Validation:
- Raw PIN is never stored.
- PIN setup requires confirmation.
- Changing or disabling lock requires current PIN or a reset path that deletes
  local app data.

## Wipe Result

Represents the outcome of deleting all local app data.

Fields:
- `deletedInfo`: boolean
- `deletedDocumentRecords`: count
- `deletedDocumentFiles`: count
- `deletedProcessedRecords`: count
- `deletedProcessedFiles`: count
- `failedPaths`: list of paths that could not be deleted

Validation:
- User must explicitly confirm before wipe starts.
- Any failed path is reported in user-safe language.
- After successful wipe, Info, Docs, and recent processed files appear empty.
