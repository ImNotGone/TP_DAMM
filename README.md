# Ser Manos - DAMM

## Tech Stack
Each technology in the stack was chosen to enhance the app's functionality, maintainability, and user experience. These choices are further documented in the README and the presentation.

### Core
- **Flutter**: The main framework for developing a cross-platform mobile application.
- **Dart**: Programming language used with Flutter for fast, expressive UI.

### State Management
- **Riverpod (flutter_riverpod)**: Chosen for predictable, manageable state management across the app.
- **flutter_hooks**: Simplifies code for widget lifecycle and logic.

### Navigation
- **GoRouter**: Handles navigation and routing within the app, including for nested routes and deep linking.

### Firebase
- **firebase_core & firebase_auth**: Used for user authentication and core app services.
- **firebase_storage & cloud_firestore**: Data storage and retrieval.

### Other Integrations
- **Google Maps Flutter**: For map display and custom markers.
- **carousel_slider**: Used for the interactive volunteer cards carousel at the bottom of the screen.
- **geolocator**: Retrieves user location for improved map interaction.
- **intl & flutter_localizations**: Adds internationalization and localization support.

### Development Tools
- **build_runner**: Automates code generation.
- **json_serializable**: Enables JSON serialization for network calls.