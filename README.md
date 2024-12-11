# Ser Manos

## Tech Stack

Each technology in the stack was chosen to enhance the app's functionality, maintainability, and user experience. These choices are further documented in the README and the presentation.

### Core

- **Flutter**: The main framework for developing a cross-platform mobile application.
- **Dart**: Programming language used with Flutter for fast, expressive UI.

### State Management

- **Riverpod (flutter\_riverpod)**: Chosen for predictable, manageable state management across the app.
- **flutter\_hooks**: Simplifies code for widget lifecycle and logic.

### Navigation

- **GoRouter**: Handles navigation and routing within the app, including for nested routes and deep linking.

### Firebase

- **firebase\_core & firebase\_auth**: Used for user authentication and core app services.
- **firebase\_storage & cloud\_firestore**: Data storage and retrieval.

### Other Integrations

- **Google Maps Flutter**: For map display and custom markers.
- **carousel\_slider**: Used for the interactive volunteer cards carousel at the bottom of the screen.
- **geolocator**: Retrieves user location for improved map interaction.
- **intl & flutter\_localizations**: Adds internationalization and localization support.

### Development Tools

- **build\_runner**: Automates code generation.
- **json\_serializable**: Enables JSON serialization for network calls.

## Accepting a User for Volunteering from Firebase

To accept a user who has applied for a volunteering position, you need to update the user's status in Firebase. Here's how you can do it:

1. Go to the Firebase Console and navigate to the Firestore database.
2. Find the 'volunteerings' collection and locate the document with the respective ID.
3. Each volunteering has an 'applicants' Map field, where the key is the user's ID and the value is the user's acceptance status (true or false). Update the status to true to accept the user.

## Google Maps: Key Configuration

To use Google Maps in the app, you need to configure the API key in the Android and iOS projects. Here's how you can do it:

### Android

1. Get the API key from the Google Cloud Console.
2. Go to the 'android/local.properties' file and add the following line:

```text
googleMapsApiKey=[INSERT_YOUR_API_KEY]
```

### iOS

1. Get the API key from the Google Cloud Console.
2. Go to the 'ios/Flutter/Debug.xcconfig' files and add the following line:

```text
GOOGLE_MAPS_API_KEY = [INSERT_YOUR_API_KEY]
```
