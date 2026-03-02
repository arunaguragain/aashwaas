import 'dart:async';

import 'package:aashwaas/core/widgets/my_button.dart';
import 'package:aashwaas/core/widgets/my_textformfield.dart';
import 'package:aashwaas/core/utils/my_snackbar.dart';
import 'package:aashwaas/features/auth/data/repositories/donor_auth_repository.dart';
import 'package:aashwaas/features/auth/data/repositories/volunteer_auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:aashwaas/app/routes/app_routes.dart';
import 'package:aashwaas/features/auth/presentation/pages/donor_login_page.dart';
import 'package:aashwaas/features/auth/presentation/pages/volunteer_login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetPasswordOtpPage extends ConsumerStatefulWidget {
  final String email;
  final String role; // 'donor' or 'volunteer'
  const ResetPasswordOtpPage({
    super.key,
    required this.email,
    required this.role,
  });

  @override
  ConsumerState<ResetPasswordOtpPage> createState() =>
      _ResetPasswordOtpPageState();
}

class _ResetPasswordOtpPageState extends ConsumerState<ResetPasswordOtpPage> {
  final _otpCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Timer? _countdownTimer;
  Duration _remaining = const Duration(minutes: 10);
  bool _loading = false;
  bool _resendCooldown = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _otpCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    setState(() => _remaining = const Duration(minutes: 10));
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remaining.inSeconds <= 1) {
        t.cancel();
        setState(() {});
        return;
      }
      setState(() => _remaining = Duration(seconds: _remaining.inSeconds - 1));
    });
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _resend() async {
    setState(() => _resendCooldown = true);
    Timer(
      const Duration(seconds: 30),
      () => setState(() => _resendCooldown = false),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final otp = _otpCtrl.text.trim();
    final pw = _passwordCtrl.text;
    final confirm = _confirmCtrl.text;
    if (pw != confirm)
      return MySnackbar.showError(context, 'Passwords do not match');
    if (otp.length != 6)
      return MySnackbar.showError(context, 'OTP must be 6 digits');
    setState(() => _loading = true);
    try {
      if (widget.role == 'donor') {
        final repo = ref.read(authDonorRepositoryProvider);
        final result = await repo.resetPasswordWithOtp(widget.email, otp, pw);
        result.fold((f) => throw Exception(f.message), (_) {});
      } else {
        final repo = ref.read(authVolunteerRepositoryProvider);
        final result = await repo.resetPasswordWithOtp(widget.email, otp, pw);
        result.fold((f) => throw Exception(f.message), (_) {});
      }

      MySnackbar.showSuccess(context, 'Password has been reset successfully.');
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      if (widget.role == 'donor') {
        AppRoutes.pushReplacement(context, const DonorLoginScreen());
      } else {
        AppRoutes.pushReplacement(context, const VolunteerLoginScreen());
      }
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 400) {
        MySnackbar.showError(
          context,
          'Invalid or expired OTP. Please request a new OTP.',
        );
      } else if (status == 404) {
        MySnackbar.showError(context, 'User not found.');
      } else {
        MySnackbar.showError(context, e.message ?? 'Failed to reset password');
      }
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      if (widget.role == 'donor') {
        AppRoutes.pushReplacement(context, const DonorLoginScreen());
      } else {
        AppRoutes.pushReplacement(context, const VolunteerLoginScreen());
      }
    } catch (e) {
      MySnackbar.showError(context, e.toString());
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      if (widget.role == 'donor') {
        AppRoutes.pushReplacement(context, const DonorLoginScreen());
      } else {
        AppRoutes.pushReplacement(context, const VolunteerLoginScreen());
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text('Enter the 6-digit OTP sent to ${widget.email}'),
              const SizedBox(height: 12),
              MyTextformfield(
                controller: _otpCtrl,
                labelText: 'OTP',
                hintText: '123456',
                errorMessage: 'OTP is required',
              ),
              const SizedBox(height: 12),
              MyTextformfield(
                controller: _passwordCtrl,
                labelText: 'New Password',
                hintText: 'Enter new password',
                errorMessage: 'Password is required',
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              const SizedBox(height: 12),
              MyTextformfield(
                controller: _confirmCtrl,
                labelText: 'Confirm Password',
                hintText: 'Confirm new password',
                errorMessage: 'Confirm password',
                obscureText: _obscureConfirm,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Expires in: ${_formatDuration(_remaining)}'),
                  TextButton(
                    onPressed: _resendCooldown ? null : _resend,
                    child: Text(
                      _resendCooldown ? 'Resend (wait)' : 'Resend OTP',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              MyButton(
                text: 'Reset Password',
                isLoading: _loading,
                onPressed: _loading ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
