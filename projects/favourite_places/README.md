# Favourite Places

A Flutter application for discovering, saving, and managing favorite locations with camera integration, GPS location services, and Google Maps.

## Features

- **Place Management**: Add, view, and manage your favorite places
- **Camera Integration**: Capture photos directly from the device camera
- **GPS Location**: Get current location with permission handling
- **Interactive Maps**: Select locations on Google Maps with tap-to-select
- **Reverse Geocoding**: Convert coordinates to human-readable addresses
- **Local Storage**: Persist data with SQLite database
- **Offline Support**: Images stored locally in app documents directory

## Technologies Used

| Technology | Purpose |
|------------|---------|
| **Flutter Riverpod** | State management (StateNotifier pattern) |
| **Google Maps Flutter** | Interactive map display |
| **Google Maps APIs** | Geocoding and static map previews |
| **SQLite (sqflite)** | Local database persistence |
| **image_picker** | Camera access for photo capture |
| **location** | GPS/location services |
| **path_provider** | File system path management |
| **Google Fonts** | Ubuntu Condensed typography |

## Project Structure

```
lib/
├── main.dart                 # App entry point with theme configuration
├── models/
│   └── place.dart           # Place and PlaceLocation data models
├── providers/
│   └── user_places.dart     # Riverpod StateNotifier for place management
├── screens/
│   ├── places.dart          # Home screen with places list
│   ├── add_place.dart       # Form to add new places
│   ├── place_detail.dart    # Detailed view with image and map
│   └── map.dart             # Interactive Google Maps screen
└── widgets/
    ├── places_list.dart     # ListView of saved places
    ├── image_input.dart     # Camera capture widget
    └── location_input.dart  # Location selection widget
```

## Data Models

### Place
- `id`: Unique identifier (UUID)
- `title`: Place name
- `image`: File reference to captured photo
- `location`: PlaceLocation object

### PlaceLocation
- `latitude`: Geographic latitude
- `longitude`: Geographic longitude
- `address`: Human-readable address from geocoding

## Database Schema

SQLite database (`places.db`) with `user_places` table:

| Column | Type | Description |
|--------|------|-------------|
| id | TEXT | Primary key (UUID) |
| title | TEXT | Place name |
| image | TEXT | File path to image |
| lat | REAL | Latitude |
| lng | REAL | Longitude |
| address | TEXT | Geocoded address |

## Key Implementation Details

### State Management
- Uses Riverpod's `StateNotifier` pattern
- `userPlacesProvider` manages the list of places
- `loadPlaces()` loads from SQLite on app startup
- `addPlace()` handles image copying and database insertion

### Location Flow
1. Request location permissions
2. Get current GPS coordinates or select on map
3. Reverse geocode to get address via Google Maps API
4. Display static map preview

### Image Handling
1. Capture photo with image_picker (600px max width)
2. Copy to app documents directory for persistence
3. Store file path in SQLite database

## Screens

| Screen | Description |
|--------|-------------|
| **PlacesScreen** | Main list view with FloatingActionButton to add |
| **AddPlaceScreen** | Form with title input, image capture, location selection |
| **PlaceDetailScreen** | Full-screen image with address and static map |
| **MapScreen** | Interactive Google Maps for viewing or selecting location |

## Getting Started

1. Clone the repository
2. Run `flutter pub get`
3. Configure Google Maps API:
   - Get API key from Google Cloud Console
   - Enable Maps SDK, Geocoding API, and Static Maps API
   - Add API key to `android/app/src/main/AndroidManifest.xml`
   - Add API key to `ios/Runner/AppDelegate.swift`
4. Run `flutter run`

## Learning Objectives

This project demonstrates:
- State management with Flutter Riverpod (StateNotifier)
- SQLite database operations with sqflite
- Google Maps integration (interactive and static)
- Camera and image handling with image_picker
- Location services with permission handling
- Async/await patterns with FutureBuilder
- File system operations with path_provider
- Custom theming with Google Fonts
- Navigation with data passing between screens
