import 'package:flutter_test/flutter_test.dart';

import 'package:attendance_app/screens/config_error/config_error_screen.dart';

void main() {
  testWidgets('menampilkan langkah setup Firebase dan detail error', (
    tester,
  ) async {
    await tester.pumpWidget(
      ConfigErrorScreen(error: UnsupportedError('Firebase belum siap')),
    );

    expect(find.text('Firebase belum dikonfigurasi'), findsOneWidget);
    expect(find.text('1. Pasang Firebase CLI.'), findsOneWidget);
    expect(find.text('2. Jalankan `firebase login`.'), findsOneWidget);
    expect(
      find.text('3. Jalankan `dart pub global activate flutterfire_cli`.'),
      findsOneWidget,
    );
    expect(
      find.text(
        '4. Jalankan `flutterfire configure --project=ID_PROJECT_ANDA`.',
      ),
      findsOneWidget,
    );
    expect(find.text('5. Jalankan ulang aplikasi.'), findsOneWidget);
    expect(
      find.text('Detail error: Unsupported operation: Firebase belum siap'),
      findsOneWidget,
    );
  });
}
