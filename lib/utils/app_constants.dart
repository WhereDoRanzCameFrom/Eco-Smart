// lib/utils/app_constants.dart

class AppConstants {
  static const String appName = 'Eco Smart';
  static const String appSubtitle = 'Desa Tanjung Harapan, Sebatik Timur';
  static const String appTagline = 'Laut Bersih, Rumput Laut Tumbuh, Desa Sejahtera';

  // Roles
  static const String roleAdmin = 'admin';
  static const String rolePetugas = 'petugas';
  static const String roleViewer = 'viewer';

  // Status Sampah
  static const String statusTerkumpul = 'terkumpul';
  static const String statusTersalurkan = 'tersalurkan';
  static const String statusTerkendali = 'terkendali';

  static const List<String> statusList = [
    statusTerkumpul,
    statusTersalurkan,
    statusTerkendali,
  ];

  // Jenis Kegiatan
  static const String kegiatanBersihPantai = 'Bersih Pantai';
  static const String kegiatanEdukasiWarga = 'Edukasi Warga';
  static const String kegiatanKerjaBakti = 'Kerja Bakti';
  static const String kegiatanPenyerahanSampah = 'Penyerahan Sampah';
  static const String kegiatanPengosonganTPS = 'Pengosongan TPS';



}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double full = 100.0;
}
