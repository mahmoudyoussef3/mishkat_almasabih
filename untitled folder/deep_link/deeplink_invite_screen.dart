import 'package:flutter/material.dart';

class DeeplinkInviteScreen extends StatelessWidget {
  const DeeplinkInviteScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite Screen'),
      ),
      body: const Center(
        child: Text('Welcome to the Invite Screen!'),
      ),
    );
  }
}