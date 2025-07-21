# calorie_tracker_app

A Flutter app for tracking calories and nutrition.

# Description

calorie_tracker_app is a Flutter mobile application designed to help users track their daily calorie intake and nutrition. The app integrates with an external food API to provide food search functionality and allows users to log meals and monitor their nutrition progress. It features onboarding screens, a home dashboard, and a food search interface tailored for different meal types and dates.

## Documentation

The app includes the following main navigation routes:

- **Onboarding**: Initial user onboarding screens.
- **Home**: Main dashboard displaying nutrition progress.
- **Food Search**: Search for food items by meal type and date.

## Setup

### Dependencies

- Flutter SDK (version compatible with Dart SDK ^3.8.1)
- Dart SDK
- Packages used (listed in pubspec.yaml):
  - flutter
  - cupertino_icons
  - sqflite
  - path_provider
  - flutter_riverpod
  - path
  - get_it
  - flutter_native_splash
  - shared_preferences
  - intl
  - dio
  - flutter_dotenv
  - provider
  - cached_network_image
  - collection
  - test_cov_console
  - mockito

### Getting Started

1. Clone the repository:
   ```
   git clone <repository-url>
   ```
2. Navigate to the project directory:
   ```
   cd calorie_tracker_app
   ```
3. Create a `.env` file in the root directory with the following variables (example):
   ```
   FOOD_API_BASE_URL=https://us.openfoodfacts.org
   FOOD_API_ENDPOINT=/cgi/search.pl
   DEFAULT_PAGE_SIZE=20
   REQUEST_TIMEOUT=30000
   ```
4. Install Flutter dependencies:
   ```
   flutter pub get
   ```

### Run The Service

To run the app on an emulator or connected device:

```
flutter run
```

## Testing

To run unit tests:

```
flutter test
```

To run integration tests:

```
flutter test integration_test/
```

## Contribute

Contributions are welcome! Please fork the repository and create a pull request with your changes. Ensure your code follows the existing style and includes tests where applicable.

## Deployment

To build the app for release:

- For Android:
  ```
  flutter build apk --release
  ```
- For iOS:
  ```
  flutter build ios --release
  ```

Follow Flutter's official documentation for deploying to app stores.
