// lib/services/activity_service.dart
import '../models/activity_model.dart';

// FIREBASE READY
// Replace dummy implementation with Firestore
// collection: activities

class ActivityService {
  // final FirebaseFirestore _db = FirebaseFirestore.instance;

  final List<ActivityModel> _activities = [
    ActivityModel(
      id: 'a001',
      tanggal: DateTime.now().subtract(const Duration(days: 1)),
      lokasi: 'Pantai Desa',
      jenisKegiatan: 'Bersih Pantai',
      peserta: 35,
    ),
    ActivityModel(
      id: 'a002',
      tanggal: DateTime.now().subtract(const Duration(days: 3)),
      lokasi: 'Balai Desa',
      jenisKegiatan: 'Edukasi Warga',
      peserta: 40,
    ),
    ActivityModel(
      id: 'a003',
      tanggal: DateTime.now().subtract(const Duration(days: 5)),
      lokasi: 'Pantai Timur',
      jenisKegiatan: 'Kerja Bakti',
      peserta: 25,
    ),
    ActivityModel(
      id: 'a004',
      tanggal: DateTime.now().subtract(const Duration(days: 7)),
      lokasi: 'TPS Desa',
      jenisKegiatan: 'Pengosongan TPS',
      peserta: 30,
    ),
    ActivityModel(
      id: 'a005',
      tanggal: DateTime.now().subtract(const Duration(days: 10)),
      lokasi: 'Pelabuhan Desa',
      jenisKegiatan: 'Penyerahan Sampah',
      peserta: 15,
    ),
  ];

  // ============================================================
  // GET ALL ACTIVITIES
  // ============================================================
  Future<List<ActivityModel>> getActivities() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final sorted = List<ActivityModel>.from(_activities);
    sorted.sort((a, b) => b.tanggal.compareTo(a.tanggal));
    return sorted;

    // Firebase mode:
    // final snap = await _db.collection('activities')
    //     .orderBy('tanggal', descending: true).get();
    // return snap.docs.map((d) =>
    //     ActivityModel.fromMap({...d.data(), 'id': d.id})).toList();
  }

  // ============================================================
  // TAMBAH KEGIATAN
  // ============================================================
  Future<bool> addActivity(ActivityModel activity) async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      _activities.insert(0, activity);
      return true;

      // Firebase mode:
      // await _db.collection('activities').add(activity.toMap());
      // return true;
    } catch (e) {
      return false;
    }
  }

  // ============================================================
  // UPDATE KEGIATAN (Admin only)
  // ============================================================
  Future<bool> updateActivity(ActivityModel updated) async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      final idx = _activities.indexWhere((a) => a.id == updated.id);
      if (idx == -1) return false;
      _activities[idx] = updated;
      return true;

      // Firebase mode:
      // await _db.collection('activities').doc(updated.id)
      //     .update(updated.toMap());
      // return true;
    } catch (e) {
      return false;
    }
  }

  // ============================================================
  // STATISTIK KEGIATAN
  // ============================================================
  Future<Map<String, dynamic>> getStatistik() async {
    final all = await getActivities();
    int totalPeserta = all.fold(0, (sum, a) => sum + a.peserta);
    return {
      'totalKegiatan': all.length,
      'totalPeserta': totalPeserta,
    };
  }
}
