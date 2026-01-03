# FlutterChat

A real-time messaging application built with Flutter and Firebase, featuring user authentication, profile management, and push notifications.

## Features

- **User Authentication**: Email/password sign-up and login with Firebase Auth
- **Real-time Messaging**: Instant message delivery using Cloud Firestore streams
- **Profile Management**: Custom profile images uploaded to Firebase Storage
- **Push Notifications**: FCM integration with topic-based subscriptions
- **Smart Message Grouping**: Consecutive messages from the same user are visually grouped
- **Responsive UI**: Material Design theme with adaptive layouts

## Technologies Used

- **Flutter SDK** (3.9.2+)
- **Firebase Core** - Firebase initialization
- **Firebase Auth** - User authentication
- **Cloud Firestore** - Real-time database for messages and user profiles
- **Firebase Storage** - Cloud storage for profile images
- **Firebase Messaging** - Push notifications
- **image_picker** - Camera-based image selection

## Project Structure

```
lib/
├── main.dart                 # App entry point with Firebase initialization
├── firebase_options.dart     # Firebase platform configuration
├── screens/
│   ├── splash.dart          # Loading screen during auth check
│   ├── auth.dart            # Login/Signup screen with form validation
│   └── chat.dart            # Main chat interface with notifications setup
└── widgets/
    ├── chat_messages.dart    # StreamBuilder-based message list
    ├── message_bubble.dart   # Individual message UI with user avatars
    ├── new_message.dart      # Message input with send functionality
    └── user_image_picker.dart # Profile image selection widget
```

## Firebase Collections

### users
Stores user profile information:
- `username`: Display name
- `email`: User email address
- `image_url`: Profile image URL from Firebase Storage

### chat
Stores chat messages:
- `text`: Message content
- `createdAt`: Timestamp
- `userId`: Sender's UID
- `username`: Sender's display name
- `userImage`: Sender's profile image URL

## Key Implementation Details

### Authentication Flow
1. User enters credentials and optionally selects a profile image
2. Profile image is uploaded to Firebase Storage
3. User document is created in Firestore with profile data
4. Firebase Auth manages session state via `authStateChanges()` stream

### Real-time Messaging
- `StreamBuilder` listens to Firestore's `chat` collection
- Messages ordered by `createdAt` timestamp (newest first)
- Consecutive messages from same user show cleaner bubble design
- First message in sequence displays user avatar and username

### Push Notifications
- FCM permissions requested on chat screen load
- Users subscribe to `chat` topic for broadcast messages
- Notifications delivered even when app is backgrounded

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Configure Firebase:
   - Create a Firebase project
   - Enable Authentication (Email/Password)
   - Create Firestore database
   - Create Storage bucket
   - Download and add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
4. Run `flutter run` to start the app

## Learning Objectives

This project demonstrates:
- Firebase integration in Flutter applications
- Real-time data synchronization with Firestore streams
- Secure user authentication patterns
- Cloud storage for user-generated content
- Push notification implementation
- Async/await patterns with proper `mounted` checks
- Clean architecture with separated screens and widgets
