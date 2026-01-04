# Roll Dice App

A simple Flutter app that simulates rolling a dice with a beautiful gradient background.

![Roll Dice App](assets/screenshots/roll_dice_app.png)

## Features

- Roll a 6-sided dice with random results
- Gradient background with customizable colors
- Visual dice images (1-6)
- Debug mode logging for dice rolls

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── screens/
│   └── dice_screen.dart               # Main dice screen
└── widgets/
    ├── dice_roller.dart               # Dice rolling logic and UI
    ├── gradient_container.dart        # Gradient background widget
    └── styled_text.dart               # Reusable styled text widget
```

## Run the App

```bash
flutter pub get
flutter run
```
