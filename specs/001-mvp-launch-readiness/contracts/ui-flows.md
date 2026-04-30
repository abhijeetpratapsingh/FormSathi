# UI Flow Contracts: MVP Launch Readiness

These contracts define observable app behavior for planning and testing. They do
not prescribe widget implementation.

## Primary Navigation Contract

Initial state:
- First-run users see the privacy introduction before sensitive tabs.
- Returning users land on the primary app surface.

Required tabs:
- Info
- Docs
- Tools
- Settings

Rules:
- Each primary area is reachable in one tap from the main app surface.
- Splash must not create unnecessary delay after first-run setup.
- App lock, when enabled, gates sensitive Info and Docs content before display.
- Existing deep routes for document preview or tool flows must remain reachable
  from the relevant tab.

Success states:
- Active tab is visually clear.
- Switching tabs does not force users through the old home card launcher.

Failure states:
- If a locked tab is requested, show unlock flow rather than sensitive content.

## First-Run Privacy Contract

Entry:
- User opens the app without privacy acknowledgment.

Required content:
- Data stays on device.
- No account or cloud sync is required.
- App lock is available.
- Delete-all-data is available in Settings.
- Generated files are stored locally.

Exit:
- User acknowledges and proceeds to the main app.

Rules:
- Intro must be short enough to complete quickly.
- App lock setup can be offered but not forced unless the user chooses it.

## App Lock Contract

Settings actions:
- Enable PIN lock
- Verify PIN
- Change PIN
- Disable PIN lock

Gate conditions:
- Cold start when lock is enabled
- Resume after configured inactivity timeout
- Opening sensitive Info or Docs when locked

Rules:
- Raw PIN is never displayed after entry.
- Failed unlock shows user-safe retry feedback.
- Forget PIN path explains that reset deletes local app data.

## Typed Document Add Contract

Entry:
- User taps Add in Docs.

Required steps:
1. Select document type.
2. Select source: camera, gallery, or file when supported by type.
3. Review preview and type-specific metadata.
4. Save document.

Rules:
- Document type is required before save.
- Signature and passport photo flows make crop available before export.
- Aadhaar and PAN support side/page labels where useful.
- Existing generic documents remain visible and can be assigned a type later.

## Document Preview Smart Export Contract

Entry:
- User opens a saved document.

Required actions:
- Rename
- Delete
- Share original when allowed
- Type-specific exports

Export action mapping:
- Signature: crop/export under 20 KB
- Passport Photo: crop/aspect/export under 50 KB
- Aadhaar: export selected side/page images as PDF
- PAN: export selected side/page images as PDF
- Marksheet: export PDF under 300 KB
- Certificate: export PDF under 300 KB
- Resume: share stored file
- Other: generic share and optional standalone tool handoff

Rules:
- Success shows final file size.
- Failure explains why the target could not be met.
- Originals are preserved.
- Generated output can be shared after success.

## Standalone Tools Contract

Resize Image:
- User can choose preset or custom dimensions.
- User can optionally set target size.
- Result reports dimensions and final file size.

Compress Image:
- User can choose 20 KB, 50 KB, 100 KB, 300 KB, or quality-oriented choices.
- Result reports whether target was met.

Image to PDF:
- User can review selected pages and order.
- User receives output size warning or compression option before save when
  selected images are likely too large.

Rules:
- User cancellation returns to the previous screen without stale progress state.
- Errors are user-safe and preserve inputs.

## Delete-All-Data Contract

Entry:
- User opens Settings privacy area and chooses delete all data.

Required confirmation:
- Clear destructive wording.
- User must confirm explicitly.

Success:
- Info is empty.
- Docs is empty.
- Recent processed files are empty.
- App returns to clean first-run or empty main state.

Failure:
- Any undeleted files are reported without exposing raw technical errors.
