// lib/screens/monitoring/waste_detail_screen.dart
import 'package:flutter/material.dart';
import '../../services/waste_service.dart';
import '../../models/waste_record_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_helpers.dart';
import 'waste_form_screen.dart';

class WasteDetailScreen extends StatefulWidget {
  final WasteRecordModel record;
  final String userRole;
  final VoidCallback onRefresh;
  const WasteDetailScreen({
    super.key,
    required this.record,
    required this.userRole,
    required this.onRefresh,
  });

  @override
  State<WasteDetailScreen> createState() => _WasteDetailScreenState();
}

class _WasteDetailScreenState extends State<WasteDetailScreen> {
  final _wasteService = WasteService();
  late WasteRecordModel _record;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _record = widget.record;
  }

  Future<void> _updateStatus(String newStatus) async {
    setState(() => _isUpdating = true);
    final ok = await _wasteService.updateStatus(_record.id, newStatus);
    if (!mounted) return;
    setState(() {
      _isUpdating = false;
      if (ok) _record = _record.copyWith(status: newStatus);
    });
    AppHelpers.showSnackBar(
        context, ok ? 'Status berhasil diperbarui' : 'Gagal memperbarui status',
        isError: !ok);
    widget.onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final canEdit = AppHelpers.canEdit(widget.userRole);
    final canInput = AppHelpers.canInput(widget.userRole);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detail Sampah',
            style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: canEdit
            ? [
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              WasteFormScreen(existing: _record)),
                    );
                    widget.onRefresh();
                    if (mounted) Navigator.pop(context);
                  },
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            // Header card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.headerGradient,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.water_drop_rounded,
                          color: Colors.white70, size: 20),
                      const SizedBox(width: 8),
                      Text(_record.lokasi,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppHelpers.formatBerat(_record.beratKg),
                    style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _record.jenisSampah,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Detail card
            _infoCard(children: [
              _infoRow('Tanggal', AppHelpers.formatTanggal(_record.tanggal)),
              _divider(),
              _infoRow('Lokasi', _record.lokasi),
              _divider(),
              _infoRow('Jenis Sampah', _record.jenisSampah),
              _divider(),
              _infoRow('Berat', AppHelpers.formatBerat(_record.beratKg)),
              _divider(),
              _infoRowWidget(
                'Status',
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppHelpers.statusBgColor(_record.status),
                    borderRadius:
                        BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    _record.status,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppHelpers.statusColor(_record.status)),
                  ),
                ),
              ),
            ]),

            // Update status section
            if (canInput) ...[
              const SizedBox(height: 20),
              _infoCard(children: [
                const Text('Update Status',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
                const SizedBox(height: 14),
                if (_isUpdating)
                  const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary))
                else
                  Wrap(
                    spacing: 8,
                    children: AppConstants.statusList.map((s) {
                      final isActive = _record.status == s;
                      return GestureDetector(
                        onTap: isActive ? null : () => _updateStatus(s),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppHelpers.statusColor(s)
                                : AppHelpers.statusBgColor(s),
                            borderRadius:
                                BorderRadius.circular(AppRadius.full),
                            border: Border.all(
                              color: AppHelpers.statusColor(s),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            s,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isActive
                                  ? Colors.white
                                  : AppHelpers.statusColor(s),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ]),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
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
          crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textMedium)),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark)),
        ],
      ),
    );
  }

  Widget _infoRowWidget(String label, Widget widget) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textMedium)),
          widget,
        ],
      ),
    );
  }

  Widget _divider() =>
      const Divider(height: 1, color: AppColors.divider);
}
