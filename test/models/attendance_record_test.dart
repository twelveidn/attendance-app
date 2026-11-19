import 'package:attendance_app/models/attendance_record.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final checkIn = DateTime(2026, 11, 12, 8);

  AttendanceRecord makeRecord({DateTime? checkOutTime, DateTime? checkInTime}) {
    return AttendanceRecord(
      id: 'record-1',
      userId: 'user-1',
      checkInTime: checkInTime ?? checkIn,
      checkOutTime: checkOutTime,
      date: DateTime(2026, 11, 12, 15, 30),
      checkInPhotoPath: '/photos/checkin.jpg',
    );
  }

  test('toJson dan fromJson mempertahankan data record', () {
    final record = makeRecord(checkOutTime: DateTime(2026, 11, 12, 16));
    final restored = AttendanceRecord.fromJson(record.toJson());

    expect(restored.id, record.id);
    expect(restored.userId, record.userId);
    expect(restored.checkInTime, record.checkInTime);
    expect(restored.checkOutTime, record.checkOutTime);
    expect(restored.date, DateTime(2026, 11, 12));
    expect(restored.checkInPhotoPath, record.checkInPhotoPath);
  });

  test('tanggal JSON menggunakan format YYYY-MM-DD', () {
    expect(makeRecord().toJson()['date'], '2026-11-12');
  });

  test('copyWith melengkapi waktu pulang tanpa mengubah id', () {
    final record = makeRecord().copyWith(
      checkOutTime: DateTime(2026, 11, 12, 16),
    );

    expect(record.id, 'record-1');
    expect(record.checkOutTime, DateTime(2026, 11, 12, 16));
  });

  test('totalHours null sebelum pulang dan menghitung durasi pulang', () {
    expect(makeRecord().totalHours, isNull);
    expect(
      makeRecord(checkOutTime: DateTime(2026, 11, 12, 16)).totalHours!.inHours,
      8,
    );
    expect(
      makeRecord(
        checkInTime: DateTime(2026, 11, 12, 8, 15),
        checkOutTime: DateTime(2026, 11, 12, 16, 45),
      ).totalHours,
      const Duration(hours: 8, minutes: 30),
    );
  });
}
