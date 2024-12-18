
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

## i18n, i10n

Files for configuring internationalization are found under assets/translations.  
There, `en.json` and `es.json` contain the tokens and strings needed for the translation of the app.  
The currency is controlled by `currency` key, in order to change the currency to pounds we could for example change `currency` to GBP in the en.json file.  
In order to reload the tokens we can use the following command

```bash  
flutter pub run easy_localization:generate -S 'assets/translations' -O "lib/translations" 
```

## Push Notifications

There are 3 events that trigger a push notification being sent:

- A volunteer is accepted to the volunteering.
- A volunteer is rejected from the volunteering.
- A new news article is uploaded.

In the  `cloudFunctions/functions` directory the following Cloud Functions can be found:

- on_update function for `volunteering/{volunteering_id}`
- on_create function for `news/{news_id}`

## Google Maps: Key Configuration

To use Google Maps in the app, you need to configure the API key in the Android and iOS projects. Here's how you can do it:

### Android

1. Get the API key from the Google Cloud Console.
2. Go to the 'android/local.properties' file and add the following line:

```text googleMapsApiKey=[INSERT_YOUR_API_KEY]   
```   
### iOS

1. Get the API key from the Google Cloud Console.
2. Go to the 'ios/Flutter/Debug.xcconfig' files and add the following line:

```text GOOGLE_MAPS_API_KEY = [INSERT_YOUR_API_KEY]   
```  

## Event Logging

### Login

Logging the `login` event is crucial for monitoring how often users return to the app, providing clear insights into user retention. It also helps identify potential issues in the login process and assess the impact of new features or changes in the user experience. This event serves as a key indicator for analyzing user engagement levels.

### Sign Up

The `sign_up` event is essential for understanding how many new users register in the app. Eventually, this can also help which registration methods they prefer (email, Google, Facebook, etc.) in case more are implemented. This helps evaluate the effectiveness of user acquisition strategies and optimize the registration process to make it more accessible and appealing. Additionally, it helps identify growth trends and measure the impact of new volunteerings being added.

### Share

The `share` event is important because it measures the social interaction of users with the app's content, specifically the news. By logging the IDs of the shared news, it's possible to identify which articles are the most relevant or popular among users. This not only helps optimize content creation but also enables the design of more effective strategies based on the content that generates the most interest.

## Tests

### Tags

The following tags are used to organize the tests in the project:

- **golden**: Tests related to golden image comparisons to ensure UI consistency.
- **news**: Tests related to the news functionality.
- **user**: Tests related to user authentication and profile management.
- **volunteering**: Tests related to the volunteering functionality.

You can filter and run tests using these tags with the `-t` or `--tags` flag:

```bash  
flutter test -t goldenflutter test -t newsflutter test -t userflutter test -t volunteering
```  

The tags config can be found in the `dart_test.yaml` file.