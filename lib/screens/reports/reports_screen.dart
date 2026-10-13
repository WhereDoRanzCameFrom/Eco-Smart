// lib/screens/reports/reports_screen.dart
import 'package:flutter/material.dart';
import '../../services/waste_service.dart';
import '../../services/activity_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_helpers.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final _wasteService = WasteService();
  final _activityService = ActivityService();

  Map<String, dynamic> _wasteStats = {};
  Map<String, dynamic> _activityStats = {};
  List<Map<String, dynamic>> _weeklyData = [];
  bool _isLoading = true;
  String _selectedPeriode = 'Juli 2026';

  final _periodeList = ['Mei 2026', 'Juni 2026', 'Juli 2026'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final results = await Future.wait([
      _wasteService.getStatistik(),
      _activityService.getStatistik(),
      _wasteService.getWeeklyData(),
    ]);
    if (!mounted) return;
    setState(() {
      _wasteStats = results[0] as Map<String, dynamic>;
      _activityStats = results[1] as Map<String, dynamic>;
      _weeklyData = results[2] as List<Map<String, dynamic>>;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Laporan',
            style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: _loadData,
              color: AppColors.primary,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  _buildPeriodeFilter(),
                  const SizedBox(height: 16),
                  _buildRekap(),
                  const SizedBox(height: 20),
                  _buildGrafikRekap(),
                  const SizedBox(height: 20),
                  _buildRingkasanKegiatan(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }

  // ── PERIODE FILTER ─────────────────────────────────────────
  Widget _buildPeriodeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Periode',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.divider),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedPeriode,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textMedium),
              style: const TextStyle(fontSize: 14, color: AppColors.textDark),
              onChanged: (v) {
                if (v != null) setState(() => _selectedPeriode = v);
              },
              items: _periodeList
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  // ── REKAP SAMPAH ───────────────────────────────────────────
  Widget _buildRekap() {
    final terkumpul = (_wasteStats['terkumpul'] ?? 0.0) as double;
    final tersalurkan = (_wasteStats['tersalurkan'] ?? 0.0) as double;
    final terkendali = (_wasteStats['terkendali'] ?? 0.0) as double;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Rekap Sampah',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: _rekapCard(
                    'Terkumpul',
                    AppHelpers.formatBerat(terkumpul),
                    AppColors.terkumpul,
                    Icons.water_drop_outlined)),
            const SizedBox(width: 8),
            Expanded(
                child: _rekapCard(
                    'Tersalurkan',
                    AppHelpers.formatBerat(tersalurkan),
                    AppColors.tersalurkan,
                    Icons.swap_horiz_outlined)),
            const SizedBox(width: 8),
            Expanded(
                child: _rekapCard(
                    'Terkendali',
                    AppHelpers.formatBerat(terkendali),
                    AppColors.terkendali,
                    Icons.check_circle_outline_rounded)),
          ],
        ),
      ],
    );
  }

  Widget _rekapCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 10),
          Text(value,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(label,
              style:
                  const TextStyle(fontSize: 10, color: AppColors.textMedium)),
        ],
      ),
    );
  }

  // ── GRAFIK REKAP ───────────────────────────────────────────
  Widget _buildGrafikRekap() {
    if (_weeklyData.isEmpty) return const SizedBox.shrink();

    // Minggu data dummy
    final mingguData = [
      {'label': 'M1', 'nilai': 120.0},
      {'label': 'M2', 'nilai': 175.0},
      {'label': 'M3', 'nilai': 148.0},
      {'label': 'M4', 'nilai': 200.0},
      {'label': 'M5', 'nilai': 165.0},
    ];
    final maxMinggu = mingguData
        .map((d) => d['nilai'] as double)
        .reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Grafik Rekap',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: [
              BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 3))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total Sampah per Minggu (kg)',
                  style: TextStyle(fontSize: 12, color: AppColors.textMedium)),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: mingguData.map((d) {
                  final ratio = maxMinggu > 0
                      ? (d['nilai'] as double) / maxMinggu
                      : 0.0;
                  return _bar(d['label'] as String,
                      (d['nilai'] as double).toInt().toString(), ratio);
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bar(String label, String value, double ratio) {
    final barH = (70 * ratio).clamp(2.0, 70.0);
    return SizedBox(
      width: 44,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary)),
          const SizedBox(height: 4),
          Container(
            width: 32,
            height: barH,
            decoration: const BoxDecoration(
              gradient: AppColors.cardGradientBlue,
              borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
            ),
          ),
          const SizedBox(height: 5),
          Text(label,
              style: const TextStyle(fontSize: 11, color: AppColors.textMedium)),
        ],
      ),
    );
  }

  // ── RINGKASAN KEGIATAN ────────────────────────────────────
  Widget _buildRingkasanKegiatan() {
    final totalKegiatan = (_activityStats['totalKegiatan'] ?? 0) as int;
    final totalPeserta = (_activityStats['totalPeserta'] ?? 0) as int;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ringkasan Kegiatan',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: [
              BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 3))
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _kegiatanStat('Total Kegiatan', '$totalKegiatan',
                    'kegiatan', Icons.event_note_rounded, AppColors.primary),
              ),
              Container(width: 1, height: 60, color: AppColors.divider),
              Expanded(
                child: _kegiatanStat('Total Peserta', '$totalPeserta', 'orang',
                    Icons.people_outline_rounded, AppColors.accent),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _kegiatanStat(
      String label, String value, String unit, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w800, color: color)),
          Text(unit,
              style:
                  const TextStyle(fontSize: 11, color: AppColors.textMedium)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMedium,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
