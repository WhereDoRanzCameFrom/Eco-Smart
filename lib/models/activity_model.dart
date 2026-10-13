// lib/models/activity_model.dart

class ActivityModel {
  final String id;
  final DateTime tanggal;
  final String lokasi;
  final String jenisKegiatan;
  final int peserta;

  ActivityModel({
    required this.id,
    required this.tanggal,
    required this.lokasi,
    required this.jenisKegiatan,
    required this.peserta,
  });

  // Firebase Ready
  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      id: map['id'] ?? '',
      tanggal: map['tanggal'] != null
          ? DateTime.parse(map['tanggal'])
          : DateTime.now(),
      lokasi: map['lokasi'] ?? '',
      jenisKegiatan: map['jenisKegiatan'] ?? '',
      peserta: map['peserta'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tanggal': tanggal.toIso8601String(),
      'lokasi': lokasi,
      'jenisKegiatan': jenisKegiatan,
      'peserta': peserta,
    };
  }

  ActivityModel copyWith({
    String? id,
    DateTime? tanggal,
    String? lokasi,
    String? jenisKegiatan,
    int? peserta,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      tanggal: tanggal ?? this.tanggal,
      lokasi: lokasi ?? this.lokasi,
      jenisKegiatan: jenisKegiatan ?? this.jenisKegiatan,
      peserta: peserta ?? this.peserta,
    );
  }
}
