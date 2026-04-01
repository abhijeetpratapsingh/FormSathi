Build a complete Flutter mobile app named "FormSathi" for Android first, using Dart and Flutter.

IMPORTANT CONTEXT FILES TO FOLLOW:
1. Use the main product requirements in this prompt as the primary source of truth.
2. Also strictly refer to the attached architecture document: `form_sathi_technical_architecture.md`.
3. If there is any ambiguity, resolve it by following `form_sathi_technical_architecture.md` for technical architecture, project structure, state management, storage, and code organization.

PROJECT NAME:
FormSathi

PLAY STORE TITLE:
Photo Resize & PDF for Forms – FormSathi

TAGLINE:
Your offline form-filling companion

GOAL:
This app is for students and job applicants who frequently fill online forms and need quick access to personal information, documents, and utility tools like image resize, compression, and image-to-PDF conversion.

CORE PRODUCT VISION:
- 100% offline in phase 1
- No login
- No cloud
- No backend
- Simple, fast, low-friction UX
- Designed for mass users in India
- Clean, trustworthy, utility-focused design
- SEO optimized for Play Store discovery
- Production-ready architecture

LATEST SDK REQUIREMENTS:
- Use the latest stable Flutter SDK available at generation time, not an outdated version
- Prefer Flutter stable channel for production readiness
- Use the latest compatible Dart SDK bundled with that Flutter stable version
- At the time of generation, target Flutter 3.38 stable line and Dart 3.11 unless a newer official stable version is available
- Before generating code, verify the latest official stable Flutter and Dart versions from official sources and use them
- Ensure all dependencies are compatible with that verified stable Flutter/Dart setup
- Use modern Dart 3 language features only if compatible with the verified stable setup
- Use null safety everywhere

TECHNICAL ARCHITECTURE REQUIREMENTS:
Strictly follow the architecture guidance from `form_sathi_technical_architecture.md`, especially:
- State management: flutter_bloc with Cubit
- Architecture: feature-first Clean Architecture lite
- Dependency injection: get_it
- Local storage: Hive
- Routing: go_router
- File storage: local device storage using path_provider
- Image processing and PDF generation through dedicated services
- Reusable widgets
- Modular and scalable codebase

MULTI-AGENT EXECUTION INSTRUCTION:
If your environment supports multi-agent or parallel task execution, use it to accelerate development.
Suggested agent split:
- Agent 1: app architecture, folder structure, dependency setup, routing, DI
- Agent 2: My Info feature
- Agent 3: Documents feature
- Agent 4: Tools feature (resize, compress, image-to-PDF)
- Agent 5: polish, reusable widgets, empty states, error handling, README
Then merge outputs into one consistent production-ready Flutter project.
If multi-agent execution is not supported, simulate the same workflow sequentially in clearly separated implementation phases.

MAIN USER PROBLEMS TO SOLVE:
1. Re-entering personal info in every form
2. Finding documents quickly (photo, signature, ID)
3. Resizing images to exact sizes (50KB, 100KB, passport)
4. Converting images to PDF
5. Managing everything offline without confusion

TARGET AUDIENCE:
- Students
- Govt exam applicants
- College admission users
- Job applicants
- Low-tech users

DESIGN PRINCIPLES:
- Minimal UI
- Trust-focused
- Fast interactions
- Large tap areas
- No clutter
- Beginner friendly
- No ads in this version
- No dark patterns
- No unnecessary animations

APP STRUCTURE:

1. Splash Screen
- App logo + name (FormSathi)
- Quick load to home

2. Home Screen
- 3 main cards:
  - My Info
  - My Documents
  - Tools
- Small subtitle:
  "Keep your form details and documents ready offline"
- Optional: Recent actions

3. My Info Screen
Fields:
- Full Name
- Father's Name
- Mother's Name
- DOB
- Gender
- Phone
- Email
- Address
- City
- State
- Pin Code
- Aadhaar (optional, hide/show)
- PAN (optional, hide/show)
- School/College
- Qualification
- Category
- Nationality

Features:
- Save & edit
- Copy button per field
- "Copy All Info" button
- Snackbar feedback
- Clean layout
- Sensitive fields masked by default with hide/show

4. My Documents Screen
Features:
- Add image (camera/gallery)
- Tag:
  - Passport Photo
  - Signature
  - Aadhaar
  - PAN
  - Marksheet
  - Certificate
  - ID Proof
  - Other
- Grid view or clean card list
- Preview screen
- Rename
- Delete
- Filter by category
- Local storage only
- Save metadata in Hive, actual files in app storage

5. Tools Screen

A. Resize Image Tool
Presets:
- Passport Size
- Signature Size
- Under 50KB
- Under 100KB
- Under 200KB

Flow:
- Select image
- Preview
- Apply preset
- Save locally
- Show final size
- Share option
- Save as copy

B. Compress Image Tool
- Select image
- Show original size
- Quality options:
  - High
  - Medium
  - Low
- Save compressed file
- Share option

C. Image to PDF Tool
- Select multiple images
- Reorder images
- Name PDF
- Generate PDF
- Save locally
- Share option

OPTIONAL:
Recent processed files section

UX FLOWS:

First-time user:
- Open app → Home → no login → instant use

Returning user:
- Direct access to tools/data

Core flows:
- Save info → reuse
- Add documents → quick access
- Resize → share
- PDF create → upload

UI DESIGN:
- Material 3
- Light background
- Blue/Indigo primary
- Rounded cards
- Clean spacing
- Simple icons
- Responsive layout
- Professional utility app look

NAVIGATION:
Use go_router and keep navigation simple:
- Home
- My Info
- My Documents
- Tools
- Document Preview
- Optional About/Settings

DATA MODELS:

UserInfo:
- fullName
- fatherName
- motherName
- dob
- gender
- phone
- email
- address
- city
- state
- pinCode
- aadhaar
- pan
- schoolCollege
- qualification
- category
- nationality

SavedDocument:
- id
- title
- category
- localPath
- createdAt
- updatedAt

ProcessedFile:
- id
- type
- localPath
- createdAt
- metadata

ARCHITECTURE:
Follow feature-first Clean Architecture lite:
- presentation
- domain
- data

Suggested structure:
- app/
- core/
- features/home
- features/my_info
- features/documents
- features/tools
- features/settings

SERVICES:
- local storage service
- local file service
- image processing service
- PDF service

IMPORTANT REQUIREMENTS:
- Fully offline
- Fast performance
- Proper permission handling
- Safe file handling
- Error handling
- Empty states
- No business logic inside widgets
- No direct Hive calls from UI
- No giant main.dart
- No overengineering

EMPTY STATES:
- My Info: "Save your details once and reuse anytime"
- Documents: "Add your photo and documents"
- Tools: "Your processed files will appear here"

NICE-TO-HAVE:
- Search documents
- Copy buttons everywhere
- Confirm delete
- About page:
  "Your data stays on your device"

DO NOT INCLUDE:
- Login
- Firebase
- Backend
- Ads
- Subscription
- Cloud sync
- Notifications
- AI features

DELIVERABLES:
- Full Flutter project code
- pubspec.yaml
- Clean architecture
- Working features
- README with setup steps
- Future scope:
  - Google Drive backup
  - Premium version
  - Reminders
  - Checklist

SEO FOCUS:
Ensure app structure and naming aligns with keywords:
- photo resize 50kb
- passport size photo
- image to pdf
- compress image for forms

QUALITY BAR:
Make the app feel like a real Play Store utility app, not a demo.
Focus on simplicity, speed, trust, and usability.

IMPLEMENTATION PROCESS:
Before generating code:
1. Read and follow `form_sathi_technical_architecture.md`
2. Verify latest official stable Flutter and Dart versions
3. Define final folder structure
4. Define dependencies
5. Define models
6. Define navigation
7. Define DI setup
8. Then generate the full project code step by step

CODE GENERATION RULES:
- Generate production-minded code, not mock code
- Use Cubit, not full Bloc, unless a specific case truly requires Bloc
- Keep widgets reusable and small
- Add comments only where useful
- Ensure all imports and package versions are compatible
- Ensure the code can run after `flutter pub get`
- Include any required platform permission notes