import 'package:permission_handler/permission_handler.dart' as handler;

class PermissionService {
  Future<handler.PermissionStatus> requestCameraPermission() {
    return handler.Permission.camera.request();
  }

  Future<handler.PermissionStatus> get cameraPermissionStatus {
    return handler.Permission.camera.status;
  }

  Future<bool> openAppSettings() => handler.openAppSettings();
}
