// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:attendance_app/screens/history/photo_viewer.dart';

void main() {
  testWidgets('foto yang tidak tersedia menampilkan placeholder', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: PhotoViewer(photoPath: null)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Foto tidak tersedia'), findsOneWidget);
  });
}
