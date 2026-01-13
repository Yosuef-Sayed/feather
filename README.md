# Feather 🪶

A premium, feature-rich weather application built with Flutter, focused on sleek aesthetics, real-time data, and high-performance architecture.

![Feather App Banner](https://via.placeholder.com/800x400.png?text=Feather+Weather+App)

## ✨ Features

- **📍 Dynamic Location Handling**: Automatic GPS-based weather fetching or manual city management.
- **🔍 Smart Search**: Real-time city search integrated with the Open-Meteo Geocoding API.
- **🌆 Modern UI**: Glassmorphism design elements, localized dark themes, and dynamic gradients that change with the weather and time of day.
- **⚙️ Advanced Settings**:
  - Comprehensive unit conversions for Temperature (°C, °F, K), Wind Speed (km/h, mph, m/s, knots), Pressure, and more.
  - Persistent user preferences using `SharedPreferences`.
- **📅 Extended Forecasts**: 24-hour hourly projections and up to 16 days of daily forecasts.
- **🏗️ Clean Architecture**: Engineered following the Data-Domain-Presentation pattern for scalability and testability.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
- **API**: [Open-Meteo](https://open-meteo.com)
- **Storage**: [SharedPreferences](https://pub.dev/packages/shared_preferences)
- **Design**: Google Fonts (Poppins), Glass Containers, Flutter Animate.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>= 3.10.4)
- Android Studio / VS Code with Flutter extension
- An emulator or physical device

### Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/yourusername/feather.git
   cd feather
   ```

2. **Install dependencies**:

   ```bash
   flutter pub get
   ```

3. **Generate Assets (Optional but recommended)**:

   ```bash
   # Generate Launcher Icons
   flutter pub run flutter_launcher_icons

   # Generate Native Splash
   flutter pub run flutter_native_splash:create --path=flutter_native_splash.yaml
   ```

4. **Run the app**:
   ```bash
   flutter run
   ```

## 📂 Project Structure

```text
lib/
├── core/             # Shared utilities, themes, and services
├── features/
│   ├── settings/     # Unit preferences and conversions
│   └── weather/      # Core weather fetching and rendering
│       ├── data/     # Models and Remote Data Sources
│       ├── domain/   # Logic and Entities
│       └── presentation/ # UI Components and Providers
└── main.dart         # Entry point
```

## 🤝 Contributing

While this is a personal project, feedback and PRs are welcome! Feel free to open an issue for any bug or feature request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

_Made with ❤️ by Joosayed_
