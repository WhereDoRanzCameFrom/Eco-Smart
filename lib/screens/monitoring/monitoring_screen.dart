// lib/screens/monitoring/monitoring_screen.dart
import 'package:flutter/material.dart';
import '../../services/waste_service.dart';
import '../../models/waste_record_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_helpers.dart';
import 'waste_form_screen.dart';
import 'waste_detail_screen.dart';

class MonitoringScreen extends StatefulWidget {
  final String userRole;
  const MonitoringScreen({super.key, required this.userRole});

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen>
    with SingleTickerProviderStateMixin {
  final _wasteService = WasteService();
  List<WasteRecordModel> _allRecords = [];
  String _filterStatus = 'semua';
  bool _isLoading = true;
  late TabController _tabController;

  final _tabs = ['semua', 'terkumpul', 'tersalurkan', 'terkendali'];
  final _tabLabels = ['Semua', 'Terkumpul', 'Tersalurkan', 'Terkendali'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _filterStatus = _tabs[_tabController.index]);
      }
    });
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await _wasteService.getWasteRecords();
    if (!mounted) return;
    setState(() {
      _allRecords = data;
      _isLoading = false;
    });
  }

  List<WasteRecordModel> get _filtered {
    if (_filterStatus == 'semua') return _allRecords;
    return _allRecords.where((r) => r.status == _filterStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    final canInput = AppHelpers.canInput(widget.userRole);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Monitoring Sampah',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: Container(
            color: AppColors.primary,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              labelStyle: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(fontSize: 12),
              tabs: _tabLabels
                  .map((l) => Tab(text: l, height: 40))
                  .toList(),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: _loadData,
              color: AppColors.primary,
              child: _filtered.isEmpty
                  ? _buildEmpty()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                      itemCount: _filtered.length,
                      itemBuilder: (_, i) => _buildCard(_filtered[i]),
                    ),
            ),
      floatingActionButton: canInput
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const WasteFormScreen()),
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
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.water_drop_outlined,
                size: 36, color: AppColors.primaryLight),
          ),
          const SizedBox(height: 16),
          const Text('Belum ada data sampah',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                  fontSize: 14)),
          const SizedBox(height: 4),
          const Text('Tap + untuk menambah data',
              style: TextStyle(color: AppColors.textMedium, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCard(WasteRecordModel r) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WasteDetailScreen(
              record: r,
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
            // Kolom kiri - icon + tanggal
            Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.water_drop_outlined,
                      color: AppColors.primaryLight, size: 22),
                ),
                const SizedBox(height: 4),
                Text(
                  _shortDate(r.tanggal),
                  style: const TextStyle(
                      fontSize: 9, color: AppColors.textLight),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(width: 12),
            // Tengah - info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r.lokasi,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    r.jenisSampah,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textMedium),
                  ),
                ],
              ),
            ),
            // Kanan - berat + status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  AppHelpers.formatBerat(r.beratKg),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark),
                ),
                const SizedBox(height: 6),
                _statusChip(r.status),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _shortDate(DateTime d) {
    final months = ['Jan','Feb','Mar','Apr','Mei','Jun',
                    'Jul','Agt','Sep','Okt','Nov','Des'];
    return '${d.day}\n${months[d.month - 1]}';
  }

  Widget _statusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppHelpers.statusBgColor(status),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        status,
        style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppHelpers.statusColor(status)),
      ),
    );
  }
}
