import 'dart:io';

// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/attendance_record.dart';
import '../photo_viewer.dart';

class RecordCard extends StatelessWidget {
  const RecordCard({super.key, required this.record});

  final AttendanceRecord record;

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm', 'id_ID');
    final dateFormat = DateFormat('EEEE, d MMMM y', 'id_ID');
    final checkOut = record.checkOutTime;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateFormat.format(record.date),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text('Jam masuk: ${timeFormat.format(record.checkInTime)}'),
            Text(
              'Jam pulang: ${checkOut == null ? 'Belum pulang' : timeFormat.format(checkOut)}',
            ),
            if (record.totalHours case final duration?)
              Text(
                'Durasi: ${duration.inHours} jam '
                '${duration.inMinutes.remainder(60)} menit',
              ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _photoThumbnail(context, 'Foto masuk', record.checkInPhotoPath),
                if (checkOut != null)
                  _photoThumbnail(
                    context,
                    'Foto pulang',
                    record.checkOutPhotoPath,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _photoThumbnail(
    BuildContext context,
    String label,
    String? photoPath,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 4),
        InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => PhotoViewer(photoPath: photoPath),
            ),
          ),
          child: SizedBox(
            width: 84,
            height: 84,
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
