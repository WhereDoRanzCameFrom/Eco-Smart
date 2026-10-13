// lib/screens/monitoring/waste_form_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/waste_service.dart';
import '../../models/waste_record_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_helpers.dart';

class WasteFormScreen extends StatefulWidget {
  final WasteRecordModel? existing;
  const WasteFormScreen({super.key, this.existing});

  @override
  State<WasteFormScreen> createState() => _WasteFormScreenState();
}

class _WasteFormScreenState extends State<WasteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _wasteService = WasteService();

  DateTime _tanggal = DateTime.now();
  String _status = AppConstants.statusTerkumpul;
  bool _isLoading = false;

  // Semua field input manual pakai controller
  final _lokasiCtrl = TextEditingController();
  final _jenisSampahCtrl = TextEditingController();
  final _beratCtrl = TextEditingController();

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final e = widget.existing!;
      _tanggal = e.tanggal;
      _lokasiCtrl.text = e.lokasi;
      _jenisSampahCtrl.text = e.jenisSampah;
      _beratCtrl.text = e.beratKg % 1 == 0
          ? e.beratKg.toInt().toString()
          : e.beratKg.toString();
      _status = e.status;
    }
  }

  @override
  void dispose() {
    _lokasiCtrl.dispose();
    _jenisSampahCtrl.dispose();
    _beratCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
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

    final berat = double.tryParse(_beratCtrl.text.trim()) ?? 0;
    bool success;

    if (_isEdit) {
      final updated = widget.existing!.copyWith(
        tanggal: _tanggal,
        lokasi: _lokasiCtrl.text.trim(),
        jenisSampah: _jenisSampahCtrl.text.trim(),
        beratKg: berat,
        status: _status,
      );
      success = await _wasteService.updateWasteRecord(updated);
    } else {
      final newRecord = WasteRecordModel(
        id: 'w${DateTime.now().millisecondsSinceEpoch}',
        tanggal: _tanggal,
        lokasi: _lokasiCtrl.text.trim(),
        jenisSampah: _jenisSampahCtrl.text.trim(),
        beratKg: berat,
        status: _status,
      );
      success = await _wasteService.addWasteRecord(newRecord);
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      AppHelpers.showSnackBar(
          context,
          _isEdit ? 'Data berhasil diperbarui' : 'Data berhasil ditambahkan');
      Navigator.pop(context, true);
    } else {
      AppHelpers.showSnackBar(context, 'Gagal menyimpan data', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7FF),
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Data Sampah' : 'Tambah Data',
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
                  hint: 'Contoh: Pantai Desa, Muara Sungai...',
                  icon: Icons.location_on_outlined,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Lokasi wajib diisi'
                      : null,
                ),
                const SizedBox(height: 20),

                // Jenis Sampah - input manual
                _label('Jenis Sampah'),
                const SizedBox(height: 8),
                _textField(
                  controller: _jenisSampahCtrl,
                  hint: 'Contoh: Botol Plastik, Kantong Plastik...',
                  icon: Icons.delete_outline_rounded,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Jenis sampah wajib diisi'
                      : null,
                ),
                const SizedBox(height: 20),

                // Berat
                _label('Berat (Kg)'),
                const SizedBox(height: 8),
                _textField(
                  controller: _beratCtrl,
                  hint: 'Contoh: 15',
                  icon: Icons.scale_outlined,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Berat wajib diisi';
                    }
                    if (double.tryParse(v.trim()) == null) {
                      return 'Masukkan angka yang valid';
                    }
                    if (double.parse(v.trim()) <= 0) {
                      return 'Berat harus lebih dari 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Status - tetap dropdown karena nilai fixed
                _label('Status'),
                const SizedBox(height: 8),
                _statusSelector(),
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

  // Status pakai selector pill bukan dropdown — lebih visual
  Widget _statusSelector() {
    return Row(
      children: AppConstants.statusList.map((s) {
        final isActive = _status == s;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _status = s),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: EdgeInsets.only(
                right: s != AppConstants.statusList.last ? 8 : 0,
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isActive
                    ? AppHelpers.statusColor(s)
                    : AppHelpers.statusBgColor(s),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: AppHelpers.statusColor(s),
                  width: 1.5,
                ),
              ),
              child: Text(
                s,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : AppHelpers.statusColor(s),
                ),
              ),
            ),
          ),
        );
      }).toList(),
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

  Widget _label(String label) {
    return Text(label,
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
