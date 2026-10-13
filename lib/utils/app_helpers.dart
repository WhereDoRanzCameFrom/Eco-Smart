// lib/utils/app_helpers.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'app_colors.dart';
import 'app_constants.dart';

class AppHelpers {
  // Format tanggal ke "dd MMM yyyy" - contoh: "10 Jul 2026"
  static String formatTanggal(DateTime date) {
    return DateFormat('dd MMM yyyy', 'id_ID').format(date);
  }

  // Format berat: 15 → "15 kg"
  static String formatBerat(double kg) {
    if (kg == kg.truncateToDouble()) {
      return '${kg.toInt()} kg';
    }
    return '${kg.toStringAsFixed(1)} kg';
  }

  // Warna berdasarkan status sampah
  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case AppConstants.statusTerkumpul:
        return AppColors.terkumpul;
      case AppConstants.statusTersalurkan:
        return AppColors.tersalurkan;
      case AppConstants.statusTerkendali:
        return AppColors.terkendali;
      default:
        return AppColors.textMedium;
    }
  }

  // Background color chip status
  static Color statusBgColor(String status) {
    switch (status.toLowerCase()) {
      case AppConstants.statusTerkumpul:
        return const Color(0xFFE3F2FD);
      case AppConstants.statusTersalurkan:
        return const Color(0xFFE0F7FA);
      case AppConstants.statusTerkendali:
        return const Color(0xFFE8F5E9);
      default:
        return const Color(0xFFF5F5F5);
    }
  }

  // Icon untuk jenis kegiatan
  static IconData kegiatanIcon(String jenis) {
    switch (jenis) {
      case AppConstants.kegiatanBersihPantai:
        return Icons.beach_access_outlined;
      case AppConstants.kegiatanEdukasiWarga:
        return Icons.school_outlined;
      case AppConstants.kegiatanKerjaBakti:
        return Icons.people_outlined;
      case AppConstants.kegiatanPenyerahanSampah:
        return Icons.swap_horiz_outlined;
      case AppConstants.kegiatanPengosonganTPS:
        return Icons.delete_outline;
      default:
        return Icons.eco_outlined;
    }
  }

  // Role display name
  static String roleLabel(String role) {
    switch (role) {
      case AppConstants.roleAdmin:
        return 'Admin';
      case AppConstants.rolePetugas:
        return 'Petugas';
      case AppConstants.roleViewer:
        return 'Viewer';
      default:
        return role;
    }
  }

  // Cek apakah role bisa input data
  static bool canInput(String role) {
    return role == AppConstants.roleAdmin || role == AppConstants.rolePetugas;
  }

  // Cek apakah role bisa edit data
  static bool canEdit(String role) {
    return role == AppConstants.roleAdmin;
  }

  // Snackbar helper
  static void showSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        margin: const EdgeInsets.all(AppSpacing.md),
      ),
    );
  }

  // Format angka dengan titik ribuan
  static String formatNumber(int n) {
    return NumberFormat('#,###', 'id_ID').format(n);
  }
}
