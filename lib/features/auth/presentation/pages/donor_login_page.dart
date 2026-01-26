import 'package:aashwaas/core/utils/my_snackbar.dart';
import 'package:aashwaas/features/auth/presentation/pages/donor_register_page.dart';
import 'package:aashwaas/features/auth/presentation/state/donor_auth_state.dart';
import 'package:aashwaas/features/auth/presentation/view_model/donor_auth_viewmodel.dart';
import 'package:aashwaas/features/dashboard/presentation/pages/donor_home_page.dart';
import 'package:aashwaas/features/auth/presentation/pages/volunteer_login_page.dart';
import 'package:aashwaas/core/widgets/my_button.dart';
import 'package:aashwaas/core/widgets/my_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DonorLoginScreen extends ConsumerStatefulWidget {
  const DonorLoginScreen({super.key});

  @override
  ConsumerState<DonorLoginScreen> createState() => _DonorLoginScreenState();
}

class _DonorLoginScreenState extends ConsumerState<DonorLoginScreen> {
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
          .read(authDonorViewmodelProvider.notifier)
          .login(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _gap = SizedBox(height: 15);

    final donorAuthState = ref.watch(authDonorViewmodelProvider);
    ref.listen<DonorAuthState>(authDonorViewmodelProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => const DonorHomeScreen(),
          ),
        );
      } else if (next.status == AuthStatus.error && next.errorMessage != null) {
        showMySnackBar(context: context, message: next.errorMessage!);
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
                  " Login as Donor",
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
                  obscureText: _obscurePassword,
                  labelText: "Password",
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
                  // onPressed: () {
                  //   if (_formKey.currentState!.validate()) {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute<void>(
                  //         builder: (context) => const DonorHomeScreen(),
                  //       ),
                  //     );

                  //     showMySnackBar(
                  //       context: context,
                  //       message: "Logged in as Donor",
                  //     );
                  //   }
                  // },
                  onPressed:  _handleLogin,
                  isLoading: donorAuthState.status == AuthStatus.loading,
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
                            builder: (context) => const DonorRegisterScreen(),
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
                            builder: (context) => const VolunteerLoginScreen(),
                          ),
                        );
                      },
                      child: Text("Login as Volunteer"),
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
