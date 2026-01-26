# Nest - Personal Finance Manager

<p align="center">
  <img src="assets/logo.png" alt="Nest Logo" width="200"/>
</p>

A comprehensive personal finance management app built with Flutter, featuring SMS-based transaction parsing, budget tracking, savings goals, debt management, and financial analytics.

##  Features

###  Core Features
- **SMS Transaction Parsing**: Automatically extracts and categorizes transactions from M-Pesa and bank SMS messages
- **Dashboard Analytics**: Real-time financial overview with spending trends and category breakdowns
- **Transaction Management**: View, edit, and categorize all your financial transactions
- **Budget Tracking**: Set and monitor spending limits by category
- **Multi-Currency Support**: KSh, USD, EUR, GBP, TZS, UGX

###  Financial Planning
- **Savings Goals**: Create and track multiple savings goals with progress monitoring
- **Emergency Fund**: Dedicated emergency fund tracking with target amounts
- **Expected Income**: Manage recurring income sources (salary, business, investments)
- **Automated Savings Rules**: Set up automatic savings based on income or transactions
- **Savings Analytics**: Comprehensive analytics including health score, savings rate, and projections

###  Debt Management
- **Debt Tracking**: Monitor multiple debts with interest calculations
- **Payment History**: Record and view all debt payments
- **Interest Tracking**: Support for monthly, yearly, and principal-based interest
- **Fuliza Debt Detection**: Automatic detection and tracking of M-Pesa Fuliza loans

###  Analytics & Insights
- **7-Day Spending Trends**: Visual charts showing daily spending patterns
- **Category Distribution**: Pie charts and breakdowns of expenses by category
- **Financial Health Score**: Overall assessment of your financial wellness
- **Smart Suggestions**: AI-powered recommendations for improving finances
- **Goal Progress Tracking**: Visual progress bars and projections for savings goals

###  Security
- **PIN Authentication**: 4-digit PIN protection with secure SHA-256 hashing
- **Biometric Authentication**: Fingerprint/Face ID support
- **Attempt Limits**: Account locks after 5 failed attempts
- **Secure Storage**: PIN stored using flutter_secure_storage

###  User Experience
- **Dark Theme**: Modern Revolut-inspired dark UI
- **Smooth Animations**: Polished transitions and interactions
- **Responsive Design**: Optimized for various screen sizes
- **Offline Support**: Local SQLite database for offline functionality

##  Architecture

### Project Structure
```
lib/
├── core/
│   ├── constants/       # App-wide constants
│   ├── services/        # Core services (auth, backup)
│   ├── theme/          # App colors and themes
│   └── utils/          # Utility functions and helpers
├── features/
│   ├── budget/         # Budget management
│   ├── dashboard/      # Home dashboard
│   ├── debt_management/# Debt tracking
│   ├── financial_planning/  # Savings & goals
│   ├── settings/       # App settings & auth
│   ├── sms_parser/     # SMS parsing logic
│   └── transactions/   # Transaction management
└── presentation/       # Shared UI components
```

### Tech Stack
- **Framework**: Flutter 3.9+
- **State Management**: BLoC (flutter_bloc)
- **Local Database**: SQLite (sqflite)
- **Charts**: fl_chart, syncfusion_flutter_charts
- **Security**: flutter_secure_storage, crypto
- **Biometrics**: local_auth
- **Permissions**: permission_handler

##  Getting Started

### Prerequisites
- Flutter SDK 3.9.0 or higher
- Dart SDK 3.9.0 or higher
- Android Studio / Xcode for mobile development
- Android device/emulator (API 23+) or iOS device/simulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/nest.git
   cd nest
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Platform-Specific Setup

#### Android
- Minimum SDK: 23
- Target SDK: 34
- Permissions required: SMS, Biometric

#### iOS
- Minimum iOS: 12.0
- Add to `Info.plist`:
  ```xml
  <key>NSFaceIDUsageDescription</key>
  <string>Authenticate to access your financial data</string>
  ```

##  Usage

### First Launch
1. Set up a 4-digit PIN for security
2. Grant SMS permissions for automatic transaction parsing
3. Sync SMS messages to import transactions

### Managing Transactions
- **Auto-sync**: Transactions are automatically parsed from SMS
- **Manual entry**: Add transactions manually via the + button
- **Categorization**: Edit categories and add custom categories
- **Classification Rules**: Set up keywords for automatic categorization

### Setting Up Savings Goals
1. Navigate to Financial Planning
2. Tap "Savings Goals"
3. Create a new goal with target amount and deadline
4. Track progress and receive smart suggestions

### Budget Management
1. Go to Budget tab
2. Set spending limits for each category
3. Monitor spending vs budget in real-time
4. Receive alerts when approaching limits

### Debt Tracking
1. Navigate to More > Debt Manager
2. Add debts with principal, interest rate, and period
3. Record payments as you make them
4. View payment history and remaining balance

##  Configuration

### SMS Parsing
The app supports parsing from:
- M-Pesa (Safaricom)
- Kenyan banks (KCB, Equity, Co-op, etc.)
- Custom SMS formats via classification rules

### Customization
- **Currency**: Settings > Default Currency
- **SMS Days Back**: Settings > SMS Days Back (7-180 days)
- **Theme**: Settings > Theme Mode (Light/Dark/System)
- **Categories**: Settings > Manage Categories
- **Classification Rules**: Settings > Classification Rules

##  Security Features

### PIN Protection
- 4-digit PIN required on app launch
- SHA-256 hashing for secure storage
- 5 attempt limit before lockout
- Must delete all data to regain access after lockout

### Biometric Authentication
- Optional fingerprint/Face ID support
- Enable in Settings > Security > Biometric Lock
- Falls back to PIN if biometric fails

### Data Privacy
- All data stored locally on device
- No cloud sync (optional backup to file)
- SMS permissions only for transaction parsing
- No data collection or analytics

##  Analytics & Insights

### Savings Analytics
- **Health Score**: 0-100 score based on savings rate, goals, and debt
- **Savings Rate**: Percentage of income saved
- **Goal Progress**: Track progress toward each savings goal
- **Projections**: Estimated completion dates for goals
- **Smart Suggestions**: Personalized recommendations

### Spending Insights
- **7-Day Trends**: Daily spending visualization
- **Category Breakdown**: Top spending categories
- **Budget vs Actual**: Compare spending to budgets
- **Monthly Comparisons**: Track spending over time

##  Development

### Running Tests
```bash
flutter test
```

### Building for Release

**Android**
```bash
flutter build apk --release
flutter build appbundle --release
```

**iOS**
```bash
flutter build ios --release
```

### Code Generation
When modifying models with Freezed:
```bash
flutter pub run build_runner watch
```

##  Dependencies

### Core
- `flutter_bloc` - State management
- `sqflite` - Local database
- `shared_preferences` - Simple key-value storage
- `flutter_secure_storage` - Secure PIN storage

### UI
- `fl_chart` - Charts and graphs
- `syncfusion_flutter_charts` - Advanced charts
- `flutter_slidable` - Swipeable list items
- `shimmer` - Loading animations

### Utilities
- `permission_handler` - SMS permissions
- `local_auth` - Biometric authentication
- `crypto` - SHA-256 hashing
- `uuid` - Unique ID generation
- `intl` - Date formatting
- `file_picker` - File selection for backup
- `share_plus` - Share backup files

##  Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

##  License

This project is licensed under the MIT License - see the LICENSE file for details.

##  Acknowledgments

- Inspired by Revolut's clean UI design
- SMS parsing patterns from Kenyan mobile money services
- Flutter community for excellent packages and support

##  Contact

For questions or support, please open an issue on GitHub.

---

