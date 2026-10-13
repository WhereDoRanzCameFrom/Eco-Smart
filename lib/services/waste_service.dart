// lib/services/waste_service.dart
import '../models/waste_record_model.dart';

// FIREBASE READY
// Replace dummy implementation with Firestore
// collection: waste_records

class WasteService {
  // final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ============================================================
  // DUMMY DATA - in-memory list, simulate runtime persistence
  // ============================================================
  final List<WasteRecordModel> _records = [
    WasteRecordModel(
      id: 'w001',
      tanggal: DateTime.now().subtract(const Duration(days: 1)),
      lokasi: 'Pantai Desa',
      jenisSampah: 'Plastik',
      beratKg: 15,
      status: 'terkumpul',
    ),
    WasteRecordModel(
      id: 'w002',
      tanggal: DateTime.now().subtract(const Duration(days: 2)),
      lokasi: 'Pantai Timur',
      jenisSampah: 'Botol Plastik',
      beratKg: 12,
      status: 'terkumpul',
    ),
    WasteRecordModel(
      id: 'w003',
      tanggal: DateTime.now().subtract(const Duration(days: 3)),
      lokasi: 'Pelabuhan Desa',
      jenisSampah: 'Kantong Plastik',
      beratKg: 8,
      status: 'tersalurkan',
    ),
    WasteRecordModel(
      id: 'w004',
      tanggal: DateTime.now().subtract(const Duration(days: 4)),
      lokasi: 'Muara Sungai',
      jenisSampah: 'Campuran Plastik',
      beratKg: 20,
      status: 'tersalurkan',
    ),
    WasteRecordModel(
      id: 'w005',
      tanggal: DateTime.now().subtract(const Duration(days: 5)),
      lokasi: 'Perairan Budidaya',
      jenisSampah: 'Jaring Plastik',
      beratKg: 25,
      status: 'terkendali',
    ),
    WasteRecordModel(
      id: 'w006',
      tanggal: DateTime.now().subtract(const Duration(days: 6)),
      lokasi: 'Pantai Desa',
      jenisSampah: 'Styrofoam',
      beratKg: 5,
      status: 'terkendali',
    ),
    WasteRecordModel(
      id: 'w007',
      tanggal: DateTime.now().subtract(const Duration(days: 7)),
      lokasi: 'Pantai Timur',
      jenisSampah: 'Tali Plastik',
      beratKg: 10,
      status: 'terkumpul',
    ),
  ];

  // ============================================================
  // GET ALL WASTE RECORDS
  // ============================================================
  Future<List<WasteRecordModel>> getWasteRecords() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final sorted = List<WasteRecordModel>.from(_records);
    sorted.sort((a, b) => b.tanggal.compareTo(a.tanggal));
    return sorted;

    // Firebase mode:
    // final snap = await _db.collection('waste_records')
    //     .orderBy('tanggal', descending: true).get();
    // return snap.docs.map((d) =>
    //     WasteRecordModel.fromMap({...d.data(), 'id': d.id})).toList();
  }

  // ============================================================
  // GET BY STATUS
  // ============================================================
  Future<List<WasteRecordModel>> getByStatus(String status) async {
    final all = await getWasteRecords();
    return all.where((r) => r.status == status).toList();
  }

  // ============================================================
  // TAMBAH RECORD
  // ============================================================
  Future<bool> addWasteRecord(WasteRecordModel record) async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      _records.insert(0, record);
      return true;

      // Firebase mode:
      // await _db.collection('waste_records').add(record.toMap());
      // return true;
    } catch (e) {
      return false;
    }
  }

  // ============================================================
  // UPDATE RECORD (Admin only)
  // ============================================================
  Future<bool> updateWasteRecord(WasteRecordModel updated) async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      final idx = _records.indexWhere((r) => r.id == updated.id);
      if (idx == -1) return false;
      _records[idx] = updated;
      return true;

      // Firebase mode:
      // await _db.collection('waste_records').doc(updated.id)
      //     .update(updated.toMap());
      // return true;
    } catch (e) {
      return false;
    }
  }

  // ============================================================
  // UPDATE STATUS ONLY (Admin & Petugas)
  // ============================================================
  Future<bool> updateStatus(String id, String newStatus) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      final idx = _records.indexWhere((r) => r.id == id);
      if (idx == -1) return false;
      _records[idx] = _records[idx].copyWith(status: newStatus);
      return true;

      // Firebase mode:
      // await _db.collection('waste_records').doc(id)
      //     .update({'status': newStatus});
      // return true;
    } catch (e) {
      return false;
    }
  }

  // ============================================================
  // STATISTIK RINGKAS
  // ============================================================
  Future<Map<String, dynamic>> getStatistik() async {
    final all = await getWasteRecords();
    double terkumpul = 0, tersalurkan = 0, terkendali = 0;
    for (final r in all) {
      switch (r.status) {
        case 'terkumpul':
          terkumpul += r.beratKg;
          break;
        case 'tersalurkan':
          tersalurkan += r.beratKg;
          break;
        case 'terkendali':
          terkendali += r.beratKg;
          break;
      }
    }
    return {
      'terkumpul': terkumpul,
      'tersalurkan': tersalurkan,
      'terkendali': terkendali,
      'total': terkumpul + tersalurkan + terkendali,
    };
  }

  // ============================================================
  // DATA MINGGUAN untuk Grafik (7 hari terakhir)
  // ============================================================
  Future<List<Map<String, dynamic>>> getWeeklyData() async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Data mingguan dummy untuk grafik
    return [
      {'day': 'Sen', 'berat': 15.0},
      {'day': 'Sel', 'berat': 22.0},
      {'day': 'Rab', 'berat': 18.0},
      {'day': 'Kam', 'berat': 30.0},
      {'day': 'Jum', 'berat': 25.0},
      {'day': 'Sab', 'berat': 35.0},
      {'day': 'Min', 'berat': 20.0},
    ];
  }
}
