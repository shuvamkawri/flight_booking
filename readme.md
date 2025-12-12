# ✈️ Flight Booking App

A Flutter-based mobile application for searching and booking flights with a modern UI and clean architecture.

## 📱 App Screens

- **Search Screen**: Search flights with airport selection, date picker, and passenger selector
- **Flight List Screen**: Display search results with filtering and sorting options
- **Flight Detail Screen**: View detailed flight information
- **Booking Screen**: Complete booking process

## 🚀 Features

- **Flight Search**: Search flights by departure/arrival airports, date, and passengers
- **Real-time Filtering**: Filter by price, stops, airlines, and departure time
- **Sorting Options**: Sort by price, duration, departure time, and arrival time
- **Responsive Design**: Modern UI with gradient backgrounds and smooth animations
- **State Management**: Provider pattern for efficient state management
- **API Integration**: REST API integration for flight data
- **Error Handling**: Comprehensive error handling and loading states

## 🛠️ Tech Stack

- **Flutter**: 3.10.0+
- **Dart**: 3.0+
- **State Management**: Provider
- **HTTP Client**: http package
- **Localization**: intl package
- **Caching**: cached_network_image
- **Local Storage**: shared_preferences
- **Connectivity**: connectivity_plus
- **Environment Variables**: flutter_dotenv
- **Pull to Refresh**: pull_to_refresh
- **Loading Animations**: flutter_spinkit
- **Calendar**: table_calendar

## 🔧 Installation & Setup

### Prerequisites

- Flutter SDK 3.10.0 or higher
- Dart 3.0 or higher
- Android Studio/VSCode with Flutter extensions
- Android emulator or physical device

⏱️ Development Time
Approximate hours taken: 12-16 hours

Breakdown:

Project setup and architecture: 2 hours

UI implementation: 4-5 hours

API integration: 3 hours

State management: 2 hours

Testing and bug fixes: 2-3 hours

Documentation: 1 hour

### Steps to Run

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd flight_booking_app

   # Generate release APK
flutter build apk --release

# For app bundle (Play Store)
flutter build appbundle --release

# APK Location: build/app/outputs/flutter-apk/app-release.apk
# App Bundle: build/app/outputs/bundle/release/app-release.aab