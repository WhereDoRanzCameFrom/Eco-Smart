// lib/services/firestore_service.dart

// FIREBASE READY
// File ini adalah placeholder untuk integrasi Firestore di masa depan.
// Saat ini belum digunakan. Aktifkan saat migrasi ke Firebase.

// Instruksi migrasi:
// 1. Aktifkan firebase_core, firebase_auth, cloud_firestore di pubspec.yaml
// 2. Jalankan: flutterfire configure
// 3. Ganti dummy logic di setiap service dengan implementasi Firestore di sini
// 4. UI, navigation, dan SharedPreferences session TIDAK perlu diubah

/*
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Users
  static CollectionReference get users => _db.collection('users');
  // Locations
  static CollectionReference get locations => _db.collection('locations');
  // Activities
  static CollectionReference get activities => _db.collection('activities');
  // Waste Records
  static CollectionReference get wasteRecords => _db.collection('waste_records');

  // Generic add
  static Future<DocumentReference> add(
      CollectionReference col, Map<String, dynamic> data) async {
    return await col.add(data);
  }

  // Generic update
  static Future<void> update(
      CollectionReference col, String id, Map<String, dynamic> data) async {
    return await col.doc(id).update(data);
  }

  // Generic delete
  static Future<void> delete(CollectionReference col, String id) async {
    return await col.doc(id).delete();
  }
}
*/
