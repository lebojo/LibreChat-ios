# LibreChat-ios

<p align="center">
  <img src="https://img.shields.io/badge/platform-iOS-lightgrey" alt="Platform">
  <img src="https://img.shields.io/badge/Swift-5.0+-orange" alt="Swift">
  <img src="https://img.shields.io/badge/iOS-15.0+-blue" alt="iOS Version">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="License">
</p>

A lightweight, native iOS user interface for AI chat interactions. LibreChat-ios brings the power of AI conversations to your iOS device with a clean, intuitive interface.

## ✨ Features

- 🎨 Native iOS interface with SwiftUI
- 💬 Real-time chat conversations with AI models
- 🔐 Secure API key management
- 📱 Optimized for iPhone and iPad
- 🌓 Dark mode support
- 💾 Local conversation history
- ⚡️ Fast and lightweight
- 🔄 Support for multiple AI providers

## 📋 Requirements

- iOS 15.0 or later
- Xcode 14.0 or later
- Swift 5.0 or later
- An active API key from supported AI providers

## 🚀 Getting Started

### Installation

1. Clone the repository:
```bash
git clone https://github.com/lebojo/LibreChat-ios.git
cd LibreChat-ios
```

2. Open the project in Xcode:
```bash
open LibreChat-ios.xcodeproj
```
or
```bash
open LibreChat-ios.xcworkspace  # If using CocoaPods
```

3. Build and run the project on your device or simulator

### Configuration

1. Launch the app
2. Navigate to Settings
3. Add your API key(s) for the AI provider(s) you want to use
4. Start chatting!

## 🛠️ Development

### Planned Project Structure

The project will follow this structure:

```
LibreChat-ios/
├── App/                    # App entry point and configuration
├── Views/                  # SwiftUI views and UI components
├── ViewModels/            # View models and business logic
├── Models/                # Data models and entities
├── Services/              # API clients and service layers
├── Utilities/             # Helper functions and extensions
└── Resources/             # Assets, fonts, and other resources
```

*Note: This is an early-stage project. The structure above represents the intended architecture.*

### Building

To build the project:

```bash
xcodebuild -scheme LibreChat-ios -configuration Debug
```

### Testing

Run tests using:

```bash
xcodebuild test -scheme LibreChat-ios -destination 'platform=iOS Simulator,OS=latest,name=iPhone 15 Pro'
```

Or use any available simulator:
```bash
xcodebuild test -scheme LibreChat-ios -destination 'platform=iOS Simulator'
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by [LibreChat](https://github.com/danny-avila/LibreChat)
- Built with SwiftUI
- Thanks to all contributors and supporters

## 📧 Contact

For questions, suggestions, or issues, please open an issue on GitHub.

---

Made with ❤️ for the iOS community
