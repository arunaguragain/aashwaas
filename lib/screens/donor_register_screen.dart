import 'package:aashwaas/common/my_snackbar.dart';
import 'package:aashwaas/screens/donor_login_screen.dart';
import 'package:aashwaas/screens/volunteer_register_screen.dart';
import 'package:aashwaas/widgets/my_button.dart';
import 'package:aashwaas/widgets/my_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DonorRegisterScreen extends StatefulWidget {
  const DonorRegisterScreen({super.key});

  @override
  State<DonorRegisterScreen> createState() => _DonorRegisterScreenState();
}

class _DonorRegisterScreenState extends State<DonorRegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                  hintText: "Enter Username",
                  controller: _usernameController,
                  labelText: "Username",
                  errorMessage: "Username is required",
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
                ),

                _gap,

                MyTextformfield(
                  hintText: "Re-enter your password",
                  controller: _repasswordController,
                  labelText: "Confirm Password",
                  errorMessage: "Password is required",
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => const DonorLoginScreen(),
                          ),
                      );

                     showMySnackBar(
                          context: context,
                          message: "Registered as Donor",
                     );
                    }
                  },
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
                    TextButton(onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => const DonorLoginScreen(),
                          ),
                        );
                    }, child: Text("Log in")),
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
                            builder: (context) => const VolunteerRegisterScreen(),
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
