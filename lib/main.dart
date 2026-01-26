import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/main_navigation_page.dart';
import 'features/budget/screens/analytics_screen.dart';
import 'features/budget/screens/budget_details_screen.dart';
import 'features/budget/data/models/budget_model.dart';
import 'features/transactions/presentation/bloc/transaction_bloc.dart';
import 'features/transactions/data/repositories/transaction_repository_impl.dart';
import 'features/transactions/data/datasources/local_database.dart';
import 'features/sms_parser/presentation/bloc/sms_sync_bloc.dart';
import 'features/sms_parser/domain/usecases/sync_sms_transactions.dart';
import 'features/sms_parser/data/datasources/sms_parser_datasource.dart';
import 'features/settings/presentation/pages/pin_setup_page.dart';
import 'features/settings/presentation/pages/pin_login_page.dart';
import 'core/services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localDatabase = LocalDatabase();
    final transactionRepository = TransactionRepositoryImpl(localDatabase);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              TransactionBloc(transactionRepository)
                ..add(const TransactionEvent.loadTransactions()),
        ),
        BlocProvider(
          create: (context) => SmsSyncBloc(
            SyncSmsTransactionsUseCase(
              SmsParserDataSource(),
              transactionRepository,
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Nest - Budget Tracker',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        initialRoute: '/auth',
        routes: {
          '/auth': (context) => const AuthWrapper(),
          '/home': (context) => const MainNavigationPage(),
          '/setup': (context) => const PinSetupPage(),
          '/login': (context) => const PinLoginPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/budget/analytics') {
            final budget = settings.arguments as Budget;
            return MaterialPageRoute(
              builder: (_) => AnalyticsScreen(budget: budget),
            );
          }
          if (settings.name == '/budget/details') {
            final budget = settings.arguments as Budget;
            return MaterialPageRoute(
              builder: (_) => BudgetDetailsScreen(budget: budget),
            );
          }
          return null;
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.isPinSet(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.data == true) {
          return const PinLoginPage();
        }
        return const PinSetupPage();
      },
    );
  }
}
