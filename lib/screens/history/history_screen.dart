// ignore: deprecated_member_use
import 'package:flutter/material.dart';

import '../../models/attendance_record.dart';
import '../../services/attendance_service.dart';
import '../../services/auth_services.dart';
import 'widgets/record_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = AuthServices().currentUser?.uid;
    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Riwayat presensi')),
        body: const Center(child: Text('Silakan masuk kembali ke akun.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat presensi')),
      body: StreamBuilder<List<AttendanceRecord>>(
        stream: AttendanceService().getAttendanceRecords(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Gagal memuat riwayat: ${snapshot.error}. '
                  'Coba buka kembali halaman ini.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final records = List<AttendanceRecord>.of(snapshot.data ?? [])
            ..sort((a, b) => b.checkInTime.compareTo(a.checkInTime));
          if (records.isEmpty) {
            return const Center(child: Text('Belum ada riwayat presensi'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            itemBuilder: (context, index) => RecordCard(record: records[index]),
          );
        },
      ),
    );
  }
}
