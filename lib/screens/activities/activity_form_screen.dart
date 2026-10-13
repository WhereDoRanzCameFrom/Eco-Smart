// lib/screens/activities/activity_form_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/activity_service.dart';
import '../../models/activity_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_helpers.dart';

class ActivityFormScreen extends StatefulWidget {
  final ActivityModel? existing;
  const ActivityFormScreen({super.key, this.existing});

  @override
  State<ActivityFormScreen> createState() => _ActivityFormScreenState();
}

class _ActivityFormScreenState extends State<ActivityFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _activityService = ActivityService();

  DateTime _tanggal = DateTime.now();
  bool _isLoading = false;

  // Semua field input manual
  final _lokasiCtrl = TextEditingController();
  final _jenisKegiatanCtrl = TextEditingController();
  final _pesertaCtrl = TextEditingController();

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final e = widget.existing!;
      _tanggal = e.tanggal;
      _lokasiCtrl.text = e.lokasi;
      _jenisKegiatanCtrl.text = e.jenisKegiatan;
      _pesertaCtrl.text = e.peserta.toString();
    }
  }

  @override
  void dispose() {
    _lokasiCtrl.dispose();
    _jenisKegiatanCtrl.dispose();
    _pesertaCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2024),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _tanggal = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final peserta = int.tryParse(_pesertaCtrl.text.trim()) ?? 0;
    bool success;

    if (_isEdit) {
      final updated = widget.existing!.copyWith(
        tanggal: _tanggal,
        lokasi: _lokasiCtrl.text.trim(),
        jenisKegiatan: _jenisKegiatanCtrl.text.trim(),
        peserta: peserta,
      );
      success = await _activityService.updateActivity(updated);
    } else {
      final newActivity = ActivityModel(
        id: 'a${DateTime.now().millisecondsSinceEpoch}',
        tanggal: _tanggal,
        lokasi: _lokasiCtrl.text.trim(),
        jenisKegiatan: _jenisKegiatanCtrl.text.trim(),
        peserta: peserta,
      );
      success = await _activityService.addActivity(newActivity);
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      AppHelpers.showSnackBar(
          context,
          _isEdit
              ? 'Kegiatan berhasil diperbarui'
              : 'Kegiatan berhasil ditambahkan');
      Navigator.pop(context, true);
    } else {
      AppHelpers.showSnackBar(context, 'Gagal menyimpan kegiatan',
          isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7FF),
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Kegiatan' : 'Tambah Kegiatan',
            style: const TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _card(children: [
                // Tanggal
                _label('Tanggal'),
                const SizedBox(height: 8),
                _datePicker(),
                const SizedBox(height: 20),

                // Lokasi - input manual
                _label('Lokasi'),
                const SizedBox(height: 8),
                _textField(
                  controller: _lokasiCtrl,
                  hint: 'Contoh: Pantai Desa, Balai Desa...',
                  icon: Icons.location_on_outlined,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Lokasi wajib diisi'
                      : null,
                ),
                const SizedBox(height: 20),

                // Jenis Kegiatan - input manual
                _label('Jenis Kegiatan'),
                const SizedBox(height: 8),
                _textField(
                  controller: _jenisKegiatanCtrl,
                  hint: 'Contoh: Bersih Pantai, Edukasi Warga...',
                  icon: Icons.event_note_outlined,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Jenis kegiatan wajib diisi'
                      : null,
                ),
                const SizedBox(height: 20),

                // Jumlah Peserta
                _label('Jumlah Peserta'),
                const SizedBox(height: 8),
                _textField(
                  controller: _pesertaCtrl,
                  hint: 'Contoh: 35',
                  icon: Icons.people_outline_rounded,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Jumlah peserta wajib diisi';
                    }
                    if (int.tryParse(v.trim()) == null) {
                      return 'Masukkan angka yang valid';
                    }
                    if (int.parse(v.trim()) < 1) {
                      return 'Peserta minimal 1 orang';
                    }
                    return null;
                  },
                ),
              ]),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.5, color: Colors.white))
                      : Text(_isEdit ? 'Simpan Perubahan' : 'Simpan',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.07),
              blurRadius: 14,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _label(String t) {
    return Text(t,
        style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark));
  }

  Widget _datePicker() {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F7FF),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined,
                size: 18, color: AppColors.primaryLight),
            const SizedBox(width: 10),
            Text(
              DateFormat('dd MMMM yyyy', 'id_ID').format(_tanggal),
              style: const TextStyle(fontSize: 14, color: AppColors.textDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: TextCapitalization.words,
      style: const TextStyle(fontSize: 14, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 13),
        prefixIcon: Icon(icon, color: AppColors.primaryLight, size: 20),
        filled: true,
        fillColor: const Color(0xFFF0F7FF),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(color: AppColors.divider)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(color: AppColors.divider)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide:
                const BorderSide(color: AppColors.primaryLight, width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(color: AppColors.error)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(color: AppColors.error, width: 1.5)),
      ),
      validator: validator,
    );
  }
}
