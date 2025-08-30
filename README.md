# 🕌 Mishkat Al-Masabih - Islamic Hadith Library App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.7+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.7+-blue.svg)
![BLoC](https://img.shields.io/badge/BLoC-8.1.4-green.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

**A beautifully designed, feature-rich Islamic Hadith library application built with Flutter**

[![App Screenshot](assets/images/app_logo.png)](https://github.com/yourusername/mishkat_almasabih)

</div>

---

## 📖 Table of Contents

- [🌟 Overview](#-overview)
- [✨ Features](#-features)
- [🏗️ Architecture](#️-architecture)
- [🎨 Design System](#-design-system)
- [📱 Screenshots](#-screenshots)
- [🛠️ Tech Stack](#️-tech-stack)
- [📁 Project Structure](#-project-structure)
- [🚀 Getting Started](#-getting-started)
- [🧪 Testing](#-testing)
- [📚 Documentation](#-documentation)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

---

## 🌟 Overview

**Mishkat Al-Masabih** is a comprehensive Islamic Hadith library application that provides users with access to authentic Islamic texts, daily hadiths, and a beautiful reading experience. The app follows modern software engineering principles and implements a stunning Islamic-themed design system.

### 🎯 **Key Highlights**
- **17 Major Islamic Books** with comprehensive content
- **Beautiful Islamic Design** with purple and gold color scheme
- **Clean Architecture** following SOLID principles
- **State Management** using BLoC pattern
- **Responsive Design** optimized for all devices
- **Arabic RTL Support** with proper text direction
- **Offline Capabilities** with local data storage

---

## ✨ Features

### 📚 **Core Library Features**
- **Daily Hadith**: New hadith every day with explanations
- **Book Categories**: Organized by Islamic topics and themes
- **Chapter Navigation**: Easy browsing through book chapters
- **Search Functionality**: Advanced search across all content
- **Bookmarking System**: Save favorite hadiths and passages
- **Reading Progress**: Track your reading journey

### 🔐 **Authentication & User Management**
- **User Registration**: Secure account creation
- **Login System**: Multiple authentication methods
- **Google Sign-In**: OAuth integration
- **Profile Management**: User preferences and settings
- **Data Synchronization**: Cloud backup and sync

### 🎨 **User Experience Features**
- **Islamic Design Theme**: Authentic cultural aesthetics
- **Dark/Light Mode**: Comfortable reading in any environment
- **Responsive Layout**: Optimized for all screen sizes
- **Smooth Animations**: Enhanced user interactions
- **Accessibility**: Screen reader support and high contrast

### 📱 **Technical Features**
- **Offline Reading**: Download content for offline access
- **Push Notifications**: Daily hadith reminders
- **Share Functionality**: Share hadiths with others
- **Multi-language Support**: Arabic and English interfaces
- **Performance Optimized**: Fast loading and smooth scrolling

---

## 🏗️ Architecture

### **Clean Architecture Implementation**

The app follows **Clean Architecture** principles with a **Feature-First** organization, ensuring maintainability, scalability, and testability.

```
┌─────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                   │
├─────────────────────────────────────────────────────────────┤
│  • Screens (UI)                                            │
│  • Widgets (Reusable Components)                           │
│  • BLoC Cubits (State Management)                          │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      BUSINESS LOGIC LAYER                   │
├─────────────────────────────────────────────────────────────┤
│  • Use Cases                                              │
│  • Business Rules                                         │
│  • Validation Logic                                       │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                         DATA LAYER                         │
├─────────────────────────────────────────────────────────────┤
│  • Repositories                                           │
│  • Data Sources (API/Local)                               │
│  • Models                                                 │
└─────────────────────────────────────────────────────────────┘
```

### **State Management with BLoC**

- **Predictable State Flow**: Clear event → state → UI flow
- **Separation of Concerns**: Business logic isolated from UI
- **Testability**: Easy to test business logic independently
- **Scalability**: Simple to add new features and states

### **Dependency Injection**

- **GetIt Container**: Centralized dependency management
- **Lazy Loading**: Services initialized only when needed
- **Testability**: Easy to mock dependencies for testing
- **Loose Coupling**: Components are easily replaceable

---

## 🎨 Design System

### **Islamic Color Palette**

Our design system is built around authentic Islamic aesthetics:

```dart
// Primary Colors
primaryPurple: #7440E9    // Main brand color
primaryGold: #FFB300      // Islamic gold accents
secondaryPurple: #9D7BF0  // Light purple variations

// Semantic Colors
hadithAuthentic: #4CAF50  // صحيح - Green
hadithGood: #9C27B0       // حسن - Purple  
hadithWeak: #FF9800       // ضعيف - Orange
```

### **Typography System**

- **Primary Font**: Amiri (Arabic-optimized)
- **Fallback Font**: YaModernPro
- **Responsive Sizing**: Using ScreenUtil for adaptive typography
- **Hierarchical Styles**: Clear text hierarchy for better readability

### **Component Design**

- **Card-based Layout**: Clean, organized information display
- **Islamic Patterns**: Subtle geometric overlays
- **Gradient Backgrounds**: Beautiful color transitions
- **Enhanced Shadows**: Depth and visual hierarchy
- **Rounded Corners**: Modern, friendly appearance

---

## 📱 Screenshots

<div align="center">

### 🏠 Home Screen
![Home Screen](assets/images/screenshots/home_screen.png)

### 📖 Daily Hadith
![Daily Hadith](assets/images/screenshots/daily_hadith.png)

### 🔍 Search Interface
![Search](assets/images/screenshots/search_screen.png)

### 📚 Library View
![Library](assets/images/screenshots/library_screen.png)

</div>

---

## 🛠️ Tech Stack

### **Frontend Framework**
- **Flutter 3.7+**: Cross-platform mobile development
- **Dart 3.7+**: Modern, type-safe programming language

### **State Management**
- **flutter_bloc 8.1.4**: Predictable state management
- **get_it 7.6.7**: Dependency injection container

### **Networking & API**
- **Dio 5.0.0**: HTTP client with interceptors
- **Retrofit 4.0.3**: Type-safe HTTP client
- **pretty_dio_logger 1.3.1**: Beautiful API logging

### **UI & Design**
- **flutter_screenutil 5.9.0**: Responsive design utilities
- **flutter_animate 4.5.2**: Smooth animations
- **shimmer 3.0.0**: Loading state animations
- **flutter_svg 2.2.0**: Vector graphics support

### **Data & Storage**
- **shared_preferences 2.5.3**: Local data persistence
- **dartz 0.10.1**: Functional programming utilities

### **Authentication**
- **google_sign_in 6.2.2**: OAuth integration
- **permission_handler 12.0.1**: Device permissions

---

## 📁 Project Structure

```
lib/
├── core/                           # Core application layer
│   ├── di/                        # Dependency injection
│   ├── helpers/                   # Utility functions
│   ├── networking/                # API and HTTP layer
│   ├── routing/                   # Navigation management
│   ├── theming/                   # UI themes and styling
│   └── widgets/                   # Shared components
├── features/                      # Feature modules
│   ├── authentication/            # Login/signup flows
│   ├── home/                     # Main dashboard
│   ├── hadith_daily/             # Daily hadith feature
│   ├── hadith_details/           # Hadith detail views
│   ├── library/                  # Book library management
│   ├── bookmark/                 # Bookmarking system
│   ├── search/                   # Search functionality
│   ├── profile/                  # User profile management
│   ├── chapters/                 # Chapter navigation
│   ├── ahadith/                  # Hadith content
│   ├── book_data/                # Book information
│   ├── navigation/               # Navigation logic
│   ├── notification/             # Push notifications
│   ├── main_navigation/          # Bottom navigation
│   ├── onboarding/               # User onboarding
│   └── splash/                   # App splash screen
├── main_development.dart          # Development entry point
├── main_production.dart           # Production entry point
└── mishkat_almasabih.dart        # Main app configuration
```

### **Feature Module Structure**

Each feature follows a consistent structure:

```
feature_name/
├── data/                          # Data layer
│   ├── models/                    # Data models
│   ├── repos/                     # Repository implementations
│   └── datasources/               # API and local data sources
├── logic/                         # Business logic layer
│   └── cubit/                     # BLoC cubits
└── ui/                            # Presentation layer
    ├── screens/                   # Main screens
    └── widgets/                   # Feature-specific widgets
```

---

## 🚀 Getting Started

### **Prerequisites**

- Flutter SDK 3.7.0 or higher
- Dart SDK 3.7.0 or higher
- Android Studio / VS Code
- Git

### **Installation**

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/mishkat_almasabih.git
   cd mishkat_almasabih
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### **Environment Setup**

The app supports multiple environments:

- **Development**: `flutter run --flavor development`
- **Production**: `flutter run --flavor production`

### **Build Commands**

```bash
# Android APK
flutter build apk --flavor production

# iOS
flutter build ios --flavor production

# Web
flutter build web
```

---

## 🧪 Testing

### **Test Structure**

- **Unit Tests**: Business logic and utility functions
- **Widget Tests**: UI component testing
- **Integration Tests**: Feature workflow testing
- **Mock Services**: Isolated testing environment

### **Running Tests**

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/feature_name_test.dart

# Run with coverage
flutter test --coverage
```

### **Test Coverage Goals**

- **Business Logic**: >90%
- **UI Components**: >70%
- **Integration**: >50%
- **Critical Paths**: 100%

---

## 📚 Documentation

### **Architecture Documentation**
- [🏗️ Architecture Overview](ARCHITECTURE_OVERVIEW.md)
- [🔧 Code Refactoring Guide](CODE_REFACTORING_GUIDE.md)
- [🎨 Islamic Design Enhancements](ISLAMIC_DESIGN_ENHANCEMENTS.md)

### **Development Guides**
- [📱 Home Screen Design](ISLAMIC_HOME_SCREEN_DESIGN.md)
- [📚 Library Structure](17_BOOKS_STRUCTURE.md)
- [🚀 Development Tasks](DEVELOPMENT_TASKS.md)
- [👋 Onboarding Screens](ONBOARDING_SCREENS_DESIGN.md)

### **API Documentation**
- [🔗 Library Endpoints](ISLAMIC_LIBRARY_17_BOOKS_ENDPOINTS.md)

---

## 🤝 Contributing

We welcome contributions from the community! Please read our contributing guidelines:

### **Development Workflow**

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make your changes**
4. **Add tests** for new functionality
5. **Commit your changes**
   ```bash
   git commit -m 'Add amazing feature'
   ```
6. **Push to the branch**
   ```bash
   git push origin feature/amazing-feature
   ```
7. **Open a Pull Request**

### **Code Standards**

- Follow **Flutter best practices**
- Use **Clean Architecture** principles
- Maintain **consistent naming conventions**
- Write **comprehensive documentation**
- Ensure **adequate test coverage**

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **Islamic Scholars**: For authentic hadith content
- **Flutter Community**: For excellent development tools
- **Design Inspiration**: Traditional Islamic art and architecture
- **Contributors**: All developers who contributed to this project

---

## 📞 Contact

- **Project Link**: [https://github.com/yourusername/mishkat_almasabih](https://github.com/yourusername/mishkat_almasabih)
- **Issues**: [GitHub Issues](https://github.com/yourusername/mishkat_almasabih/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/mishkat_almasabih/discussions)

---

<div align="center">

**Made with ❤️ for the Islamic community**

*"Seeking knowledge is obligatory upon every Muslim" - Prophet Muhammad ﷺ*

</div>
