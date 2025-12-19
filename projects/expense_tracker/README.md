# Expense Tracker

A Flutter application for tracking personal expenses with visual analytics.

## Features

- **Add Expenses**: Create expenses with title, amount, date, and category
- **Categories**: Organize expenses into Food, Travel, Leisure, and Work
- **Visual Chart**: Bar chart showing expense distribution by category
- **Swipe to Delete**: Remove expenses with swipe gesture
- **Undo Delete**: Restore accidentally deleted expenses via snackbar action
- **Dark Mode**: Automatic theme switching based on system preference
- **Responsive Layout**: Adapts between portrait and landscape orientations

## Project Structure

```
lib/
├── main.dart                 # App entry point and theme configuration
├── models/
│   └── expense.dart          # Expense and ExpenseBucket data models
└── widgets/
    ├── expenses.dart         # Main expenses screen
    ├── new_expense.dart      # Add expense modal form
    ├── chart/
    │   ├── chart.dart        # Expense chart container
    │   └── chart_bar.dart    # Individual chart bar
    └── expenses_list/
        ├── expenses_list.dart    # Scrollable expense list
        └── expense_item.dart     # Single expense card
```

## Dependencies

- `uuid`: Unique ID generation for expenses
- `intl`: Date formatting

## Getting Started

```bash
flutter pub get
flutter run
```
