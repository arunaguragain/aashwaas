import 'package:flutter/material.dart';

class AddDonationScreen extends StatefulWidget {
  const AddDonationScreen({super.key});

  @override
  State<AddDonationScreen> createState() => _AddDonationScreenState();
}

class _AddDonationScreenState extends State<AddDonationScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Center(
        child: Text('Welcome to the Add Donation Screen'),
      ),
    );
  }
}