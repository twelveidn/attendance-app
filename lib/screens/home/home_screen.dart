import 'dart:async';

// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/attendance_record.dart';
import '../../services/attendance_service.dart';
import '../../services/auth_services.dart';
import '../auth/login_screen.dart';
import '../history/history_screen.dart';
import 'widgets/action_button.dart';
import 'widgets/attendance_card.dart';
import 'widgets/camera_button.dart';
import 'widgets/profile_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final _authServices = AuthServices();
  final _attendanceService = AttendanceService();
  StreamSubscription<AttendanceRecord?>? _todaySubscription;
  AttendanceRecord? _todayRecord;
  Object? _streamError;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_subscribeToTodayRecord());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_subscribeToTodayRecord());
    }
  }

  Future<void> _subscribeToTodayRecord() async {
    await _todaySubscription?.cancel();
    if (!mounted) return;
    final userId = _authServices.currentUser?.uid;
    if (userId == null) return;
    _todaySubscription = _attendanceService
        .getTodayRecordStream(userId)
        .listen(
          (record) {
            if (mounted) {
              setState(() {
                _todayRecord = record;
                _streamError = null;
              });
            }
          },
          onError: (Object error) {
            if (mounted) setState(() => _streamError = error);
          },
        );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_todaySubscription?.cancel());
    super.dispose();
  }

  Future<void> _checkIn() => _recordAttendance(isCheckIn: true);

  Future<void> _checkOut() => _recordAttendance(isCheckIn: false);

  Future<void> _recordAttendance({required bool isCheckIn}) async {
    if (_isLoading) return;
    final user = _authServices.currentUser;
    if (user == null) {
      _returnToLogin();
      return;
    }
    if (!isCheckIn && _todayRecord == null) {
      _showMessage('Data presensi hari ini tidak ditemukan.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final photoPath = await CameraButton.capturePhoto(
        context,
        photoType: isCheckIn ? 'checkin' : 'checkout',
      );
      if (photoPath == null) return;

      final now = DateTime.now();
      if (isCheckIn) {
        await _attendanceService.createAttendanceRecord(
          AttendanceRecord(
            id: '',
            userId: user.uid,
            checkInTime: now,
            date: DateTime(now.year, now.month, now.day),
            checkInPhotoPath: photoPath,
          ),
        );
      } else {
        await _attendanceService.updateAttendanceRecord(
          _todayRecord!.copyWith(
            checkOutTime: now,
            checkOutPhotoPath: photoPath,
          ),
        );
      }
      _showMessage(
        isCheckIn ? 'Presensi masuk berhasil.' : 'Presensi pulang berhasil.',
      );
    } catch (error) {
      _showMessage('Gagal menyimpan presensi: $error');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signOut() async {
    final shouldSignOut = await showLogoutDialog(context);
    if (shouldSignOut != true) return;
    try {
      await _authServices.signOut();
    } catch (error) {
      _showMessage('Gagal keluar: $error');
    }
  }

  void _returnToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final user = _authServices.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final record = _todayRecord;
    final canCheckIn = record == null;
    final canCheckOut = record?.checkOutTime == null && record != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Presensi Digital')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              DateFormat('EEEE, d MMMM y', 'id_ID').format(DateTime.now()),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ProfileCard(email: user.email ?? ''),
            const SizedBox(height: 8),
            if (_streamError != null)
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Gagal memuat presensi: $_streamError. '
                    'Coba buka kembali aplikasi.',
                  ),
                ),
              ),
            AttendanceCard(record: record),
            const SizedBox(height: 16),
            if (canCheckIn)
              CameraButton(
                label: 'Masuk',
                onPressed: _checkIn,
                isLoading: _isLoading,
              )
            else if (canCheckOut)
              CameraButton(
                label: 'Pulang',
                onPressed: _checkOut,
                isLoading: _isLoading,
              ),
            const SizedBox(height: 12),
            ActionButton(
              label: 'Riwayat',
              icon: Icons.history,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const HistoryScreen()),
              ),
            ),
            const SizedBox(height: 4),
            TextButton.icon(
              onPressed: _isLoading ? null : _signOut,
              icon: const Icon(Icons.logout),
              label: const Text('Keluar'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool?> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Keluar dari akun?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Keluar'),
        ),
      ],
    ),
  );
}
