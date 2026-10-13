// lib/screens/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/dashboard_service.dart';
import '../../models/waste_record_model.dart';
import '../../models/activity_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_helpers.dart';

class DashboardScreen extends StatefulWidget {
  final String userRole;
  final String userName;
  const DashboardScreen(
      {super.key, required this.userRole, required this.userName});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _dashboardService = DashboardService();
  final _authService = AuthService();

  Map<String, dynamic> _summary = {};
  List<WasteRecordModel> _recentWaste = [];
  List<ActivityModel> _recentActivities = [];
  List<Map<String, dynamic>> _weeklyData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final results = await Future.wait([
      _dashboardService.getDashboardSummary(),
      _dashboardService.getRecentWaste(),
      _dashboardService.getRecentActivities(),
      _dashboardService.getWeeklyChart(),
    ]);
    if (!mounted) return;
    setState(() {
      _summary = results[0] as Map<String, dynamic>;
      _recentWaste = results[1] as List<WasteRecordModel>;
      _recentActivities = results[2] as List<ActivityModel>;
      _weeklyData = results[3] as List<Map<String, dynamic>>;
      _isLoading = false;
    });
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg)),
        title:
            const Text('Keluar', style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text('Yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _authService.logout();
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background putih-kebiruan seperti di desain
      backgroundColor: const Color(0xFFF0F7FF),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: _loadData,
              color: AppColors.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildStatSection(),
                    _buildWeeklyChart(),
                    _buildRecentSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  // ── HEADER dengan gelombang laut ──────────────────────────
  Widget _buildHeader() {
    return Stack(
      children: [
        // Background utama gradient biru
        Container(
          width: double.infinity,
          height: 200,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0D47A1),
                Color(0xFF1565C0),
                Color(0xFF1E88E5),
              ],
            ),
          ),
        ),

        // Gelombang di bagian bawah header
        const Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: CustomPaint(
            size: Size(double.infinity, 48),
            painter: _WavePainter(color: Color(0xFFF0F7FF)),
          ),
        ),

        // Konten header
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 16, 40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Teks greeting
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat datang,',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.userName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.location_on_outlined,
                                    size: 12, color: Colors.white),
                                SizedBox(width: 3),
                                Text(
                                  AppConstants.appSubtitle,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          AppHelpers.roleLabel(widget.userRole),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Icon app + logout
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.logout_rounded,
                              color: Colors.white.withValues(alpha: 0.8),
                              size: 22),
                          onPressed: _logout,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1.5),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/iconEco.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                              Icons.eco_rounded,
                              color: Colors.white,
                              size: 28),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── STAT CARDS ──────────────────────────────────────────────
  Widget _buildStatSection() {
    final terkumpul = (_summary['totalTerkumpul'] ?? 0.0) as double;
    final terkendali = (_summary['totalTerkendali'] ?? 0.0) as double;
    final kegiatan = (_summary['totalKegiatan'] ?? 0) as int;
    final peserta = (_summary['totalPeserta'] ?? 0) as int;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _statCard(
                  label: 'Total Terkumpul',
                  value: AppHelpers.formatBerat(terkumpul),
                  icon: Icons.water_drop_rounded,
                  iconColor: AppColors.primaryLight,
                  iconBg: const Color(0xFFDCEEFD),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _statCard(
                  label: 'Terkendali',
                  value: AppHelpers.formatBerat(terkendali),
                  icon: Icons.verified_outlined,
                  iconColor: AppColors.terkendali,
                  iconBg: const Color(0xFFE8F5E9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _statCard(
                  label: 'Kegiatan',
                  value: '$kegiatan kegiatan',
                  icon: Icons.event_note_rounded,
                  iconColor: AppColors.accent,
                  iconBg: const Color(0xFFE0F7FA),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _statCard(
                  label: 'Peserta Edukasi',
                  value: '$peserta orang',
                  icon: Icons.group_outlined,
                  iconColor: const Color(0xFF5C6BC0),
                  iconBg: const Color(0xFFE8EAF6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textMedium,
            ),
          ),
        ],
      ),
    );
  }

  // ── GRAFIK MINGGUAN ─────────────────────────────────────────
  Widget _buildWeeklyChart() {
    if (_weeklyData.isEmpty) return const SizedBox.shrink();

    final maxVal = _weeklyData
        .map((d) => (d['berat'] as double))
        .reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Grafik Mingguan',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('7 Hari',
                      style: TextStyle(
                          fontSize: 10,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 2),
            const Text('Berat sampah terkumpul (kg)',
                style: TextStyle(fontSize: 11, color: AppColors.textMedium)),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: CustomPaint(
                painter: _LineChartPainter(
                  data: _weeklyData.map((d) => (d['berat'] as double)).toList(),
                  maxVal: maxVal,
                  lineColor: AppColors.primaryLight,
                ),
                child: const SizedBox.expand(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _weeklyData
                  .map((d) => Text(d['day'] as String,
                      style: const TextStyle(
                          fontSize: 10, color: AppColors.textMedium)))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ── RECENT ──────────────────────────────────────────────────
  Widget _buildRecentSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Data Sampah Terbaru',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, minimumSize: Size.zero),
                child: const Text('Lihat semua',
                    style:
                        TextStyle(fontSize: 12, color: AppColors.primaryLight)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: _recentWaste.asMap().entries.map((e) {
                final i = e.key;
                final r = e.value;
                return Column(
                  children: [
                    if (i > 0)
                      const Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: AppColors.divider),
                    _wasteListTile(r),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Aktivitas Terbaru',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, minimumSize: Size.zero),
                child: const Text('Lihat semua',
                    style:
                        TextStyle(fontSize: 12, color: AppColors.primaryLight)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ..._recentActivities.map((a) => _activityCard(a)),
        ],
      ),
    );
  }

  Widget _wasteListTile(WasteRecordModel r) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFDCEEFD),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.water_drop_outlined,
                color: AppColors.primaryLight, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.lokasi,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark)),
                const SizedBox(height: 2),
                Text(
                  '${AppHelpers.formatTanggal(r.tanggal)} · ${r.jenisSampah}',
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textMedium),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(AppHelpers.formatBerat(r.beratKg),
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppHelpers.statusBgColor(r.status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(r.status,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppHelpers.statusColor(r.status))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _activityCard(ActivityModel a) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(AppHelpers.kegiatanIcon(a.jenisKegiatan),
                color: AppColors.accent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(a.jenisKegiatan,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark)),
                const SizedBox(height: 2),
                Text(
                  '${AppHelpers.formatTanggal(a.tanggal)} · ${a.lokasi}',
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textMedium),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('${a.peserta} orang',
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}

// ── WAVE PAINTER ─────────────────────────────────────────────
class _WavePainter extends CustomPainter {
  final Color color;
  const _WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    // Gelombang pertama - besar
    path.cubicTo(
      size.width * 0.15,
      size.height * 0.2,
      size.width * 0.35,
      size.height * 0.05,
      size.width * 0.5,
      size.height * 0.4,
    );
    // Gelombang kedua
    path.cubicTo(
      size.width * 0.65,
      size.height * 0.75,
      size.width * 0.85,
      size.height * 0.5,
      size.width,
      size.height * 0.2,
    );
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter old) => old.color != color;
}

// ── LINE CHART PAINTER ────────────────────────────────────────
class _LineChartPainter extends CustomPainter {
  final List<double> data;
  final double maxVal;
  final Color lineColor;

  const _LineChartPainter({
    required this.data,
    required this.maxVal,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || maxVal == 0) return;
    final n = data.length;
    final stepX = size.width / (n - 1);

    final pts = List.generate(n, (i) {
      final x = i * stepX;
      final y = size.height - (data[i] / maxVal) * size.height * 0.9;
      return Offset(x, y);
    });

    // Fill
    final fillPath = Path()..moveTo(pts.first.dx, size.height);
    for (int i = 1; i < pts.length; i++) {
      final cp1 = Offset((pts[i - 1].dx + pts[i].dx) / 2, pts[i - 1].dy);
      final cp2 = Offset((pts[i - 1].dx + pts[i].dx) / 2, pts[i].dy);
      if (i == 1) fillPath.lineTo(pts[0].dx, pts[0].dy);
      fillPath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, pts[i].dx, pts[i].dy);
    }
    fillPath.lineTo(pts.last.dx, size.height);
    fillPath.close();
    canvas.drawPath(
        fillPath,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              lineColor.withValues(alpha: 0.18),
              lineColor.withValues(alpha: 0.0),
            ],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
          ..style = PaintingStyle.fill);

    // Line
    final linePath = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (int i = 1; i < pts.length; i++) {
      final cp1 = Offset((pts[i - 1].dx + pts[i].dx) / 2, pts[i - 1].dy);
      final cp2 = Offset((pts[i - 1].dx + pts[i].dx) / 2, pts[i].dy);
      linePath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, pts[i].dx, pts[i].dy);
    }
    canvas.drawPath(
        linePath,
        Paint()
          ..color = lineColor
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke);

    // Dots
    for (final p in pts) {
      canvas.drawCircle(p, 5, Paint()..color = Colors.white);
      canvas.drawCircle(p, 3.5, Paint()..color = lineColor);
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter old) => false;
}
