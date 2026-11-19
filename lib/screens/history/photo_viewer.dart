import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

// ignore: deprecated_member_use
import 'package:flutter/material.dart';

class PhotoViewer extends StatelessWidget {
  const PhotoViewer({super.key, required this.photoPath});

  final String? photoPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Foto presensi')),
      backgroundColor: Colors.black,
      body: Center(
        child: FutureBuilder<bool>(
          future: _localFileExists(photoPath),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            final value = photoPath;
            if (value != null && snapshot.data == true) {
              return _zoomable(
                Image.file(
                  File(value),
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const _PhotoPlaceholder(),
                ),
              );
            }

            final bytes = _decodeBase64(value);
            if (bytes != null) {
              return _zoomable(
                Image.memory(
                  bytes,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const _PhotoPlaceholder(),
                ),
              );
            }
            return const _PhotoPlaceholder();
          },
        ),
      ),
    );
  }

  Future<bool> _localFileExists(String? value) async {
    if (value == null || value.isEmpty) return false;
    try {
      return await File(value).exists();
    } on FileSystemException {
      return false;
    } on ArgumentError {
      return false;
    }
  }

  Uint8List? _decodeBase64(String? value) {
    if (value == null || value.isEmpty) return null;
    final encoded = value.startsWith('data:')
        ? value.substring(value.indexOf(',') + 1)
        : value;
    try {
      return base64Decode(encoded);
    } on FormatException {
      return null;
    }
  }

  Widget _zoomable(Widget image) {
    return InteractiveViewer(minScale: 0.8, maxScale: 4, child: image);
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.image_not_supported_outlined,
          color: Colors.white70,
          size: 56,
        ),
        SizedBox(height: 12),
        Text('Foto tidak tersedia', style: TextStyle(color: Colors.white70)),
      ],
    );
  }
}
