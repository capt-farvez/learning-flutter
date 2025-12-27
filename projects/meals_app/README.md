# Meals App

A Flutter recipe application for browsing meals by category with filtering and favorites functionality.

## Features

- **Category Grid**: Browse meals organized by categories (Italian, Quick & Easy, etc.)
- **Meal Details**: View ingredients and step-by-step cooking instructions
- **Favorites**: Mark meals as favorites with star icon, view in dedicated tab
- **Dietary Filters**: Filter meals by dietary preferences:
  - Gluten-free
  - Lactose-free
  - Vegetarian
  - Vegan
- **Tab Navigation**: Bottom navigation bar for Categories and Favorites
- **Drawer Navigation**: Side drawer for accessing Filters screen
- **Dark Theme**: Custom dark color scheme with Google Fonts

## Project Structure

```
lib/
├── main.dart                    # App entry point and theme
├── data/
│   └── dummy_data.dart          # Sample meals and categories data
├── models/
│   ├── category.dart            # Category data model
│   └── meal.dart                # Meal model with complexity/affordability
├── screens/
│   ├── tabs.dart                # Main screen with bottom navigation
│   ├── categories.dart          # Category grid screen
│   ├── meals.dart               # Meals list screen
│   ├── meal_details.dart        # Individual meal details
│   └── filters.dart             # Dietary filters screen
└── widgets/
    ├── main_drawer.dart         # Navigation drawer
    ├── category_grid_item.dart  # Category card widget
    ├── meal_item.dart           # Meal card widget
    └── meal_item_trait.dart     # Meal trait display (duration, complexity)
```

## Concepts Covered

- Multi-screen navigation with `Navigator.push()` and named routes
- Passing data between screens and receiving results
- Bottom navigation with `BottomNavigationBar`
- Drawer navigation with `Drawer` widget
- State lifting for favorites management
- Filtering data with `where()` method
- `WillPopScope` for handling back navigation with data

## Dependencies

- `google_fonts`: Custom typography

## Getting Started

```bash
flutter pub get
flutter run
```
