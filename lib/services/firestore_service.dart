import 'dart:async';

import '../models/attendance_record.dart';
import 'attendance_service.dart';

// Nama kelas belum berarti membaca Firestore. Versi ini hanya meneruskan ke AttendanceService.
class FirestoreService {
  FirestoreService({AttendanceService? attendanceService})
    : _attendanceService = attendanceService ?? AttendanceService();

  final AttendanceService _attendanceService;

  Stream<List<AttendanceRecord>> getAttendanceRecords(String userId) =>
      _attendanceService.getAttendanceRecords(userId);

  Stream<AttendanceRecord?> getTodayRecordStream(String userId) =>
      _attendanceService.getTodayRecordStream(userId);

  Future<String> createAttendanceRecord(AttendanceRecord record) =>
      _attendanceService.createAttendanceRecord(record);

  Future<void> updateAttendanceRecord(AttendanceRecord record) =>
      _attendanceService.updateAttendanceRecord(record);
}
