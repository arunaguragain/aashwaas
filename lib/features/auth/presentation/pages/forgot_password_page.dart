import 'package:aashwaas/core/widgets/my_button.dart';
import 'package:aashwaas/core/widgets/my_textformfield.dart';
import 'package:aashwaas/core/utils/my_snackbar.dart';
import 'package:aashwaas/features/auth/data/repositories/donor_auth_repository.dart';
import 'package:aashwaas/features/auth/data/repositories/volunteer_auth_repository.dart';
import 'package:aashwaas/features/auth/presentation/pages/reset_password_otp_page.dart';
import 'package:flutter/material.dart';
import 'package:aashwaas/app/routes/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  final String role; // 'donor' or 'volunteer'
  const ForgotPasswordPage({super.key, required this.role});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _emailCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      return MySnackbar.showError(context, 'Email is required');
    }
    setState(() => _loading = true);
    try {
      // Use repository's OTP request so network logic and errors are centralized
      if (widget.role == 'donor') {
        final repo = ref.read(authDonorRepositoryProvider);
        final result = await repo.requestPasswordOtp(email);
        result.fold((f) => throw Exception(f.message), (_) {});
      } else {
        final repo = ref.read(authVolunteerRepositoryProvider);
        final result = await repo.requestPasswordOtp(email);
        result.fold((f) => throw Exception(f.message), (_) {});
      }

      // Show generic confirmation message regardless of whether email exists
      MySnackbar.showInfo(
        context,
        'If the email is registered, an OTP has been sent.',
      );

      // Navigate to reset screen where user can enter OTP + new password
      AppRoutes.push(
        context,
        ResetPasswordOtpPage(email: email, role: widget.role),
      );
    } catch (e) {
      MySnackbar.showError(context, e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            MyTextformfield(
              controller: _emailCtrl,
              labelText: 'Email',
              hintText: 'Enter your email',
              errorMessage: '',
            ),
            const SizedBox(height: 16),
            MyButton(
              text: _loading ? 'Sending...' : 'Send reset email',
              onPressed: _loading ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}
