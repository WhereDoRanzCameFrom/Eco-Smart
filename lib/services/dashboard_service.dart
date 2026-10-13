// lib/services/dashboard_service.dart
import 'waste_service.dart';
import 'activity_service.dart';
import '../models/waste_record_model.dart';
import '../models/activity_model.dart';

// FIREBASE READY
// Replace dummy implementation with Firestore aggregation queries

class DashboardService {
  final WasteService _wasteService = WasteService();
  final ActivityService _activityService = ActivityService();

  // ============================================================
  // GET DASHBOARD SUMMARY
  // ============================================================
  Future<Map<String, dynamic>> getDashboardSummary() async {
    final wasteStats = await _wasteService.getStatistik();
    final activityStats = await _activityService.getStatistik();

    return {
      'totalTerkumpul': wasteStats['terkumpul'],
      'totalTerkendali': wasteStats['terkendali'],
      'totalKegiatan': activityStats['totalKegiatan'],
      'totalPeserta': activityStats['totalPeserta'],
    };
  }

  // ============================================================
  // GET RECENT WASTE RECORDS (5 terbaru)
  // ============================================================
  Future<List<WasteRecordModel>> getRecentWaste() async {
    final all = await _wasteService.getWasteRecords();
    return all.take(5).toList();
  }

  // ============================================================
  // GET RECENT ACTIVITIES (3 terbaru)
  // ============================================================
  Future<List<ActivityModel>> getRecentActivities() async {
    final all = await _activityService.getActivities();
    return all.take(3).toList();
  }

  // ============================================================
  // DATA GRAFIK MINGGUAN
  // ============================================================
  Future<List<Map<String, dynamic>>> getWeeklyChart() async {
    return await _wasteService.getWeeklyData();
  }
}
