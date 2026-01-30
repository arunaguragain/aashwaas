import 'package:aashwaas/core/utils/my_snackbar.dart';
import 'package:aashwaas/features/auth/presentation/pages/donor_login_page.dart';
import 'package:aashwaas/features/auth/presentation/state/volunteer_auth_state.dart';
import 'package:aashwaas/features/auth/presentation/view_model/volunteer_auth_viewmodel.dart';
import 'package:aashwaas/features/dashboard/presentation/pages/volunteer_home_page.dart';
import 'package:aashwaas/features/auth/presentation/pages/volunteer_register_page.dart';
import 'package:aashwaas/core/widgets/my_button.dart';
import 'package:aashwaas/core/widgets/my_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VolunteerLoginScreen extends ConsumerStatefulWidget {
  const VolunteerLoginScreen({super.key});

  @override
  ConsumerState<VolunteerLoginScreen> createState() =>
      _VolunteerLoginScreenState();
}

class _VolunteerLoginScreenState extends ConsumerState<VolunteerLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authVolunteerViewmodelProvider.notifier)
          .login(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _gap = SizedBox(height: 15);

    final volunteerAuthState = ref.watch(authVolunteerViewmodelProvider);
    ref.listen<VolunteerAuthState>(authVolunteerViewmodelProvider, (
      previous,
      next,
    ) {
      if (next.status == AuthStatus.authenticated) {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => const VolunteerHomeScreen(),
          ),
        );
      } else if (next.status == AuthStatus.error && next.errorMessage != null) {
        MySnackbar.showError(context, next.errorMessage!);
      }
    });

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  child: Image.asset("assets/images/logo.png"),
                ),

                _gap,

                Text(
                  " Login as Volunteer",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),

                _gap,

                MyTextformfield(
                  hintText: "Enter your email",
                  controller: _emailController,
                  labelText: "Your email",
                  errorMessage: "Email is required",
                ),

                _gap,

                MyTextformfield(
                  hintText: "Enter your password",
                  controller: _passwordController,
                  labelText: "Password",
                  obscureText: _obscurePassword,
                  errorMessage: "Password is required",
                ),

                _gap,

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text("Forget Password?"),
                    ),
                  ],
                ),

                _gap,

                MyButton(
                  onPressed: _handleLogin,
                  isLoading: volunteerAuthState.status == AuthStatus.loading,
                  text: "Login",
                  color: Colors.blueAccent,
                ),

                Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Or"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),

                MyButton(
                  onPressed: () {},
                  text: "Login with Google",
                  color: Colors.white,
                  textColor: Colors.black,
                  icon: Icon(FontAwesomeIcons.google),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) =>
                                const VolunteerRegisterScreen(),
                          ),
                        );
                      },
                      child: Text("Sign Up"),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => const DonorLoginScreen(),
                          ),
                        );
                      },
                      child: Text("Login as Donor"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
