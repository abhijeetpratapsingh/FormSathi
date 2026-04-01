# FormSathi

Photo Resize & PDF for Forms – FormSathi

Your offline form-filling companion for storing personal details, keeping frequently used documents ready, resizing or compressing images for form uploads, and converting images to PDF.

## Stack

- Flutter stable, iOS + Android
- Dart with null safety
- `flutter_bloc` with Cubit
- `get_it` for dependency injection
- `Hive` for offline storage
- `go_router` for navigation
- `path_provider` for app-local file storage
- `image`, `image_picker`, `pdf`, `share_plus`, `permission_handler`

## Features

- Save form details once and reuse them with per-field copy and copy-all
- Store passport photo, signature, Aadhaar, PAN, marksheets, certificates, and other images locally
- Resize images with form-friendly presets including passport size and under-50KB targets
- Compress images with quality presets
- Convert multiple images into a single PDF
- Fully offline, no login, no backend, no cloud sync

## Project Structure

```text
lib/
  app/
  core/
  features/
    home/
    my_info/
    documents/
    tools/
    settings/
```

## Getting Started

1. Install the latest Flutter stable SDK. The implementation targets the stable line reflected by the official docs on April 1, 2026.
2. Create `android/local.properties` with your local Flutter SDK path if it is not generated automatically:

```properties
flutter.sdk=/path/to/flutter
sdk.dir=/path/to/android/sdk
```

3. Run:

```bash
flutter pub get
flutter run
```

## Platform Notes

- Camera permission is declared in `AndroidManifest.xml`.
- iOS privacy usage strings are declared in `ios/Runner/Info.plist`.
- All user data is stored on-device in app-local directories and Hive boxes.
- Saved files are organized under app documents data:

```text
app_data/
  documents/
  processed/
    resized/
    compressed/
    pdfs/
```

## Future Scope

- Google Drive backup
- Premium version
- Reminders
- Checklist
