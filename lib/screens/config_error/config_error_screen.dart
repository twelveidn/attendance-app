// ignore: deprecated_member_use
import 'package:flutter/material.dart';

class ConfigErrorScreen extends StatelessWidget {
  const ConfigErrorScreen({super.key, required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase belum dikonfigurasi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF176B5B)),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Presensi Digital')),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.cloud_off_outlined, size: 52),
                    const SizedBox(height: 16),
                    Text(
                      'Firebase belum dikonfigurasi',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Ikuti langkah berikut untuk menyiapkan aplikasi:',
                    ),
                    const SizedBox(height: 12),
                    const Text('1. Pasang Firebase CLI.'),
                    const Text('2. Jalankan `firebase login`.'),
                    const Text(
                      '3. Jalankan `dart pub global activate flutterfire_cli`.',
                    ),
                    const Text(
                      '4. Jalankan `flutterfire configure --project=ID_PROJECT_ANDA`.',
                    ),
                    const Text('5. Jalankan ulang aplikasi.'),
                    const SizedBox(height: 20),
                    Text(
                      'Detail error: $error',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
