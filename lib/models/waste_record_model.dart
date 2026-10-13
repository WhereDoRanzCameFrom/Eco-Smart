// lib/models/waste_record_model.dart

class WasteRecordModel {
  final String id;
  final DateTime tanggal;
  final String lokasi;
  final String jenisSampah;
  final double beratKg;
  final String status; // 'terkumpul' | 'tersalurkan' | 'terkendali'

  WasteRecordModel({
    required this.id,
    required this.tanggal,
    required this.lokasi,
    required this.jenisSampah,
    required this.beratKg,
    required this.status,
  });

  // Firebase Ready
  factory WasteRecordModel.fromMap(Map<String, dynamic> map) {
    return WasteRecordModel(
      id: map['id'] ?? '',
      tanggal: map['tanggal'] != null
          ? DateTime.parse(map['tanggal'])
          : DateTime.now(),
      lokasi: map['lokasi'] ?? '',
      jenisSampah: map['jenisSampah'] ?? '',
      beratKg: (map['beratKg'] ?? 0).toDouble(),
      status: map['status'] ?? 'terkumpul',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tanggal': tanggal.toIso8601String(),
      'lokasi': lokasi,
      'jenisSampah': jenisSampah,
      'beratKg': beratKg,
      'status': status,
    };
  }

  WasteRecordModel copyWith({
    String? id,
    DateTime? tanggal,
    String? lokasi,
    String? jenisSampah,
    double? beratKg,
    String? status,
  }) {
    return WasteRecordModel(
      id: id ?? this.id,
      tanggal: tanggal ?? this.tanggal,
      lokasi: lokasi ?? this.lokasi,
      jenisSampah: jenisSampah ?? this.jenisSampah,
      beratKg: beratKg ?? this.beratKg,
      status: status ?? this.status,
    );
  }
}
