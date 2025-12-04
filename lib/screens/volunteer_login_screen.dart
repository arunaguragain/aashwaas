import 'package:aashwaas/screens/donor_login_screen.dart';
import 'package:aashwaas/widgets/my_button.dart';
import 'package:aashwaas/widgets/my_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VolunteerLoginScreen extends StatefulWidget {
  const VolunteerLoginScreen({super.key});

  @override
  State<VolunteerLoginScreen> createState() => _VolunteerLoginScreenState();
}

class _VolunteerLoginScreenState extends State<VolunteerLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _gap = SizedBox(height: 15);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 211, 227, 255),
      appBar: AppBar(backgroundColor: const Color.fromARGB(255, 211, 227, 255)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  child: Image.asset("assets/images/logo.png"),
                ),

                
                Text(
                  " Login as Volunteer",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),

                _gap,
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                  text: "Login",
                  color: Colors.blueAccent,
                ),

                SizedBox(height: 7),

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

                SizedBox(height: 7),

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
                    TextButton(onPressed: () {}, child: Text("Sign Up")),
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
