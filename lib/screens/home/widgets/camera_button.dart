// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../services/permission_service.dart';
import '../../../services/storage_services.dart';

class CameraButton extends StatelessWidget {
  const CameraButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  static final ImagePicker _imagePicker = ImagePicker();

  static Future<String?> capturePhoto(
    BuildContext context, {
    required String photoType,
    PermissionService? permissionService,
    PhotoStorage? photoStorage,
  }) async {
    final permissions = permissionService ?? PermissionService();
    while (true) {
      final status = await permissions.requestCameraPermission();
      if (status.isGranted) break;

      if (status.isPermanentlyDenied || status.isRestricted) {
        if (!context.mounted) return null;
        final openSettings = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Izin kamera diperlukan'),
            content: const Text(
              'Kamera diperlukan untuk mengambil foto presensi. '
              'Izinkan akses kamera melalui pengaturan aplikasi.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Batal'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Buka pengaturan'),
              ),
            ],
          ),
        );
        if (openSettings != true) return null;
        await permissions.openAppSettings();
        if (!(await permissions.cameraPermissionStatus).isGranted) return null;
        break;
      }

      if (!context.mounted) return null;
      final retry = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Izin kamera diperlukan'),
          content: const Text(
            'Kamera diperlukan untuk mengambil foto sebagai bukti presensi.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      );
      if (retry != true) return null;
    }

    final image = await _imagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    return (photoStorage ?? StorageServices()).savePhoto(image.path, photoType);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.camera_alt_outlined),
        label: Text(label),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
