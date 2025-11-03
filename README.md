# 📱 Shake for Inspiration

<div align="center">

**Get motivated with a shake!** ✨

A beautiful Flutter application that displays inspirational quotes when you shake your Android device. Built with Flutter UI and native Android (Kotlin) sensor integration.

[![Flutter](https://img.shields.io/badge/Flutter-3.8+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.8+-blue.svg)](https://dart.dev/)
[![Kotlin](https://img.shields.io/badge/Kotlin-Android-green.svg)](https://kotlinlang.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Screenshots](#-screenshots)
- [Architecture](#-architecture)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Usage](#-usage)
- [Project Structure](#-project-structure)
- [Technical Details](#-technical-details)
- [Configuration](#-configuration)
- [Troubleshooting](#-troubleshooting)
- [Future Enhancements](#-future-enhancements)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🎯 Overview

**Shake for Inspiration** is a motivational Flutter application that combines beautiful UI with native Android capabilities. Simply shake your device, and receive an instant dose of inspiration through carefully curated motivational quotes.

This project demonstrates:

- **Native Android Integration**: Using Kotlin to access device sensors
- **Platform Channels**: Communication between Flutter and native code
- **Modern Flutter UI**: Beautiful animations and Material Design 3
- **Real-time Sensor Data**: Accelerometer-based shake detection

### User Story

> _"As a student who loves motivation, I want my phone to show a random motivational quote whenever I shake it — so I can get an instant dose of inspiration during study sessions without touching the screen!"_

---

## ✨ Features

### Core Features

- 📳 **Shake Detection**: Advanced accelerometer-based shake detection using native Android sensors
- 💬 **Random Quotes**: 30+ handpicked motivational quotes
- 🎨 **Beautiful Animations**: Smooth fade, scale, and slide animations
- 📊 **Statistics**: Track the number of quotes you've received
- 📋 **Share Quotes**: Copy quotes to clipboard with one tap
- 🎯 **Manual Mode**: Get quotes instantly with a button (no shaking needed)
- 📱 **Portrait Lock**: Optimized for portrait orientation

### Technical Features

- ✅ **Low-Pass Filtering**: Reduces noise in sensor data for accurate detection
- ✅ **Debouncing**: Prevents shake spam (minimum 500ms between detections)
- ✅ **Error Handling**: Robust error handling and stream management
- ✅ **Memory Efficient**: Proper resource cleanup and disposal
- ✅ **Haptic Feedback**: Tactile feedback for better UX

---

## 📸 Screenshots

<div align="center">

|             Main Screen              |              Quote Display              |
| :----------------------------------: | :-------------------------------------: |
| ![Main Screen](screenshots/main.png) | ![Quote Display](screenshots/quote.png) |

_Note: Add your screenshots to the `screenshots/` directory_

</div>

---

## 🏗️ Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Flutter Layer                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │   UI Layer   │  │ Service Layer│  │  Data Layer   │  │
│  │  (main.dart) │  │(shake_service│  │ (quotes.dart)│  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────┘
                          │
                          │ Platform Channels
                          │ (EventChannel, MethodChannel)
                          ▼
┌─────────────────────────────────────────────────────────┐
│                 Native Android Layer                      │
│  ┌──────────────┐  ┌──────────────┐                      │
│  │ MainActivity │  │ShakeDetector  │                      │
│  │  (Kotlin)    │  │   (Kotlin)    │                      │
│  └──────────────┘  └──────────────┘                      │
│                          │                                │
│                          ▼                                │
│                  ┌─────────────────┐                      │
│                  │  SensorManager  │                      │
│                  │  (Accelerometer)│                      │
│                  └─────────────────┘                      │
└─────────────────────────────────────────────────────────┘
```

### Communication Flow

1. **Sensor Detection**: `SensorManager` detects accelerometer changes
2. **Shake Detection**: `ShakeDetector` processes data and detects shakes
3. **Event Channel**: Native sends `shake_detected` event to Flutter
4. **UI Update**: Flutter receives event and displays a random quote
5. **Animation**: Smooth animations enhance the user experience

---

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.8.1 or higher)

  ```bash
  flutter --version
  ```

- **Dart SDK** (3.8.1 or higher - comes with Flutter)

- **Android Studio** or **VS Code** with Flutter extensions

- **Android SDK** with minimum API level 21 (Android 5.0)

- **Physical Android Device** (recommended) or Android Emulator

  > ⚠️ **Note**: Shake detection works best on physical devices. Emulators may not accurately simulate shake gestures.

- **Kotlin** (for Android development)

---

## 🚀 Installation

### Step 1: Clone the Repository

```bash
git clone https://github.com/yourusername/shake_quote_flutter_ui_with_native_android.git
cd shake_quote_flutter_ui_with_native_android
```

### Step 2: Install Dependencies

```bash
flutter pub get
```

### Step 3: Verify Installation

```bash
flutter doctor
```

Ensure all checks pass, especially:

- ✅ Flutter (Channel stable)
- ✅ Android toolchain
- ✅ Android Studio / VS Code

### Step 4: Connect Your Device

**Physical Device:**

1. Enable Developer Options and USB Debugging on your Android device
2. Connect via USB
3. Run `flutter devices` to verify connection

**Emulator:**

1. Start an Android emulator from Android Studio
2. Verify with `flutter devices`

### Step 5: Run the Application

```bash
flutter run
```

Or use your IDE's run button.

---

## 📱 Usage

### Basic Usage

1. **Launch the App**: Open "Shake for Inspiration" on your device
2. **Shake Your Device**: Gently shake your phone
3. **Receive Quote**: A motivational quote will appear with smooth animations
4. **Interact**:
   - **Tap the quote card** to close it
   - **Swipe down** to dismiss
   - **Tap share icon** to copy quote to clipboard
   - **Tap "Get Quote Now"** button to get a quote without shaking

### Shake Detection Tips

- **Moderate Shaking**: The algorithm detects significant acceleration changes
- **Minimum Interval**: Wait at least 0.5 seconds between shakes
- **Device Orientation**: Works best in portrait mode (app locks orientation)
- **Sensitivity**: Default threshold is optimized for most devices

### Features

- **Statistics Badge**: Top-right corner shows total quotes received
- **Auto-Hide**: Quotes automatically disappear after 6 seconds
- **Haptic Feedback**: Feel a vibration when shake is detected
- **Share**: Copy quotes to share with friends

---

## 📁 Project Structure

```
shake_quote_flutter_ui_with_native_android/
│
├── lib/
│   ├── main.dart                    # Main Flutter app entry point
│   ├── data/
│   │   └── quotes.dart              # Quotes data and random selection
│   └── services/
│       └── shake_service.dart      # Platform channel communication
│
├── android/
│   └── app/
│       └── src/
│           └── main/
│               └── kotlin/
│                   └── com/
│                       └── example/
│                           └── shake_quote_flutter_ui_with_native_android/
│                               ├── MainActivity.kt    # Platform channel setup
│                               └── ShakeDetector.kt   # Shake detection logic
│
├── pubspec.yaml                     # Flutter dependencies
├── README.md                        # This file
└── analysis_options.yaml            # Linting rules
```

### Key Files Explained

| File                              | Description                                            |
| --------------------------------- | ------------------------------------------------------ |
| `lib/main.dart`                   | Main UI, animations, and state management              |
| `lib/services/shake_service.dart` | Handles EventChannel and MethodChannel communication   |
| `lib/data/quotes.dart`            | Contains motivational quotes collection                |
| `android/.../MainActivity.kt`     | Sets up platform channels and manages sensor lifecycle |
| `android/.../ShakeDetector.kt`    | Core shake detection algorithm with filtering          |

---

## 🔧 Technical Details

### Shake Detection Algorithm

The `ShakeDetector` uses a sophisticated approach:

1. **Low-Pass Filter**: Reduces noise from accelerometer data

   ```kotlin
   filteredX = filterAlpha * filteredX + (1 - filterAlpha) * x
   ```

2. **Force Vector Calculation**: Computes acceleration change magnitude

   ```kotlin
   acceleration = sqrt(deltaX² + deltaY² + deltaZ²)
   ```

3. **Threshold Check**: Compares against configurable threshold (default: 12.0 m/s²)

4. **Debouncing**: Prevents multiple triggers (500ms minimum interval)

### Platform Channels

- **EventChannel** (`com.example.shake_quote/shake_events`): Streams shake events from native to Flutter
- **MethodChannel** (`com.example.shake_quote/shake_methods`): Allows Flutter to control detection (start/stop)

### Animations

- **Fade Animation**: 600ms ease-in-out
- **Scale Animation**: 400ms elastic-out bounce
- **Slide Animation**: Smooth entrance from bottom
- **Icon Pulse**: Continuous subtle pulse effect

---

## ⚙️ Configuration

### Adjusting Shake Sensitivity

Edit `android/app/src/main/kotlin/.../MainActivity.kt`:

```kotlin
shakeDetector = ShakeDetector(
    onShakeDetected = { /* callback */ },
    shakeThreshold = 12.0f,      // Lower = more sensitive
    shakeSlopTimeMs = 500L,       // Time between shakes (ms)
    filterAlpha = 0.8f            // Filter strength (0.0-1.0)
)
```

### Modifying Quote Display Duration

Edit `lib/main.dart`:

```dart
class AppConstants {
  static const Duration quoteDisplayDuration = Duration(seconds: 6);
  // ... other constants
}
```

### Adding More Quotes

Edit `lib/data/quotes.dart`:

```dart
static final List<String> motivationalQuotes = [
  "Your new quote here!",
  // ... existing quotes
];
```

---

## 🐛 Troubleshooting

### Common Issues

#### Shake Detection Not Working

**Problem**: Shakes aren't being detected.

**Solutions**:

1. ✅ Ensure you're using a **physical device** (emulators may not work)
2. ✅ Check sensor permissions in `AndroidManifest.xml`
3. ✅ Increase shake sensitivity (lower threshold)
4. ✅ Shake more vigorously
5. ✅ Wait at least 500ms between shakes

#### App Crashes on Launch

**Problem**: App crashes immediately after opening.

**Solutions**:

1. ✅ Run `flutter clean && flutter pub get`
2. ✅ Check Flutter version: `flutter --version`
3. ✅ Verify Android SDK is properly configured
4. ✅ Check logcat for detailed error: `adb logcat`

#### Build Errors

**Problem**: Build fails with Gradle/Kotlin errors.

**Solutions**:

1. ✅ Update Android SDK and build tools
2. ✅ Check `android/build.gradle.kts` for correct Kotlin version
3. ✅ Invalidate caches in Android Studio
4. ✅ Delete `.gradle` folder and rebuild

#### Stream Errors

**Problem**: `PlatformException` or stream errors.

**Solutions**:

1. ✅ Ensure app is running on Android (not iOS/web)
2. ✅ Check channel names match in both Kotlin and Dart
3. ✅ Verify `MainActivity` properly sets up channels
4. ✅ Check device supports accelerometer sensor

### Debug Mode

Enable verbose logging:

```dart
// In main.dart
debugPrint('Shake detected!');
```

Check native logs:

```bash
adb logcat | grep -i shake
```

---

## 🚧 Future Enhancements

Potential improvements for future versions:

- [ ] **iOS Support**: Implement CoreMotion for iPhone shake detection
- [ ] **Quote Categories**: Organize quotes by themes (motivation, success, etc.)
- [ ] **Favorites**: Save favorite quotes for later
- [ ] **Quote History**: View previously shown quotes
- [ ] **Custom Quotes**: Allow users to add their own quotes
- [ ] **Themes**: Dark mode and color scheme options
- [ ] **Notifications**: Daily quote notifications
- [ ] **Statistics**: More detailed analytics (quotes per day, etc.)
- [ ] **Offline Mode**: Download quotes for offline access
- [ ] **Social Sharing**: Share quotes directly to social media

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. **Fork the Repository**
2. **Create a Feature Branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make Your Changes**
   - Follow Flutter/Dart style guidelines
   - Add comments for complex logic
   - Update documentation as needed
4. **Test Thoroughly**
   - Test on physical Android device
   - Verify animations work smoothly
   - Check for memory leaks
5. **Commit Changes**
   ```bash
   git commit -m "Add: amazing feature"
   ```
6. **Push to Branch**
   ```bash
   git push origin feature/amazing-feature
   ```
7. **Open a Pull Request**

### Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Use meaningful variable and function names
- Add documentation for public APIs
- Keep functions focused and small

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2024 Shake for Inspiration

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction...
```

---

## 👏 Acknowledgments

- **Flutter Team**: For the amazing cross-platform framework
- **Android Sensors API**: For accelerometer capabilities
- **Inspirational Quotes**: Collected from various motivational sources

---

## 📞 Contact & Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/shake_quote_flutter_ui_with_native_android/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/shake_quote_flutter_ui_with_native_android/discussions)

---

<div align="center">

**Made with ❤️ using Flutter & Kotlin**

⭐ Star this repo if you found it helpful!

</div>
