import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../utils/constants.dart';
import '../home_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;

  const VerifyEmailScreen({super.key, required this.email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;
  bool _isResending = false;
  String? _message;

  Future<void> _handleVerify() async {
    if (_codeController.text.trim().length != 6) {
      setState(() {
        _message = 'Enter the 6-digit code from your email';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    final error = await AuthService.verifyEmail(
      email: widget.email,
      code: _codeController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (error == null && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } else {
      setState(() {
        _message = error;
      });
    }
  }

  Future<void> _handleResend() async {
    setState(() {
      _isResending = true;
      _message = null;
    });

    final error = await AuthService.resendVerification(widget.email);

    setState(() {
      _isResending = false;
      _message = error ?? 'A new code has been sent.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.ghanaGold
        : AppColors.navy;

    return Scaffold(
      appBar: AppBar(title: const Text('Verify Your Email')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text(
                'Check your email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We sent a 6-digit verification code to ${widget.email}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 28),
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, letterSpacing: 8),
                decoration: const InputDecoration(
                  labelText: '6-digit code',
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
              ),
              const SizedBox(height: 8),
              if (_message != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    _message!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.danger),
                  ),
                ),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleVerify,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Verify'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _isResending ? null : _handleResend,
                child: _isResending
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        "Didn't get a code? Resend",
                        style: TextStyle(color: accentColor),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}