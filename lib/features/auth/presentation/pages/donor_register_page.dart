import 'package:aashwaas/core/utils/my_snackbar.dart';
import 'package:aashwaas/features/auth/presentation/pages/donor_login_page.dart';
import 'package:aashwaas/features/auth/presentation/pages/volunteer_register_page.dart';
import 'package:aashwaas/core/widgets/my_button.dart';
import 'package:aashwaas/core/widgets/my_textformfield.dart';
import 'package:aashwaas/features/auth/presentation/state/donor_auth_state.dart';
import 'package:aashwaas/features/auth/presentation/view_model/donor_auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DonorRegisterScreen extends ConsumerStatefulWidget {
  const DonorRegisterScreen({super.key});

  @override
  ConsumerState<DonorRegisterScreen> createState() =>
      _DonorRegisterScreenState();
}

class _DonorRegisterScreenState extends ConsumerState<DonorRegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();

  final bool _obscurePassword = true;
  final bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      // validate confirm password
      if (_passwordController.text != _repasswordController.text) {
        showMySnackBar(context: context, message: 'Passwords do not match');
        return;
      }

      ref
          .read(authDonorViewmodelProvider.notifier)
          .register(
            fullName: _fullNameController.text,
            email: _emailController.text,
            password: _passwordController.text,
          );
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final donorAuthState = ref.watch(authDonorViewmodelProvider);
    ref.listen<DonorAuthState>(authDonorViewmodelProvider, (previous, next) {
      if (next.status == AuthStatus.registered) {
        showMySnackBar(
          context: context,
          message: 'Registration successful! Please login',
        );
        Navigator.of(context).pop();
      } else if (next.status == AuthStatus.error) {
        showMySnackBar(
          context: context,
          message: 'Registration failed. Please try again',
        );
      }
    });
    final _gap = SizedBox(height: 15);

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
                  " Register as Donor",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),

                _gap,

                MyTextformfield(
                  hintText: "Enter Full Name",
                  controller: _fullNameController,
                  labelText: "Full Name",
                  errorMessage: "Full Name is required",
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
                  errorMessage: "Password is required",
                  obscureText: _obscurePassword,
                ),

                _gap,

                MyTextformfield(
                  hintText: "Re-enter your password",
                  controller: _repasswordController,
                  labelText: "Confirm Password",
                  errorMessage: "Password is required",
                  obscureText: _obscureConfirmPassword,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text("Forget Password?"),
                    ),
                  ],
                ),

                MyButton(
                  onPressed: _handleSignup,
                  // onPressed: () {
                  //   // if (_formKey.currentState!.validate()) {
                  //   //   Navigator.push(
                  //   //     context,
                  //   //     MaterialPageRoute<void>(
                  //   //       builder: (context) => const DonorLoginScreen(),
                  //   //     ),
                  //   //   );

                  //   //   showMySnackBar(
                  //   //     context: context,
                  //   //     message: "Registered as Donor",
                  //   //   );
                  //   // }
                  // },
                  isLoading: donorAuthState.status == AuthStatus.loading,
                  text: "Register",
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
                  text: "Continue with Google",
                  color: Colors.white,
                  textColor: Colors.black,
                  icon: Icon(FontAwesomeIcons.google),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => const DonorLoginScreen(),
                          ),
                        );
                      },
                      child: Text("Log in"),
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
                            builder: (context) =>
                                const VolunteerRegisterScreen(),
                          ),
                        );
                      },
                      child: Text("Register as Volunteer"),
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
