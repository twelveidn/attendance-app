# Presensi Digital

Aplikasi Android sederhana untuk mencatat presensi masuk dan pulang dengan foto serta melihat riwayat presensi akun sendiri. Data dan foto disimpan lokal di perangkat.

## Menjalankan aplikasi

1. Pastikan Flutter tersedia dengan `flutter doctor`.
2. Ambil dependensi dengan `flutter pub get`.
3. Periksa perangkat dengan `flutter devices`.
4. Jalankan aplikasi dengan `flutter run`.

Sebelum Firebase disiapkan, aplikasi menampilkan layar **Firebase belum dikonfigurasi** dengan langkah setup. Pasang Firebase CLI, jalankan `firebase login`, aktifkan FlutterFire CLI dengan `dart pub global activate flutterfire_cli`, lalu jalankan `flutterfire configure --project=ID_PROJECT_ANDA`. Perintah tersebut akan membuat konfigurasi lokal yang diperlukan.

ID aplikasi Android (applicationId): `com.example.attendance_app`.

## Peta struktur

- `lib/main.dart`: inisialisasi Firebase, tema, dan aplikasi.
- `lib/firebase_options.dart`: placeholder konfigurasi Firebase yang akan ditimpa FlutterFire CLI.
- `lib/models/`: model presensi dan profil.
- `lib/services/`: autentikasi, penyimpanan presensi, adapter, foto, dan izin.
- `lib/wrapper/`: pemilihan layar berdasarkan sesi autentikasi.
- `lib/screens/auth/`: layar masuk dan daftar.
- `lib/screens/home/`: beranda serta komponen presensi.
- `lib/screens/history/`: riwayat dan tampilan foto.
- `test/`: pengujian model dan dialog.

## Batasan versi ini

- Hanya mendukung aplikasi Android.
- Belum memakai Firestore, sinkronisasi cloud, atau Firebase Storage.
- Belum ada GPS, QR, verifikasi wajah, admin, rekap semua pengguna, penggajian, shift, persetujuan izin, dan ekspor laporan.
- Belum ada filter tanggal, ringkasan durasi, notifikasi, atau sinkronisasi lintas perangkat.
- Firebase Authentication menggunakan email dan kata sandi; tidak ada profil pengguna yang ditulis ke Firestore.
- Foto disimpan di perangkat. Foto dan catatan lokal dapat hilang jika data aplikasi dihapus.
