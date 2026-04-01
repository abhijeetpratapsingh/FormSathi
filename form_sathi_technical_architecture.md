# 📱 FormSathi – Technical Architecture Guide

## 🚀 Overview

FormSathi is an **offline-first Flutter app** designed for students and job applicants to manage form-related tasks such as:

* Saving personal information
* Managing documents
* Resizing/compressing images
* Converting images to PDF

---

# 🧠 Core Tech Decisions

## State Management

* **flutter_bloc (Cubit)**
* Reason:

  * Less boilerplate than Bloc
  * Simple state flows
  * Perfect for CRUD + offline apps

---

## Architecture

* **Feature-first Clean Architecture (Lite version)**

### Layers:

1. **Presentation** (UI + Cubit)
2. **Domain** (Entities + UseCases + Repositories)
3. **Data** (Models + DataSources + Repository Impl)

---

## Dependency Injection

* **get_it**

---

## Local Storage

* **Hive**

### Used for:

* User Info
* Documents metadata
* Processed files

---

## File Storage

* Local device storage using `path_provider`

### Folder Structure:

```
/app_data
  /documents
  /processed
    /resized
    /compressed
    /pdfs
```

---

## Navigation

* **go_router**

---

# 📦 Packages

## Core

* flutter_bloc
* equatable
* get_it
* go_router

## Storage

* hive
* hive_flutter
* path_provider

## Media & Files

* image_picker
* image
* share_plus
* permission_handler

## PDF

* pdf
* printing (optional)

## Code Generation

* freezed_annotation
* json_annotation

### Dev Dependencies

* build_runner
* freezed
* json_serializable
* hive_generator

---

# 📂 Folder Structure

```
lib/
  app/
    app.dart
    router.dart
    di.dart

  core/
    constants/
    enums/
    errors/
    extensions/
    services/
    theme/
    utils/
    widgets/

  features/
    home/
      presentation/

    my_info/
      data/
      domain/
      presentation/

    documents/
      data/
      domain/
      presentation/

    tools/
      data/
      domain/
      presentation/

    settings/
      presentation/

  main.dart
```

---

# 🧩 Features Breakdown

## 1. My Info

* Save personal data
* Copy fields
* Mask sensitive data

## 2. Documents

* Add image
* Tag category
* Preview / Rename / Delete
* Filter by category

## 3. Tools

### Resize Image

* Passport
* Under 50KB
* Under 100KB

### Compress Image

* High / Medium / Low

### Image to PDF

* Multi-image selection
* Reordering
* Save & share

---

# ⚙️ Cubits

* HomeCubit
* MyInfoCubit
* DocumentsCubit
* ResizeImageCubit
* CompressImageCubit
* ImageToPdfCubit

---

# 🧱 Data Models

## UserInfo

* fullName
* fatherName
* dob
* phone
* address
* aadhaar
* pan

## SavedDocument

* id
* title
* category
* localPath
* createdAt

## ProcessedFile

* id
* type
* localPath
* createdAt

---

# 🔧 Services

## LocalFileService

* Save files
* Delete files
* Get file paths

## ImageProcessingService

* Resize image
* Compress image

## PdfService

* Generate PDF
* Save PDF

---

# 🔁 Core Flows

## Save Info

* Fill form → Save → Stored locally

## Manage Documents

* Add → Tag → Access → Delete

## Resize Image

* Pick → Select preset → Save

## Create PDF

* Select images → Generate → Save

---

# ⚠️ Important Rules

* No login
* No backend
* No cloud
* No ads (Phase 1)
* Fully offline
* No business logic inside UI

---

# 🧠 Best Practices

* Keep widgets small
* Use services for logic
* Use Cubit only for state
* Store only paths, not files in DB
* Avoid overengineering

---

# 🔮 Future Scope

* Google Drive backup
* Premium features
* Reminders
* Document checklist
* Encryption

---

# ✅ Final Stack Summary

* State: Cubit
* Architecture: Clean (Lite)
* Storage: Hive
* DI: get_it
* Routing: go_router

---

# 💬 Final Note

Keep the app:

* Simple
* Fast
* Reliable
* Offline-first

👉 Focus on execution, not perfection.
