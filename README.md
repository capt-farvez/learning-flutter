# Learning Flutter
Learning the Flutter SDK and Flutter framework for building native iOS and Android apps through Udemy. Instructed by Maximilian Schwarzmüller.

## Resources
- **Course Url:** https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/
- **Course GitHub Repo:** https://github.com/academind/flutter-complete-guide-course-resources
- **Learning Flutter GitHub Repo:** https://github.com/capt-farvez/learning-flutter
- **Roadmap to learn Flutter:** https://roadmap.sh/flutter

## Projects Overview
See [Projects Index](projects/INDEX.md) for a list of all projects with brief descriptions.
Each project's README contains detailed information about features, concepts, and code structure.

### Key Concepts Covered
| Project | Main Focus |
|---------|------------|
| first_app | StatefulWidget, setState, SnackBar |
| counter_app | CRUD operations, ListView, AlertDialog |
| roll_dice_app | Random generation, Modular architecture |
| quiz_app | Multi-screen navigation, Data models |
| expense_tracker | Charts, Modal sheets, Responsive layouts |
| todo_app | Flutter Keys, Widget lifecycle, Element tree |
| meals_app | Riverpod, Tab navigation, Drawer, Filters |
| shopping_list_app | HTTP networking, Firebase REST API, Async/await |
| favourite_places | Image picker, Google Maps, SQLite, Provider | 


## Setup & Installation
- **Flutter Installation:** https://docs.flutter.dev/get-started/install
- **Android Studio Setup:** https://developer.android.com/studio
- **VS Code Setup for Flutter:** https://docs.flutter.dev/tools/vs-code
- **Flutter DevTools:** https://docs.flutter.dev/tools/devtools

## Important Flutter CLI Commands

### Project Management
```bash
flutter create <project_name>       # Create new Flutter project with default template
flutter run                         # Run app in debug mode on connected device/emulator
flutter run --release               # Run in release mode (optimized, no debug features)
```

### Build
```bash
flutter build apk                   # Build Android APK (debug) -> build/app/outputs/flutter-apk/
flutter build apk --release         # Build release APK for distribution
flutter build appbundle             # Build Android App Bundle (.aab) for Play Store
flutter build ios                   # Build iOS app (requires macOS with Xcode)
flutter build web                   # Build web app -> build/web/
flutter build windows               # Build Windows .exe -> build/windows/
flutter build macos                 # Build macOS app (requires macOS)
flutter build linux                 # Build Linux app -> build/linux/
```

### Enable Desktop Platforms
```bash
flutter config --enable-windows-desktop   # Enable Windows desktop support
flutter config --enable-macos-desktop     # Enable macOS desktop support
flutter config --enable-linux-desktop     # Enable Linux desktop support
```

### Dependencies
```bash
flutter pub get                     # Download all dependencies from pubspec.yaml
flutter pub upgrade                 # Upgrade dependencies to latest versions
flutter pub outdated                # Show outdated packages
flutter pub add <package>           # Add new package to pubspec.yaml and download
flutter pub remove <package>        # Remove package from pubspec.yaml
```

### Development
```bash
flutter doctor                      # Check Flutter installation and environment setup
flutter doctor -v                   # Detailed environment check with verbose output
flutter devices                     # List all connected devices and emulators
flutter emulators                   # List available emulators
flutter clean                       # Delete build/ and .dart_tool/ folders
flutter test                        # Run all unit and widget tests
flutter analyze                     # Analyze code for errors and warnings
```

### Hot Reload (while app is running)
```
r                                   # Hot reload - apply code changes instantly
R                                   # Hot restart - restart app with new code
q                                   # Quit the running app
```

### Debugging & Profiling
```bash
flutter logs                        # Show real-time device logs
flutter attach                      # Attach debugger to running Flutter app
flutter screenshot                  # Take screenshot of running app
flutter run --profile               # Run in profile mode for performance testing
```

### Flavors & Environments
```bash
flutter run --flavor dev            # Run app with specific flavor (dev/staging/prod)
flutter run --dart-define=ENV=prod  # Pass compile-time environment variables
flutter build apk --flavor prod     # Build APK for specific flavor
```

### Check Flutter Installation
```bash
flutter --version                   # Show Flutter SDK version, channel, and Dart version
where flutter                       # (Windows) Show Flutter installation path
which flutter                       # (macOS/Linux) Show Flutter installation path
flutter sdk-path                    # Print the Flutter SDK path
```