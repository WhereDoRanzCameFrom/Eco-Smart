// lib/services/auth_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

// FIREBASE READY
// Replace dummy implementation with Firebase Auth + Firestore

class AuthService {
  // SharedPreferences keys - JANGAN DIHAPUS, tetap digunakan sebagai session manager
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';
  static const String _keyUserRole = 'user_role';

  // ============================================================
  // DUMMY ACCOUNTS
  // TODO: Replace login validation with Firebase Auth if needed
  // ============================================================
  final List<Map<String, String>> _dummyAccounts = [
    {
      'username': 'admin',
      'password': 'admin123',
      'id': 'user_001',
      'name': 'Admin Eco Smart',
      'role': 'admin',
    },
    {
      'username': 'petugas',
      'password': 'petugas123',
      'id': 'user_002',
      'name': 'Petugas Lapangan',
      'role': 'petugas',
    },
    {
      'username': 'viewer',
      'password': 'viewer123',
      'id': 'user_003',
      'name': 'Viewer Desa',
      'role': 'viewer',
    },
  ];

  // ============================================================
  // LOGIN
  // ============================================================
  Future<Map<String, dynamic>> login(
      String username, String password) async {
    try {
      // Simulasi network delay
      await Future.delayed(const Duration(milliseconds: 800));

      final account = _dummyAccounts.firstWhere(
        (a) =>
            a['username'] == username.trim() && a['password'] == password,
        orElse: () => {},
      );

      if (account.isEmpty) {
        return {
          'success': false,
          'message': 'Username atau password salah'
        };
      }

      final user = UserModel(
        id: account['id']!,
        name: account['name']!,
        role: account['role']!,
      );

      await _saveSession(user);
      return {'success': true, 'user': user};

      // ============================================================
      // FIREBASE MODE - Uncomment kalau Firebase sudah setup
      // ============================================================
      // final credential = await FirebaseAuth.instance
      //     .signInWithEmailAndPassword(email: username, password: password);
      // final doc = await FirebaseFirestore.instance
      //     .collection('users').doc(credential.user!.uid).get();
      // final user = UserModel.fromMap({...doc.data()!, 'id': doc.id});
      // await _saveSession(user);
      // return {'success': true, 'user': user};
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // ============================================================
  // LOGOUT - Hapus seluruh session SharedPreferences
  // ============================================================
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // Firebase: await FirebaseAuth.instance.signOut();
  }

  // ============================================================
  // CEK SESSION - Untuk auto-login di Splash Screen
  // SharedPreferences WAJIB dipertahankan sebagai session manager
  // ============================================================
  Future<UserModel?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
    if (!isLoggedIn) return null;

    return UserModel(
      id: prefs.getString(_keyUserId) ?? '',
      name: prefs.getString(_keyUserName) ?? '',
      role: prefs.getString(_keyUserRole) ?? 'viewer',
    );
  }

  // ============================================================
  // SIMPAN SESSION ke SharedPreferences
  // ============================================================
  Future<void> _saveSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUserId, user.id);
    await prefs.setString(_keyUserName, user.name);
    await prefs.setString(_keyUserRole, user.role);
  }
}
