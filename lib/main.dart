import 'package:firebase_core/firebase_core.dart';
// Flutter 3.50 deprecates this import in favor of a non-approved dependency.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'firebase_options.dart';
import 'screens/config_error/config_error_screen.dart';
import 'wrapper/auth_wrapper.dart';

const Color kSeedColor = Color(0xFF176B5B);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const AttendanceApp());
  } catch (error) {
    runApp(ConfigErrorScreen(error: error));
  }
}

class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Presensi Digital',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kSeedColor),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}
