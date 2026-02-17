import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/auth_service.dart';

class PinLoginPage extends StatefulWidget {
  const PinLoginPage({super.key});

  @override
  State<PinLoginPage> createState() => _PinLoginPageState();
}

class _PinLoginPageState extends State<PinLoginPage> {
  String _pin = '';
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _canUseBiometric = false;

  @override
  void initState() {
    super.initState();
    _checkBiometric();
  }

  Future<void> _checkBiometric() async {
    final canCheck = await _localAuth.canCheckBiometrics;
    final isEnabled = await AuthService.isBiometricEnabled();
    setState(() => _canUseBiometric = canCheck && isEnabled);
    if (_canUseBiometric) _authenticateWithBiometric();
  }

  Future<void> _authenticateWithBiometric() async {
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access your financial data',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (authenticated && mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      // Biometric failed, continue with PIN
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FutureBuilder<bool>(
          future: AuthService.isLocked(),
          builder: (context, snapshot) {
            if (snapshot.data == true) {
              return _buildLockedScreen();
            }
            return _buildPinScreen();
          },
        ),
      ),
    );
  }

  Widget _buildPinScreen() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, size: 80, color: AppColors.primary),
          const SizedBox(height: 24),
          const Text(
            'Enter PIN',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          FutureBuilder<int>(
            future: AuthService.getRemainingAttempts(),
            builder: (context, snapshot) {
              final remaining = snapshot.data ?? 5;
              return Text(
                '$remaining attempts remaining',
                style: TextStyle(
                  color: remaining <= 2
                      ? AppColors.error
                      : AppColors.textSecondary,
                  fontSize: 14,
                ),
              );
            },
          ),
          const SizedBox(height: 48),
          _buildPinDots(_pin),
          const SizedBox(height: 48),
          _buildNumPad(),
          if (_canUseBiometric) ...[
            const SizedBox(height: 24),
            IconButton(
              icon: const Icon(
                Icons.fingerprint,
                size: 48,
                color: AppColors.primary,
              ),
              onPressed: _authenticateWithBiometric,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLockedScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 80, color: AppColors.error),
            const SizedBox(height: 24),
            const Text(
              'Account Locked',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Too many failed attempts. To regain access, you must delete all app data.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _deleteAllData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text('Delete All Data'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPinDots(String pin) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < pin.length
                ? AppColors.primary
                : AppColors.surfaceLight,
          ),
        );
      }),
    );
  }

  Widget _buildNumPad() {
    return Column(
      children: [
        _buildNumRow(['1', '2', '3']),
        const SizedBox(height: 16),
        _buildNumRow(['4', '5', '6']),
        const SizedBox(height: 16),
        _buildNumRow(['7', '8', '9']),
        const SizedBox(height: 16),
        _buildNumRow(['', '0', 'del']),
      ],
    );
  }

  Widget _buildNumRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((number) {
        if (number.isEmpty) return const SizedBox(width: 80);
        return _buildNumButton(number);
      }).toList(),
    );
  }

  Widget _buildNumButton(String number) {
    return GestureDetector(
      onTap: () => _onNumTap(number),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: number == 'del'
              ? const Icon(
                  Icons.backspace_outlined,
                  color: AppColors.textPrimary,
                )
              : Text(
                  number,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }

  void _onNumTap(String num) {
    setState(() {
      if (num == 'del') {
        if (_pin.isNotEmpty) _pin = _pin.substring(0, _pin.length - 1);
      } else {
        if (_pin.length < 4) {
          _pin += num;
          if (_pin.length == 4) _verifyPin();
        }
      }
    });
  }

  void _verifyPin() async {
    final isValid = await AuthService.verifyPin(_pin);
    if (isValid && mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      final remaining = await AuthService.getRemainingAttempts();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              remaining > 0
                  ? 'Incorrect PIN. $remaining attempts remaining.'
                  : 'Account locked. Delete all data to regain access.',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
      setState(() => _pin = '');
      if (remaining == 0) setState(() {});
    }
  }

  void _deleteAllData() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Delete All Data?',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'This will permanently delete all your financial data. This action cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AuthService.deleteAllData();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/setup');
      }
    }
  }
}
