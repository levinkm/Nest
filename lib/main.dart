import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:async';
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
import 'features/ledger/presentation/pages/ledger_page.dart';
import 'features/transactions/services/shared_file_handler.dart';
import 'core/services/auth_service.dart';
import 'core/services/remote_config_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await RemoteConfigService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _sharedFileHandler = SharedFileHandler();
  StreamSubscription? _intentDataStreamSubscription;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _initSharedFileListener();
  }

  void _initSharedFileListener() {
    // For files shared while app is running
    _intentDataStreamSubscription = ReceiveSharingIntent.instance
        .getMediaStream()
        .listen((files) {
          if (files.isNotEmpty) {
            _handleSharedFiles(files);
          }
        });

    // For files shared while app was closed
    ReceiveSharingIntent.instance.getInitialMedia().then((files) {
      if (files.isNotEmpty) {
        _handleSharedFiles(files);
      }
    });
  }

  Future<void> _handleSharedFiles(List<SharedMediaFile> files) async {
    for (final file in files) {
      final result = await _sharedFileHandler.handleSharedFile(file);

      if (result.requiresPassword) {
        _showPasswordDialog(result.filePath!);
      } else if (result.success) {
        _showImportResult(result);
      } else if (result.error != null) {
        _showError(result.error!);
      }
    }
  }

  void _showPasswordDialog(String filePath) {
    final context = _navigatorKey.currentContext;
    if (context == null) return;

    final passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        title: const Text(
          'PDF Password',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter PDF password',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final result = await _sharedFileHandler.handlePdfWithPassword(
                filePath,
                passwordController.text,
              );
              if (result.success) {
                _showImportResult(result);
              } else {
                _showError(result.error ?? 'Import failed');
              }
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }

  void _showImportResult(SharedFileResult result) {
    final context = _navigatorKey.currentContext;
    if (context == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Imported ${result.imported} transactions. Skipped ${result.duplicates} duplicates.',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showError(String error) {
    final context = _navigatorKey.currentContext;
    if (context == null) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(error), backgroundColor: Colors.red));
  }

  @override
  void dispose() {
    _intentDataStreamSubscription?.cancel();
    super.dispose();
  }

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
        navigatorKey: _navigatorKey,
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        initialRoute: '/auth',
        routes: {
          '/auth': (context) => const AuthWrapper(),
          '/home': (context) => const MainNavigationPage(),
          '/setup': (context) => const PinSetupPage(),
          '/login': (context) => const PinLoginPage(),
          '/ledger': (context) => const LedgerPage(),
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
