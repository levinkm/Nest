import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/auth_service.dart';

class PinSetupPage extends StatefulWidget {
  const PinSetupPage({super.key});

  @override
  State<PinSetupPage> createState() => _PinSetupPageState();
}

class _PinSetupPageState extends State<PinSetupPage> {
  String _pin = '';
  String _confirmPin = '';
  bool _isConfirming = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 80, color: AppColors.primary),
              const SizedBox(height: 24),
              Text(
                _isConfirming ? 'Confirm PIN' : 'Set up PIN',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isConfirming ? 'Re-enter your 4-digit PIN' : 'Create a 4-digit PIN to secure your app',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              _buildPinDots(_isConfirming ? _confirmPin : _pin),
              const SizedBox(height: 48),
              _buildNumPad(),
            ],
          ),
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
            color: index < pin.length ? AppColors.primary : AppColors.surfaceLight,
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
      children: numbers.map((num) {
        if (num.isEmpty) return const SizedBox(width: 80);
        return _buildNumButton(num);
      }).toList(),
    );
  }

  Widget _buildNumButton(String num) {
    return GestureDetector(
      onTap: () => _onNumTap(num),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: num == 'del'
              ? const Icon(Icons.backspace_outlined, color: AppColors.textPrimary)
              : Text(
                  num,
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
        if (_isConfirming) {
          if (_confirmPin.isNotEmpty) _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        } else {
          if (_pin.isNotEmpty) _pin = _pin.substring(0, _pin.length - 1);
        }
      } else {
        if (_isConfirming) {
          if (_confirmPin.length < 4) {
            _confirmPin += num;
            if (_confirmPin.length == 4) _verifyPins();
          }
        } else {
          if (_pin.length < 4) {
            _pin += num;
            if (_pin.length == 4) {
              _isConfirming = true;
            }
          }
        }
      }
    });
  }

  void _verifyPins() async {
    if (_pin == _confirmPin) {
      await AuthService.setPin(_pin);
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PINs do not match. Try again.')),
      );
      setState(() {
        _pin = '';
        _confirmPin = '';
        _isConfirming = false;
      });
    }
  }
}
