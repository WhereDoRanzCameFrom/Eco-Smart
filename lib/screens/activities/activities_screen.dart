// lib/screens/activities/activities_screen.dart
import 'package:flutter/material.dart';
import '../../services/activity_service.dart';
import '../../models/activity_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_helpers.dart';
import 'activity_form_screen.dart';
import 'activity_detail_screen.dart';

class ActivitiesScreen extends StatefulWidget {
  final String userRole;
  const ActivitiesScreen({super.key, required this.userRole});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  final _activityService = ActivityService();
  List<ActivityModel> _activities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await _activityService.getActivities();
    if (!mounted) return;
    setState(() {
      _activities = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final canInput = AppHelpers.canInput(widget.userRole);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Kegiatan Lingkungan',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: _loadData,
              color: AppColors.primary,
              child: _activities.isEmpty
                  ? _buildEmpty()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                      itemCount: _activities.length,
                      itemBuilder: (_, i) => _buildCard(_activities[i]),
                    ),
            ),
      floatingActionButton: canInput
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ActivityFormScreen()),
                );
                _loadData();
              },
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              child: const Icon(Icons.add_rounded, size: 28),
            )
          : null,
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.event_note_outlined,
                size: 36, color: AppColors.accent),
          ),
          const SizedBox(height: 16),
          const Text('Belum ada kegiatan',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                  fontSize: 14)),
          const SizedBox(height: 4),
          const Text('Tap + untuk menambah kegiatan',
              style: TextStyle(color: AppColors.textMedium, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCard(ActivityModel a) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ActivityDetailScreen(
              activity: a,
              userRole: widget.userRole,
              onRefresh: _loadData,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 3))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.accentLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                AppHelpers.kegiatanIcon(a.jenisKegiatan),
                color: AppColors.accent,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(a.jenisKegiatan,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark)),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 12, color: AppColors.textLight),
                      const SizedBox(width: 2),
                      Text(a.lokasi,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textMedium)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 12, color: AppColors.textLight),
                      const SizedBox(width: 2),
                      Text(AppHelpers.formatTanggal(a.tanggal),
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textMedium)),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(Icons.people_outline_rounded,
                    size: 14, color: AppColors.textLight),
                const SizedBox(height: 2),
                Text(
                  '${a.peserta}',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary),
                ),
                const Text('peserta',
                    style: TextStyle(
                        fontSize: 10, color: AppColors.textMedium)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
