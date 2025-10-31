# Trekka Mobile Contribution Guide

This Flutter package lives inside the Trekka monorepo. The canonical workflow, coding standards, and licensing terms are documented at the root:

- Primary contribution guide: `../../CONTRIBUTING.md`
- Repository overview & setup: `../../README.md`

Mobile quick reference:

```bash
flutter pub get
flutter run --dart-define=USE_MOCKS=true
flutter test
flutter analyze
```

Use root-level scripts (for example, `../../scripts/dev.sh`) to start the mobile app alongside the API when needed. Keep changes consistent with the shared architecture and processes described in the root documentation.
