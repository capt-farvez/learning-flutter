# Multi Counter App

A Flutter app that allows users to create and manage multiple counters, each with a custom title.

## Features

- Create multiple counters with custom titles (max 18 characters)
- Increment, decrement, and reset each counter independently
- Edit counter titles
- Delete counters
- Counter auto-resets to 0 when exceeding +10 or -10 (with popup notification)
- Dark/Light theme toggle

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed
- An editor (VS Code, Android Studio, etc.)
- For mobile: Android emulator or iOS simulator
- For desktop: Windows, macOS, or Linux setup

## How to Run

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd counter_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

   Or specify a device:
   ```bash
   flutter run -d windows
   flutter run -d chrome
   flutter run -d <emulator-id>
   ```

## Usage

1. Tap the **+** button to create a new counter
2. Enter a title (max 18 characters) and tap **Create**
3. Use the buttons on each counter card:
   - **-** to decrement
   - **0** to reset
   - **+** to increment
4. Tap the **pencil icon** to edit the counter title
5. Tap the **trash icon** to delete a counter
6. Tap the **sun/moon icon** in the app bar to toggle dark/light theme

## Useful Commands

| Command | Description |
|---------|-------------|
| `flutter devices` | List available devices |
| `flutter run` | Run the app |
| `flutter build apk` | Build Android APK |
| `flutter build windows` | Build Windows executable |
