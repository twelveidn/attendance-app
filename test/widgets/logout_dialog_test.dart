import 'package:attendance_app/screens/home/home_screen.dart';
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('dialog keluar tampil dan tombol Batal menutupnya', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showLogoutDialog(context),
              child: const Text('Tampilkan dialog'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Tampilkan dialog'));
    await tester.pumpAndSettle();

    expect(find.text('Keluar dari akun?'), findsOneWidget);
    expect(find.text('Batal'), findsOneWidget);
    expect(find.text('Keluar'), findsOneWidget);

    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();

    expect(find.text('Keluar dari akun?'), findsNothing);
  });
}
