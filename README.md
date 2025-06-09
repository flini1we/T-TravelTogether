# TTravelTogether

<div align="center">
  <img src="[Your App Icon]" alt="TTravelTogether Logo" width="200"/>
  
  [Screenshots will be added here]
</div>

## Overview

TTravelTogether is an iOS application that extends the T-Bank's travel service by enabling users to organize group trips, manage shared expenses, and coordinate with travel companions. The app helps users plan trips, track expenses, and automatically calculate shared costs among participants.

## Features

### 🏷️ Trip Management
- Create and manage group trips with start and end dates
- Add participants via contacts or phone numbers
- Track trip status and participant confirmations
- View trip details and statistics

### 💰 Expense Management
- Set and track overall trip budget
- Categorize expenses (tickets, hotels, food, entertainment, insurance, etc.)
- Record individual and group expenses
- Automatic calculation of shared costs and debts
- View expense history and summaries

### 👥 User Management
- Secure user authentication
- Profile management
- Contact synchronization
- Push notifications for important updates
- Offline mode support

### 🔐 Security & Data Management
- Secure data storage using CoreData
- Encrypted data transmission
- Privacy-first approach
- Secure authentication system

## Technical Implementation

### Requirements
- Swift 5+
- Xcode 13+
- iOS 14+
- CocoaPods for dependency management
- SwiftLint for code style enforcement

### Architecture
- MVVM (Model-View-ViewModel) architecture
- Coordinator pattern for navigation
- Protocol-oriented programming
- Dependency injection

### Key Components
- **Views**: UIKit-based UI components with programmatic layout (SnapKit)
- **ViewModels**: Business logic and data management
- **Models**: CoreData entities and business objects
- **Services**: Network, storage, and utility services
- **Utils**: Helper functions and extensions

### Dependencies
- SnapKit for programmatic UI
- URLSession/Alamofire for networking
- CoreData for local storage
- SwiftLint for code style

### Testing
- Unit tests
- UI tests

## Project Structure

```
TTravelTogether/
├── App/
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── Modules/
│   ├── LoginScreen/
│   ├── RegistrationScreen/
│   ├── MyTripsScreen/
│   ├── CreateTrip/
│   ├── Transactions/
│   └── Profile/
├── Custom/
│   ├── Views/
│   ├── Extensions/
│   └── Utils/
├── Resources/
│   ├── Assets.xcassets
│   └── Localization/
├── Service/
│   ├── Network/
│   └── Storage/
├── Model/
├── Protocols/
├── Coordinator/
├── Factory/
├── Support/
└── Tests/
```

## Features Implementation

### Core Features
- ✅ Programmatic UI with UIKit and SnapKit
- ✅ Dark mode support
- ✅ Localization (Russian/English)
- ✅ Cahing
- ✅ Push notifications
- ✅ Contact synchronization
- ✅ CoreData/KeyChain integration
- ✅ Custom views and components

### Code Quality
- ✅ SwiftLint integration
- ✅ Unit tests
- ✅ Clean architecture
- ✅ Code reusability

## Getting Started

### Prerequisites
- Xcode 13.0 or later
- iOS 14.0 or later
- CocoaPods
- Swift 5.0 or later

### Installation
1. Clone the repository
```bash
git clone https://github.com/yourusername/TTravelTogether.git
```

2. Install dependencies
```bash
cd TTravelTogether
pod install
```

3. Open the workspace
```bash
open TTravelTogether.xcworkspace
```

4. Build and run the project

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Thanks to all contributors who have helped shape this project
- Special thanks to the iOS development community for their invaluable resources and support

## Contact

Your Name - [@yourtwitter](https://twitter.com/yourtwitter)
Project Link: [https://github.com/yourusername/TTravelTogether](https://github.com/yourusername/TTravelTogether)