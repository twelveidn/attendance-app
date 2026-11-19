import 'package:firebase_auth/firebase_auth.dart';
// ignore: deprecated_member_use
import 'package:flutter/material.dart';

import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../services/auth_services.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthServices().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Gagal memeriksa sesi akun: ${snapshot.error}'),
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        return user == null
            ? const LoginScreen()
            : HomeScreen(key: ValueKey(user.uid));
      },
    );
  }
}
