# Mishkat Al-Masabih App - Architecture Overview

## 🏗️ Architecture Pattern
This app follows **Clean Architecture** principles with **Feature-First** organization, implementing **BLoC (Business Logic Component)** pattern for state management.

## 📁 Project Structure

```
lib/
├── core/                           # Core application layer
│   ├── di/                        # Dependency injection
│   ├── helpers/                   # Utility functions and extensions
│   ├── networking/                # API and network layer
│   ├── routing/                   # Navigation and routing
│   ├── theming/                   # UI themes and styling
│   └── widgets/                   # Shared/reusable widgets
├── features/                      # Feature modules
│   ├── authentication/            # Login/signup functionality
│   ├── home/                     # Home screen and dashboard
│   ├── hadith_daily/             # Daily hadith feature
│   ├── hadith_details/           # Hadith detail views
│   ├── library/                  # Library management
│   ├── bookmark/                 # Bookmarking system
│   ├── search/                   # Search functionality
│   ├── profile/                  # User profile management
│   └── ...                       # Other features
├── main_development.dart          # Development entry point
├── main_production.dart           # Production entry point
└── mishkat_almasabih.dart        # Main app configuration
```

## 🎯 Architecture Principles

### 1. **Separation of Concerns**
- **UI Layer**: Presentation and user interaction
- **Business Logic Layer**: Use cases and business rules
- **Data Layer**: Data sources and repositories

### 2. **Feature-First Organization**
- Each feature is self-contained with its own:
  - Data models
  - Business logic (BLoC)
  - UI components
  - Repository interfaces

### 3. **Dependency Injection**
- Centralized dependency management
- Loose coupling between components
- Easy testing and maintenance

### 4. **State Management**
- **BLoC Pattern**: Predictable state management
- **Repository Pattern**: Data abstraction layer
- **Service Layer**: Business logic encapsulation

## 🔧 Core Components

### **Core Layer**
- **DI**: Dependency injection container
- **Networking**: HTTP client, interceptors, error handling
- **Routing**: Navigation management
- **Theming**: Consistent UI styling
- **Helpers**: Utility functions and extensions

### **Feature Layer**
- **Data**: Models, repositories, data sources
- **Logic**: BLoC cubits, business logic
- **UI**: Screens, widgets, presentation logic

## 📱 State Management Flow

```
UI → BLoC → Repository → Data Source
 ↑                                    ↓
 ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ←
```

## 🎨 UI Architecture

### **Widget Hierarchy**
- **Screens**: Top-level UI containers
- **Widgets**: Reusable UI components
- **Layouts**: Responsive design containers

### **Theme System**
- **Color Scheme**: Islamic-themed color palette
- **Typography**: Consistent text styling
- **Components**: Unified component themes

## 🚀 Performance Considerations

- **Lazy Loading**: Features loaded on demand
- **Image Optimization**: Efficient image handling
- **State Optimization**: Minimal rebuilds
- **Memory Management**: Proper resource disposal

## 🧪 Testing Strategy

- **Unit Tests**: Business logic and utilities
- **Widget Tests**: UI component testing
- **Integration Tests**: Feature workflow testing
- **Mock Services**: Isolated testing environment

## 📋 Code Standards

- **Naming Conventions**: Clear, descriptive names
- **Documentation**: Comprehensive code comments
- **Error Handling**: Graceful error management
- **Logging**: Structured logging for debugging

## 🔄 Data Flow

1. **User Action**: User interacts with UI
2. **BLoC Event**: UI dispatches event to BLoC
3. **Business Logic**: BLoC processes business rules
4. **Repository Call**: Data layer is accessed
5. **State Update**: UI is updated with new state
6. **UI Refresh**: Screen reflects new data

## 🎯 Benefits of This Architecture

- **Maintainability**: Clear separation of concerns
- **Scalability**: Easy to add new features
- **Testability**: Isolated components for testing
- **Reusability**: Shared components and utilities
- **Performance**: Optimized state management
- **Team Collaboration**: Clear feature boundaries
