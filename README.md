# EnakEco SO - Stock Opname Application

A Flutter application for digitalizing stock opname (SO) processes in warehouses and retail stores. Built with Clean Architecture and following Domain-Driven Design principles.

## 🏗️ Architecture

This project follows **Clean Architecture** with **Feature-based** organization, inspired by the PMP project pattern:

```
lib/
├── core/                    # Shared utilities and configurations
│   ├── constants/          # App constants and configurations
│   ├── di/                 # Dependency injection setup
│   ├── network/            # Network layer and base responses
│   ├── services/           # Shared services
│   ├── styles/             # App-wide styles and themes
│   ├── themes/             # App theme configuration
│   ├── utils/              # Utility functions
│   └── widgets/            # Shared widgets
├── features/               # Feature-based modules
│   ├── auth/               # Authentication feature
│   │   ├── data/           # Data layer (models, datasources, repositories)
│   │   ├── domain/         # Domain layer (entities, repositories, usecases)
│   │   └── presentation/   # Presentation layer (pages, widgets, providers)
│   ├── splash/             # Splash screen feature
│   ├── main_menu/          # Main menu and dashboard feature
│   └── stock_opname/       # Stock opname management feature
└── main.dart               # App entry point
```

## 🚀 Features

### Current Features
- **Splash Screen** - App introduction with loading animation
- **Authentication** - Login system with form validation
- **Dashboard** - Main menu with statistics and quick access
- **Stock Opname Management** - CRUD operations for stock opname
- **Modern UI** - Clean, responsive design with red accent color

### Planned Features
- **RTL (Toko)** - Retail store management
- **GRS** - Goods receipt system
- **RSK** - Return stock management
- **Settings** - Account and app configuration
- **Barcode Scanning** - Item scanning functionality
- **Offline Support** - Local data storage
- **Real-time Sync** - API integration

## 🛠️ Tech Stack

- **Framework**: Flutter 3.5.2+
- **State Management**: Provider (ChangeNotifier)
- **Routing**: GoRouter
- **Dependency Injection**: GetIt
- **Network**: Dio + HTTP
- **Architecture**: Clean Architecture + DDD
- **Error Handling**: Dartz (Either)
- **Storage**: SharedPreferences + Flutter Secure Storage

## 📱 UI/UX Design

- **Color Scheme**: White background with red accent (#E53E3E)
- **Typography**: Inter font family
- **Design System**: Material Design 3
- **Responsive**: Mobile and tablet support
- **Accessibility**: WCAG compliant

## 🏃‍♂️ Getting Started

### Prerequisites
- Flutter SDK 3.5.2 or higher
- Dart SDK 3.5.2 or higher
- Android Studio / VS Code
- Android SDK (API 21+) / Xcode (for iOS)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd enakeco_so
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

### Build Configuration

#### Android
- **minSdk**: 21
- **compileSdk**: 34
- **package**: com.enakeco.so
- **multiDex**: Enabled

#### iOS
- **iOS Deployment Target**: 12.0+
- **Swift Version**: 5.0

## 📁 Project Structure

### Core Layer
- **Constants**: App-wide constants and configurations
- **DI**: Dependency injection setup using GetIt
- **Network**: HTTP client configuration and base responses
- **Services**: Shared services (notification, storage, etc.)
- **Styles**: Reusable styles and design tokens
- **Themes**: App theme configuration
- **Utils**: Utility functions and helpers
- **Widgets**: Shared UI components

### Feature Layer
Each feature follows the same structure:

#### Data Layer
- **Models**: Data models extending domain entities
- **DataSources**: Remote and local data sources
- **Repositories**: Repository implementations

#### Domain Layer
- **Entities**: Business logic entities
- **Repositories**: Repository interfaces
- **UseCases**: Business logic use cases

#### Presentation Layer
- **Pages**: Screen widgets
- **Widgets**: Feature-specific UI components
- **Providers**: State management using Provider

## 🔧 Configuration

### Environment Setup
The app supports multiple environments:
- Development
- Staging
- Production

### API Configuration
Currently using dummy data. API integration can be added by:
1. Updating data sources with real API calls
2. Adding API base URLs to constants
3. Implementing proper error handling

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

### Integration Tests
```bash
flutter test integration_test/
```

## 📦 Dependencies

### Core Dependencies
- `provider`: State management
- `go_router`: Navigation and routing
- `dio`: HTTP client
- `get_it`: Dependency injection
- `dartz`: Functional programming and error handling
- `equatable`: Value equality
- `shared_preferences`: Local storage
- `flutter_secure_storage`: Secure storage

### Dev Dependencies
- `flutter_lints`: Code linting
- `build_runner`: Code generation
- `json_serializable`: JSON serialization
- `mockito`: Mocking for tests

## 🚀 Deployment

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support and questions:
- Email: support@enakeco.com
- Documentation: [Wiki](link-to-wiki)
- Issues: [GitHub Issues](link-to-issues)

## 🔄 Changelog

### Version 1.0.0
- Initial release
- Basic authentication
- Dashboard with statistics
- Stock opname management
- Modern UI design

---

**Built with ❤️ by Enakeco Team**
