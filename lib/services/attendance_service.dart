import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/attendance_record.dart';

class AttendanceService {
  static const String storageKey = 'local_attendance_records_v1';
  static final AttendanceService instance = AttendanceService._();

  factory AttendanceService() => instance;

  AttendanceService._();

  final List<AttendanceRecord> _records = [];
  final StreamController<void> _updates = StreamController<void>.broadcast(
    sync: true,
  );
  Future<void>? _initializing;

  Future<void> _initStorage() => _initializing ??= _loadRecords();

  Future<void> _loadRecords() async {
    final preferences = await SharedPreferences.getInstance();
    final jsonRecords = preferences.getString(storageKey);
    if (jsonRecords == null) return;

    final decoded = jsonDecode(jsonRecords) as List<dynamic>;
    _records
      ..clear()
      ..addAll(
        decoded.map(
          (item) =>
              AttendanceRecord.fromJson(Map<String, dynamic>.from(item as Map)),
        ),
      );
  }

  Future<void> _persistRecords() async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(
      storageKey,
      jsonEncode(_records.map((record) => record.toJson()).toList()),
    );
    if (!saved) {
      throw StateError('Presensi gagal disimpan di perangkat.');
    }
  }

  void _emitUpdates() => _updates.add(null);

  Stream<List<AttendanceRecord>> getAttendanceRecords(String userId) {
    return Stream<List<AttendanceRecord>>.multi((controller) async {
      await _initStorage();
      final subscription = _updates.stream.listen((_) {
        controller.add(
          _records.where((record) => record.userId == userId).toList(),
        );
      }, onError: controller.addError);
      controller.add(
        _records.where((record) => record.userId == userId).toList(),
      );
      controller.onCancel = subscription.cancel;
    });
  }

  Stream<AttendanceRecord?> getTodayRecordStream(String userId) {
    return Stream<AttendanceRecord?>.multi((controller) async {
      await _initStorage();
      AttendanceRecord? todayRecord() {
        final now = DateTime.now();
        for (final record in _records) {
          if (record.userId == userId &&
              record.date.year == now.year &&
              record.date.month == now.month &&
              record.date.day == now.day) {
            return record;
          }
        }
        return null;
      }

      final subscription = _updates.stream.listen((_) {
        controller.add(todayRecord());
      }, onError: controller.addError);
      controller.add(todayRecord());
      controller.onCancel = subscription.cancel;
    });
  }

  Future<String> createAttendanceRecord(AttendanceRecord record) async {
    await _initStorage();
    final date = DateTime(record.date.year, record.date.month, record.date.day);
    final alreadyExists = _records.any(
      (saved) =>
          saved.userId == record.userId &&
          saved.date.year == date.year &&
          saved.date.month == date.month &&
          saved.date.day == date.day,
    );
    if (alreadyExists) {
      throw StateError('Presensi hari ini sudah ada.');
    }

    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final savedRecord = record.copyWith(id: id);
    final previousRecords = List<AttendanceRecord>.of(_records);
    _records.add(savedRecord);
    try {
      await _persistRecords();
    } catch (_) {
      _records
        ..clear()
        ..addAll(previousRecords);
      rethrow;
    }
    _emitUpdates();
    return id;
  }

  Future<void> updateAttendanceRecord(AttendanceRecord record) async {
    await _initStorage();
    final index = _records.indexWhere(
      (saved) => saved.id == record.id && saved.userId == record.userId,
    );
    if (index == -1) {
      throw StateError('Data presensi tidak ditemukan.');
    }

    final previousRecord = _records[index];
    _records[index] = record;
    try {
      await _persistRecords();
    } catch (_) {
      _records[index] = previousRecord;
      rethrow;
    }
    _emitUpdates();
  }
}
