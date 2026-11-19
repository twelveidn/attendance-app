import 'dart:io';

// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/attendance_record.dart';
import '../../history/photo_viewer.dart';

class AttendanceCard extends StatelessWidget {
  const AttendanceCard({super.key, required this.record});

  final AttendanceRecord? record;

  @override
  Widget build(BuildContext context) {
    final current = record;
    if (current == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(Icons.event_available_outlined),
              SizedBox(width: 12),
              Expanded(child: Text('Belum ada presensi hari ini')),
            ],
          ),
        ),
      );
    }

    final timeFormat = DateFormat('HH:mm', 'id_ID');
    final checkOut = current.checkOutTime;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              checkOut == null ? 'Presensi masuk tercatat' : 'Presensi selesai',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text('Jam masuk: ${timeFormat.format(current.checkInTime)}'),
            if (checkOut != null) ...[
              const SizedBox(height: 6),
              Text('Jam pulang: ${timeFormat.format(checkOut)}'),
              const SizedBox(height: 6),
              Text('Durasi: ${_formatDuration(current.totalHours!)}'),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                _photoTile(context, 'Foto masuk', current.checkInPhotoPath),
                if (checkOut != null) ...[
                  const SizedBox(width: 12),
                  _photoTile(context, 'Foto pulang', current.checkOutPhotoPath),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _photoTile(BuildContext context, String label, String? photoPath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 6),
        InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => PhotoViewer(photoPath: photoPath),
            ),
          ),
          child: SizedBox(
            width: 76,
            height: 76,
            child: photoPath == null
                ? const _MissingPhotoTile()
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(photoPath),
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const _MissingPhotoTile(),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  static String _formatDuration(Duration duration) {
    return '${duration.inHours} jam ${duration.inMinutes.remainder(60)} menit';
  }
}

class _MissingPhotoTile extends StatelessWidget {
  const _MissingPhotoTile();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFFE7ECEA),
      child: Center(child: Icon(Icons.image_not_supported_outlined)),
    );
  }
}
