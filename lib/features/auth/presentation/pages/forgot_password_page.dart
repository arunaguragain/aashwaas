import 'package:aashwaas/core/widgets/my_button.dart';
import 'package:aashwaas/core/widgets/my_textformfield.dart';
import 'package:aashwaas/core/utils/my_snackbar.dart';
import 'package:aashwaas/features/auth/domain/usecases/donor_forgot_password_usecase.dart';
import 'package:aashwaas/features/auth/domain/usecases/volunteer_forgot_password_usecase.dart';
import 'package:flutter/material.dart';
import 'package:aashwaas/app/routes/app_routes.dart';
import 'package:aashwaas/features/auth/presentation/pages/donor_login_page.dart';
import 'package:aashwaas/features/auth/presentation/pages/volunteer_login_page.dart';
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
    if (email.isEmpty)
      return MySnackbar.showError(context, 'Email is required');
    setState(() => _loading = true);
    try {
      if (widget.role == 'donor') {
        final usecase = ref.read(donorForgotPasswordUsecaseProvider);
        final result = await usecase(email);
        result.fold((f) => throw Exception(f.message), (_) {});
      } else {
        final usecase = ref.read(volunteerForgotPasswordUsecaseProvider);
        final result = await usecase(email);
        result.fold((f) => throw Exception(f.message), (_) {});
      }

      MySnackbar.showSuccess(
        context,
        'Check your email for reset instructions',
      );
      if (widget.role == 'donor') {
        AppRoutes.pushReplacement(context, const DonorLoginScreen());
      } else {
        AppRoutes.pushReplacement(context, const VolunteerLoginScreen());
      }
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
