# Tasks: MVP Launch Readiness

**Input**: Design documents from `/specs/001-mvp-launch-readiness/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Test tasks are included because the specification and quickstart require
focused automated coverage for navigation, privacy, app lock, typed documents,
exports, wipe behavior, and user-safe errors.

**Organization**: Tasks are grouped by user story to enable independent
implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4, US5)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare dependencies, test folders, and shared app constants needed
by the launch-readiness work.

- [X] T001 Review and add required secure storage, crop, and file import dependencies in `pubspec.yaml`
- [X] T002 Run dependency resolution after pubspec changes and update `pubspec.lock`
- [X] T003 [P] Create app-level test directory structure in `test/app/`
- [X] T004 [P] Create feature test directory structure in `test/features/documents/`
- [X] T005 [P] Create feature test directory structure in `test/features/tools/`
- [X] T006 [P] Create feature test directory structure in `test/features/settings/`
- [X] T007 [P] Create core test directory structure in `test/core/`
- [X] T008 [P] Add launch-readiness user-facing strings to `lib/core/constants/app_strings.dart`
- [X] T009 [P] Add shared spacing/icon constants for navigation, privacy, and export actions in `lib/core/constants/app_sizes.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Shared data, services, repositories, and DI that must exist before
any user-story UI can be completed.

**CRITICAL**: No user story implementation should start until this phase is complete.

- [X] T010 Define document type enum and helpers in `lib/core/enums/document_type.dart`
- [X] T011 Define document side/page enum in `lib/core/enums/document_side.dart`
- [X] T012 Define export preset enum and target metadata in `lib/core/enums/export_preset.dart`
- [X] T013 Define crop mode enum in `lib/core/enums/crop_mode.dart`
- [X] T014 Update Hive type id allocations for new models in `lib/core/services/hive_type_ids.dart`
- [X] T015 Extend `SavedDocument` with type, metadata, side/page, dimensions, file size, and notes in `lib/features/documents/domain/entities/saved_document.dart`
- [X] T016 Extend `SavedDocumentModel` fields and backward-compatible mapping in `lib/features/documents/data/models/saved_document_model.dart`
- [X] T017 Add or update generated Hive adapter registration for document model changes in `lib/core/services/hive_adapters.dart`
- [X] T018 [P] Create `ExportRequest` entity in `lib/features/tools/domain/entities/export_request.dart`
- [X] T019 [P] Create `ExportPresetConfig` entity in `lib/features/tools/domain/entities/export_preset_config.dart`
- [X] T020 [P] Extend `ProcessedFile` with source document, preset, dimensions, page count, and failure metadata in `lib/features/tools/domain/entities/processed_file.dart`
- [X] T021 Extend `ProcessedFileModel` mapping for export metadata in `lib/features/tools/data/models/processed_file_model.dart`
- [X] T022 Create privacy settings entity in `lib/features/settings/domain/entities/privacy_settings.dart`
- [X] T023 Create app lock credential entity in `lib/features/settings/domain/entities/app_lock_credential.dart`
- [X] T024 Create wipe result entity in `lib/features/settings/domain/entities/wipe_result.dart`
- [X] T025 Add local data wipe operations to `lib/core/services/local_file_service.dart`
- [X] T026 Add metadata inspection helpers for size, dimensions, and MIME hints in `lib/core/services/local_file_service.dart`
- [X] T027 Add crop, custom resize, target-byte compression, and validation APIs in `lib/core/services/image_processing_service.dart`
- [X] T028 Add PDF target-size generation and page count metadata APIs in `lib/core/services/pdf_service.dart`
- [X] T029 Create export orchestration service in `lib/core/services/export_orchestration_service.dart`
- [X] T030 Create privacy and lock local data source in `lib/features/settings/data/datasources/privacy_local_data_source.dart`
- [X] T031 Create privacy settings model in `lib/features/settings/data/models/privacy_settings_model.dart`
- [X] T032 Create app lock credential model in `lib/features/settings/data/models/app_lock_credential_model.dart`
- [X] T033 Create settings repository contract in `lib/features/settings/domain/repositories/settings_repository.dart`
- [X] T034 Create settings repository implementation in `lib/features/settings/data/repositories/settings_repository_impl.dart`
- [X] T035 Create app lock use cases in `lib/features/settings/domain/usecases/app_lock_usecases.dart`
- [X] T036 Create privacy and wipe use cases in `lib/features/settings/domain/usecases/privacy_usecases.dart`
- [X] T037 Add migration support from category-only documents to typed documents in `lib/features/documents/data/datasources/documents_local_data_source.dart`
- [X] T038 Extend documents repository contract with typed metadata update and migration methods in `lib/features/documents/domain/repositories/documents_repository.dart`
- [X] T039 Extend documents repository implementation with typed metadata update and migration methods in `lib/features/documents/data/repositories/documents_repository_impl.dart`
- [X] T040 Register new services, Hive boxes, repositories, and use cases in `lib/app/di.dart`
- [X] T041 Add user-safe error mapping helpers in `lib/core/errors/app_exception.dart`
- [X] T042 [P] Add foundational unit tests for document type mappings in `test/core/document_type_test.dart`
- [X] T043 [P] Add foundational unit tests for export preset metadata in `test/core/export_preset_test.dart`
- [X] T044 [P] Add foundational unit tests for target-byte image processing behavior in `test/core/image_processing_service_test.dart`
- [X] T045 [P] Add foundational unit tests for local data wipe behavior in `test/core/local_data_wipe_test.dart`

**Checkpoint**: Shared entities, services, migrations, storage registration, and
test scaffolding are ready. User story phases can now proceed.

---

## Phase 3: User Story 1 - Navigate Core Areas Quickly (Priority: P1)

**Goal**: Replace the card launcher with persistent Info, Docs, Tools, and
Settings navigation while preserving access to existing flows.

**Independent Test**: A user can open the app, switch among all four areas in one
tap, and avoid the old home card launcher.

### Tests for User Story 1

- [X] T046 [P] [US1] Add widget tests for bottom navigation tab rendering and switching in `test/app/app_navigation_shell_test.dart`
- [X] T047 [P] [US1] Add router tests for Info, Docs, Tools, and Settings tab routes in `test/app/router_test.dart`

### Implementation for User Story 1

- [X] T048 [US1] Create persistent navigation shell widget in `lib/app/app_navigation_shell.dart`
- [X] T049 [US1] Refactor routes to use the navigation shell and tab routes in `lib/app/router.dart`
- [X] T050 [US1] Update splash routing to skip unnecessary launcher delay after setup in `lib/features/home/presentation/pages/splash_page.dart`
- [X] T051 [US1] Convert `HomePage` into first-run or legacy fallback content without primary card navigation in `lib/features/home/presentation/pages/home_page.dart`
- [X] T052 [US1] Verify existing Info page creation works inside the shell in `lib/features/my_info/presentation/pages/my_info_page.dart`
- [X] T053 [US1] Verify existing Documents page creation works inside the shell in `lib/features/documents/presentation/pages/documents_page.dart`
- [X] T054 [US1] Verify existing Tools page creation works inside the shell in `lib/features/tools/presentation/pages/tools_feature_page.dart`
- [X] T055 [US1] Verify existing Settings page creation works inside the shell in `lib/features/settings/presentation/pages/settings_page.dart`

**Checkpoint**: US1 is independently usable: bottom navigation is present and
all four primary areas are reachable in one tap.

---

## Phase 4: User Story 2 - Trust the Offline Privacy Model (Priority: P1)

**Goal**: Add first-run privacy messaging, PIN app lock, masking, secure storage,
and delete-all-data controls.

**Independent Test**: A first-time user can understand privacy, enable lock,
restart/unlock, see masked identifiers, and wipe all data from Settings.

### Tests for User Story 2

- [X] T056 [P] [US2] Add privacy intro Cubit tests in `test/features/settings/privacy_intro_cubit_test.dart`
- [X] T057 [P] [US2] Add app lock Cubit tests for setup, unlock, timeout, change, and disable in `test/features/settings/app_lock_cubit_test.dart`
- [X] T058 [P] [US2] Add sensitive masking tests for Aadhaar, PAN, short values, and empty values in `test/features/my_info/sensitive_masking_test.dart`
- [X] T059 [P] [US2] Add settings wipe flow widget tests in `test/features/settings/delete_all_data_test.dart`

### Implementation for User Story 2

- [X] T060 [US2] Create privacy Cubit and state for intro, settings, and wipe status in `lib/features/settings/presentation/cubit/privacy_cubit.dart`
- [X] T061 [US2] Create app lock Cubit and state for PIN setup and unlock flows in `lib/features/settings/presentation/cubit/app_lock_cubit.dart`
- [X] T062 [US2] Create first-run privacy intro page in `lib/features/settings/presentation/pages/privacy_intro_page.dart`
- [X] T063 [US2] Add privacy intro routing and first-run redirect handling in `lib/app/router.dart`
- [X] T064 [US2] Create lock screen page for cold start and resume gates in `lib/features/settings/presentation/pages/app_lock_page.dart`
- [X] T065 [US2] Add lifecycle lock gate integration in `lib/app/app.dart`
- [X] T066 [US2] Replace Settings future-scope content with privacy, app lock, and delete data sections in `lib/features/settings/presentation/pages/settings_page.dart`
- [X] T067 [US2] Create PIN setup/change widgets in `lib/features/settings/presentation/widgets/pin_setup_sheet.dart`
- [X] T068 [US2] Create destructive delete-all-data confirmation widget in `lib/features/settings/presentation/widgets/delete_all_data_dialog.dart`
- [X] T069 [US2] Add delete-all-data orchestration across settings, my info, documents, tools, and files in `lib/features/settings/domain/usecases/privacy_usecases.dart`
- [X] T070 [US2] Add repository wipe methods for My Info in `lib/features/my_info/domain/repositories/my_info_repository.dart`
- [X] T071 [US2] Implement My Info wipe method in `lib/features/my_info/data/repositories/my_info_repository_impl.dart`
- [X] T072 [US2] Add repository wipe methods for documents in `lib/features/documents/domain/repositories/documents_repository.dart`
- [X] T073 [US2] Implement documents wipe method in `lib/features/documents/data/repositories/documents_repository_impl.dart`
- [X] T074 [US2] Add repository wipe methods for processed files in `lib/features/tools/domain/repositories/tools_repository.dart`
- [X] T075 [US2] Implement processed files wipe method in `lib/features/tools/data/repositories/tools_repository_impl.dart`
- [X] T076 [US2] Add last-4 sensitive masking utility in `lib/core/utils/sensitive_value_formatter.dart`
- [X] T077 [US2] Apply last-4 masking and deliberate copy behavior in `lib/features/my_info/presentation/pages/my_info_page.dart`
- [X] T078 [US2] Add secure storage migration call during startup in `lib/app/di.dart`

**Checkpoint**: US2 is independently usable: privacy intro, PIN lock, masking,
secure storage migration, and delete-all-data are available and testable.

---

## Phase 5: User Story 3 - Add Typed Form Documents (Priority: P1)

**Goal**: Make document add and preview flows type-aware for launch-critical
form document types.

**Independent Test**: A user can choose a document type first, add/import a file,
review type-specific metadata, and save a record with relevant preview actions.

### Tests for User Story 3

- [X] T079 [P] [US3] Add DocumentsCubit tests for type-first add flow and metadata save in `test/features/documents/documents_cubit_test.dart`
- [X] T080 [P] [US3] Add document migration tests for category-only records in `test/features/documents/document_migration_test.dart`
- [X] T081 [P] [US3] Add widget tests for type picker and metadata review in `test/features/documents/add_document_flow_test.dart`

### Implementation for User Story 3

- [X] T082 [US3] Extend DocumentsCubit state with selected type, source, side/page, metadata, and migration status in `lib/features/documents/presentation/cubit/documents_state.dart`
- [X] T083 [US3] Extend DocumentsCubit behavior for type selection, source selection, metadata review, and save in `lib/features/documents/presentation/cubit/documents_cubit.dart`
- [X] T084 [US3] Create document type picker bottom sheet in `lib/features/documents/presentation/widgets/document_type_picker_sheet.dart`
- [X] T085 [US3] Create document source picker for camera, gallery, and file options in `lib/features/documents/presentation/widgets/document_source_picker_sheet.dart`
- [X] T086 [US3] Create type-specific metadata review sheet in `lib/features/documents/presentation/widgets/document_metadata_review_sheet.dart`
- [X] T087 [US3] Update Documents page Add action to start with type selection in `lib/features/documents/presentation/pages/documents_page.dart`
- [X] T088 [US3] Update document cards to show type, file size, side/page, and notes indicators in `lib/features/documents/presentation/widgets/document_card.dart`
- [X] T089 [US3] Update category filter behavior to work with document types in `lib/features/documents/presentation/widgets/document_category_filter_bar.dart`
- [X] T090 [US3] Update document metadata sheet for title, type, side/page, notes, file size, and dates in `lib/features/documents/presentation/widgets/document_metadata_sheet.dart`
- [X] T091 [US3] Update document preview page to display typed metadata and placeholder smart action slots in `lib/features/documents/presentation/pages/document_preview_page.dart`
- [X] T092 [US3] Add resume file import handling to document save flow in `lib/features/documents/presentation/cubit/documents_cubit.dart`

**Checkpoint**: US3 is independently usable: documents are typed and preview
metadata is type-aware.

---

## Phase 6: User Story 4 - Export Common Form Files from Preview (Priority: P1)

**Goal**: Add one-tap smart exports from document preview for signature, passport
photo, Aadhaar/PAN PDF, and certificate/marksheet PDF targets.

**Independent Test**: From saved document preview, a user can generate and share
validated form-ready outputs without losing originals.

### Tests for User Story 4

- [X] T093 [P] [US4] Add export orchestration tests for signature under 20 KB in `test/features/tools/smart_export_service_test.dart`
- [X] T094 [P] [US4] Add export orchestration tests for passport photo under 50 KB in `test/features/tools/smart_export_service_test.dart`
- [X] T095 [P] [US4] Add export orchestration tests for Aadhaar/PAN PDF output in `test/features/tools/smart_pdf_export_test.dart`
- [X] T096 [P] [US4] Add export orchestration tests for certificate PDF under 300 KB in `test/features/tools/smart_pdf_export_test.dart`
- [X] T097 [P] [US4] Add document preview widget tests for smart export actions in `test/features/documents/document_preview_export_test.dart`

### Implementation for User Story 4

- [X] T098 [US4] Create smart export use case for saved documents in `lib/features/tools/domain/usecases/export_saved_document_usecase.dart`
- [X] T099 [US4] Persist smart export outputs through tools repository in `lib/features/tools/data/repositories/tools_repository_impl.dart`
- [X] T100 [US4] Add source document and preset metadata support to recent processed data source in `lib/features/tools/data/datasources/tools_local_data_source.dart`
- [X] T101 [US4] Create smart export Cubit and state for document preview exports in `lib/features/tools/presentation/cubit/smart_export_cubit.dart`
- [X] T102 [US4] Create crop request page or sheet for signature and passport exports in `lib/features/tools/presentation/widgets/crop_export_sheet.dart`
- [X] T103 [US4] Create export result sheet showing final size, share, save, and failure states in `lib/features/tools/presentation/widgets/export_result_sheet.dart`
- [X] T104 [US4] Add signature under-20KB preview action in `lib/features/documents/presentation/pages/document_preview_page.dart`
- [X] T105 [US4] Add passport photo under-50KB preview action in `lib/features/documents/presentation/pages/document_preview_page.dart`
- [X] T106 [US4] Add Aadhaar/PAN PDF preview action with side/page selection in `lib/features/documents/presentation/pages/document_preview_page.dart`
- [X] T107 [US4] Add certificate/marksheet PDF under-300KB preview action in `lib/features/documents/presentation/pages/document_preview_page.dart`
- [X] T108 [US4] Add resume and other share-original actions in `lib/features/documents/presentation/pages/document_preview_page.dart`
- [X] T109 [US4] Add smart export dependency registration in `lib/app/di.dart`
- [X] T110 [US4] Update recent processed file card to display preset and source document metadata in `lib/features/tools/presentation/widgets/recent_processed_file_card.dart`

**Checkpoint**: US4 is independently usable: saved documents produce validated,
shareable form-ready outputs from preview.

---

## Phase 7: User Story 5 - Use Improved Standalone Tools (Priority: P2)

**Goal**: Upgrade standalone resize, compress, and image-to-PDF tools with crop,
custom dimensions, and target-size validation.

**Independent Test**: A user can process one-off files from Tools with target KB
options and clear success/failure feedback.

### Tests for User Story 5

- [X] T111 [P] [US5] Add CompressImageCubit tests for target-size presets in `test/features/tools/compress_image_cubit_test.dart`
- [X] T112 [P] [US5] Add ResizeImageCubit tests for custom dimensions and target validation in `test/features/tools/resize_image_cubit_test.dart`
- [X] T113 [P] [US5] Add ImageToPdfCubit tests for output size warning and compression option in `test/features/tools/image_to_pdf_cubit_test.dart`
- [X] T114 [P] [US5] Add widget tests for standalone target controls in `test/features/tools/tools_target_controls_test.dart`

### Implementation for User Story 5

- [X] T115 [US5] Extend image quality and target preset options in `lib/core/enums/image_quality_option.dart`
- [X] T116 [US5] Extend resize preset and custom dimension model in `lib/core/enums/resize_preset.dart`
- [X] T117 [US5] Add target-size and crop fields to CompressImageState in `lib/features/tools/presentation/cubit/compress_image_state.dart`
- [X] T118 [US5] Add target-size compression behavior to CompressImageCubit in `lib/features/tools/presentation/cubit/compress_image_cubit.dart`
- [X] T119 [US5] Add target-size controls to Compress Image page in `lib/features/tools/presentation/pages/compress_image_page.dart`
- [X] T120 [US5] Add custom dimension and target fields to ResizeImageState in `lib/features/tools/presentation/cubit/resize_image_state.dart`
- [X] T121 [US5] Add custom dimension and target validation behavior to ResizeImageCubit in `lib/features/tools/presentation/cubit/resize_image_cubit.dart`
- [X] T122 [US5] Add custom dimensions and crop controls to Resize Image page in `lib/features/tools/presentation/pages/resize_image_page.dart`
- [X] T123 [US5] Add output size warning fields to ImageToPdfState in `lib/features/tools/presentation/cubit/image_to_pdf_state.dart`
- [X] T124 [US5] Add pre-PDF compression and size warning behavior to ImageToPdfCubit in `lib/features/tools/presentation/cubit/image_to_pdf_cubit.dart`
- [X] T125 [US5] Add PDF output size warning and compression option to Image to PDF page in `lib/features/tools/presentation/pages/image_to_pdf_page.dart`
- [X] T126 [US5] Create reusable target-size selector widget in `lib/features/tools/presentation/widgets/target_size_selector.dart`
- [X] T127 [US5] Create reusable custom dimensions input widget in `lib/features/tools/presentation/widgets/custom_dimensions_fields.dart`
- [X] T128 [US5] Update process preview dialog with final size, dimensions, and target status in `lib/features/tools/presentation/widgets/process_preview_dialog.dart`

**Checkpoint**: US5 is independently usable: standalone tools handle target KB,
crop/custom dimensions, and output feedback.

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Final hardening across completed stories.

- [X] T129 Run `dart format` on `lib/` and `test/`
- [X] T130 Run `flutter analyze` and fix issues in `lib/` and `test/`
- [X] T131 Run full automated test suite with `flutter test`
- [X] T132 [P] Update README privacy and launch-ready workflow notes in `README.md`
- [X] T133 [P] Update technical architecture notes for navigation, secure local storage, typed documents, and smart exports in `form_sathi_technical_architecture.md`
- [X] T134 [P] Record manual device check results for camera, gallery, file picker, share sheet, resume import, app resume lock, and data wipe in `specs/001-mvp-launch-readiness/manual-checks.md`
- [X] T135 Review UI copy for user-safe error messages and remove future-scope language from `lib/core/constants/app_strings.dart`
- [X] T136 Verify no cloud backup, account, premium, reminders, checklist, favorites, broad PDF tools, localization, or backup/export vault work was added in `lib/`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies.
- **Foundational (Phase 2)**: Depends on Setup. Blocks all user stories.
- **US1 Navigation (Phase 3)**: Depends on Foundation. Should be completed before US2 lock routing for smoother integration.
- **US2 Privacy (Phase 4)**: Depends on Foundation and benefits from US1 routing.
- **US3 Typed Documents (Phase 5)**: Depends on Foundation.
- **US4 Smart Exports (Phase 6)**: Depends on Foundation and US3 typed documents.
- **US5 Standalone Tools (Phase 7)**: Depends on Foundation and can run after or beside US4 once export orchestration exists.
- **Polish (Phase 8)**: Depends on desired stories being complete.

### User Story Dependencies

- **US1 (P1)**: Independent navigation increment after Foundation.
- **US2 (P1)**: Independent privacy increment after Foundation; lock routing is easiest after US1.
- **US3 (P1)**: Independent typed document increment after Foundation.
- **US4 (P1)**: Requires US3 typed document records and preview metadata.
- **US5 (P2)**: Uses shared export processing from Foundation and can proceed after core export orchestration is stable.

### Within Each User Story

- Tests first where listed.
- Domain/data model before repository/service behavior.
- Services/use cases before Cubits.
- Cubits before UI integration.
- UI complete before story checkpoint validation.

---

## Parallel Opportunities

- Setup tasks T003-T009 can run in parallel after T001 is decided.
- Foundational enum/entity tests T042-T045 can run in parallel with service/model work once interfaces are drafted.
- US1 tests T046-T047 can run in parallel.
- US2 tests T056-T059 can run in parallel.
- US2 repository wipe tasks T070-T075 can run in parallel by feature ownership.
- US3 tests T079-T081 can run in parallel.
- US3 widgets T084-T086 can run in parallel after Cubit state shape is known.
- US4 export tests T093-T097 can run in parallel.
- US4 preview actions T104-T108 can run in parallel after `SmartExportCubit` is available.
- US5 tests T111-T114 can run in parallel.
- US5 page/widget tasks T119, T122, T125, T126, and T127 can run in parallel after Cubit state changes.
- Polish docs/manual check tasks T132-T134 can run in parallel.

---

## Parallel Example: User Story 2

```bash
Task: "T056 [P] [US2] Add privacy intro Cubit tests in test/features/settings/privacy_intro_cubit_test.dart"
Task: "T057 [P] [US2] Add app lock Cubit tests for setup, unlock, timeout, change, and disable in test/features/settings/app_lock_cubit_test.dart"
Task: "T058 [P] [US2] Add sensitive masking tests for Aadhaar, PAN, short values, and empty values in test/features/my_info/sensitive_masking_test.dart"
Task: "T059 [P] [US2] Add settings wipe flow widget tests in test/features/settings/delete_all_data_test.dart"
```

---

## Parallel Example: User Story 3

```bash
Task: "T084 [US3] Create document type picker bottom sheet in lib/features/documents/presentation/widgets/document_type_picker_sheet.dart"
Task: "T085 [US3] Create document source picker for camera, gallery, and file options in lib/features/documents/presentation/widgets/document_source_picker_sheet.dart"
Task: "T086 [US3] Create type-specific metadata review sheet in lib/features/documents/presentation/widgets/document_metadata_review_sheet.dart"
```

---

## Parallel Example: User Story 4

```bash
Task: "T093 [P] [US4] Add export orchestration tests for signature under 20 KB in test/features/tools/smart_export_service_test.dart"
Task: "T095 [P] [US4] Add export orchestration tests for Aadhaar/PAN PDF output in test/features/tools/smart_pdf_export_test.dart"
Task: "T097 [P] [US4] Add document preview widget tests for smart export actions in test/features/documents/document_preview_export_test.dart"
```

---

## Implementation Strategy

### MVP First

1. Complete Phase 1 and Phase 2.
2. Complete US1 so the app has the final navigation frame.
3. Complete US2 so privacy, lock, masking, and delete-all-data are launch-safe.
4. Complete US3 so documents become typed records.
5. Complete US4 so saved documents become form-ready through smart exports.
6. Stop and validate P1 launch scope before starting US5.

### Incremental Delivery

1. Navigation shell demo: US1 complete.
2. Privacy trust demo: US2 complete.
3. Typed document demo: US3 complete.
4. Smart export demo: US4 complete.
5. Standalone tools upgrade: US5 complete.

### Final Validation

1. Run `flutter analyze`.
2. Run `flutter test`.
3. Execute quickstart manual checks.
4. Confirm deferred features remain out of scope.

---

## Notes

- [P] tasks use different files or can be handled without waiting on another incomplete task.
- [US1] through [US5] labels map directly to stories in `spec.md`.
- Story tasks include exact file paths and are intended for direct execution.
- Preserve original user files during all export work.
- Do not add cloud backup, account, premium, reminders, checklist, favorites,
  broad PDF tools, localization, or backup/export vault behavior in this feature.
