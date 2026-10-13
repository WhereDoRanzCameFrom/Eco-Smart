// lib/screens/education/education_screen.dart
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  int _activeCategory = 0;

  static const List<String> _categories = [
    'Semua',
    'Bahaya',
    'Dampak',
    'Cara Memilah',
    'Tips',
  ];

  static const List<Map<String, dynamic>> _materiList = [
    {
      'judul': 'Bahaya Sampah Plastik Laut',
      'ringkasan':
          'Plastik yang tidak terurai mencemari laut dan mengancam ekosistem pesisir.',
      'konten': 'Sampah plastik laut adalah salah satu ancaman terbesar bagi ekosistem laut. '
          'Plastik yang tidak terurai selama ratusan tahun akan terpecah menjadi '
          'mikroplastik yang mencemari air laut dan rantai makanan.\n\n'
          'Di perairan budidaya rumput laut, sampah plastik dapat menyebabkan:\n'
          '• Kerusakan tali dan jaring budidaya\n'
          '• Penurunan kualitas air\n'
          '• Kematian biota laut\n'
          '• Penurunan hasil panen rumput laut\n\n'
          'Dengan mengendalikan sampah plastik, kita melindungi sumber daya laut '
          'dan mendukung kesejahteraan desa.',
      'warna': 0xFF1565C0,
      'bgWarna': 0xFFE3F2FD,
      'icon': Icons.warning_amber_rounded,
      'tag': 'Bahaya',
      'durasi': '3 menit baca',
    },
    {
      'judul': 'Dampak terhadap Rumput Laut',
      'ringkasan':
          'Pencemaran plastik menurunkan kualitas perairan dan hasil panen rumput laut.',
      'konten':
          'Rumput laut adalah komoditas utama masyarakat pesisir Desa Tanjung Harapan. '
              'Kualitas perairan sangat menentukan keberhasilan budidaya.\n\n'
              'Dampak sampah plastik pada budidaya rumput laut:\n'
              '• Plastik menghalangi sinar matahari masuk ke air\n'
              '• Menghambat proses fotosintesis rumput laut\n'
              '• Merusak thallus (batang) rumput laut\n'
              '• Meningkatkan pertumbuhan bakteri patogen\n\n'
              'Dengan menjaga kebersihan perairan, hasil budidaya rumput laut '
              'dapat meningkat dan kualitasnya terjaga.',
      'warna': 0xFF00838F,
      'bgWarna': 0xFFE0F7FA,
      'icon': Icons.eco_rounded,
      'tag': 'Dampak',
      'durasi': '3 menit baca',
    },
    {
      'judul': 'Cara Memilah Sampah Plastik',
      'ringkasan':
          'Memilah plastik dari sumbernya memudahkan pengelolaan dan daur ulang.',
      'konten':
          'Pemilahan sampah plastik dimulai dari rumah. Ini langkah-langkah mudahnya:\n\n'
              '1. Siapkan 2 tempat sampah: satu untuk plastik, satu untuk non-plastik\n'
              '2. Cuci plastik bekas pakai sebelum dibuang\n'
              '3. Pisahkan jenis plastik:\n'
              '   • Botol plastik (kode 1 & 2)\n'
              '   • Kantong kresek\n'
              '   • Wadah plastik\n'
              '   • Styrofoam\n'
              '4. Setorkan ke petugas pengumpulan\n\n'
              'Plastik yang terpilah dengan baik lebih mudah didaur ulang dan '
              'memiliki nilai ekonomi yang lebih tinggi.',
      'warna': 0xFF2E7D32,
      'bgWarna': 0xFFE8F5E9,
      'icon': Icons.recycling_rounded,
      'tag': 'Cara Memilah',
      'durasi': '4 menit baca',
    },
    {
      'judul': 'Tips Menjaga Lingkungan Pesisir',
      'ringkasan':
          'Aksi nyata setiap hari untuk menjaga kebersihan perairan desa.',
      'konten':
          'Setiap orang bisa berkontribusi menjaga lingkungan pesisir.\n\n'
              '🌊 Di Pantai & Pesisir:\n'
              '• Tidak membuang sampah ke laut atau sungai\n'
              '• Ikut kegiatan bersih pantai secara rutin\n'
              '• Laporkan tumpukan sampah kepada petugas\n\n'
              '🏠 Di Rumah:\n'
              '• Kurangi penggunaan plastik sekali pakai\n'
              '• Gunakan tas belanja kain\n'
              '• Pisahkan sampah plastik setiap hari\n\n'
              '🤝 Di Komunitas:\n'
              '• Ajak tetangga untuk peduli lingkungan\n'
              '• Ikut serta dalam kegiatan edukasi desa\n'
              '• Bersama menjaga kebersihan pesisir',
      'warna': 0xFF0277BD,
      'bgWarna': 0xFFE1F5FE,
      'icon': Icons.water_rounded,
      'tag': 'Tips',
      'durasi': '2 menit baca',
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_activeCategory == 0) return _materiList;
    final tag = _categories[_activeCategory];
    return _materiList.where((m) => m['tag'] == tag).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7FF),
      body: CustomScrollView(
        slivers: [
          _buildHeader(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCategoryChips(),
                const SizedBox(height: 4),
                _buildFeaturedCard(),
                _buildQuickStats(),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
                  child: Text(
                    'Semua Materi',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark),
                  ),
                ),
                ..._filtered.map((m) => _buildMateriCard(context, m)),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── SLIVER HEADER dengan wave ────────────────────────────
  Widget _buildHeader() {
    return SliverAppBar(
      expandedHeight: 150,
      floating: false,
      pinned: true,
      snap: false,
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.primary,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Stack(
          children: [
            // Gradient background
            Container(
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
            // Wave bottom
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomPaint(
                size: Size(double.infinity, 36),
                painter: _WavePainter(color: Color(0xFFF0F7FF)),
              ),
            ),
            // Konten
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Edukasi Lingkungan',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Pelajari cara menjaga perairan rumput laut',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.82),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Collapsed title
        title: const Text(
          'Edukasi',
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        titlePadding: const EdgeInsets.only(left: 20, bottom: 14),
      ),
    );
  }

  // ── CATEGORY CHIPS ────────────────────────────────────────
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: _categories.length,
        itemBuilder: (_, i) {
          final isActive = _activeCategory == i;
          return GestureDetector(
            onTap: () => setState(() => _activeCategory = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 6,
                          offset: const Offset(0, 1),
                        )
                      ],
              ),
              child: Text(
                _categories[i],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : AppColors.textMedium,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── FEATURED CARD (card besar hero di atas) ───────────────
  Widget _buildFeaturedCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: GestureDetector(
        onTap: () => _showDetail(
            // ignore: use_build_context_synchronously
            context,
            _materiList[0]),
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0D47A1), Color(0xFF1976D2), Color(0xFF42A5F5)],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Dekorasi lingkaran blur
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                right: 30,
                bottom: -30,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Konten
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rounded,
                              size: 12, color: Colors.amber),
                          SizedBox(width: 4),
                          Text('Materi Utama',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Bahaya Sampah\nPlastik Laut',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded,
                            size: 12, color: Colors.white70),
                        const SizedBox(width: 4),
                        const Text('3 menit baca',
                            style:
                                TextStyle(fontSize: 11, color: Colors.white70)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Baca →',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── QUICK STATS ───────────────────────────────────────────
  Widget _buildQuickStats() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          _quickStat('4', 'Materi', Icons.menu_book_rounded,
              AppColors.primaryLight, const Color(0xFFDCEEFD)),
          const SizedBox(width: 10),
          _quickStat('12 mnt', 'Total Baca', Icons.access_time_rounded,
              AppColors.accent, const Color(0xFFE0F7FA)),
          const SizedBox(width: 10),
          _quickStat('Gratis', 'Akses', Icons.lock_open_rounded,
              AppColors.terkendali, const Color(0xFFE8F5E9)),
        ],
      ),
    );
  }

  Widget _quickStat(
      String val, String label, IconData icon, Color color, Color bg) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(val,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: color)),
                  Text(label,
                      style: const TextStyle(
                          fontSize: 9, color: AppColors.textMedium)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── MATERI CARD (list) ────────────────────────────────────
  Widget _buildMateriCard(BuildContext context, Map<String, dynamic> m) {
    final color = Color(m['warna'] as int);
    final bgColor = Color(m['bgWarna'] as int);

    return GestureDetector(
      onTap: () => _showDetail(context, m),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            // Panel kiri - icon
            Container(
              width: 72,
              height: 88,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
              child: Icon(m['icon'] as IconData, color: color, size: 30),
            ),
            // Konten
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(m['tag'] as String,
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: color)),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(Icons.access_time_rounded,
                                size: 10, color: AppColors.textLight),
                            const SizedBox(width: 2),
                            Text(m['durasi'] as String,
                                style: const TextStyle(
                                    fontSize: 9, color: AppColors.textLight)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(m['judul'] as String,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark)),
                    const SizedBox(height: 4),
                    Text(m['ringkasan'] as String,
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMedium,
                            height: 1.4),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.chevron_right_rounded,
                  color: AppColors.textLight, size: 18),
            ),
          ],
        ),
      ),
    );
  }

  // ── DETAIL BOTTOM SHEET ───────────────────────────────────
  void _showDetail(BuildContext context, Map<String, dynamic> m) {
    final color = Color(m['warna'] as int);
    final bgColor = Color(m['bgWarna'] as int);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.78,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        builder: (_, ctrl) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2)),
              ),
              // Header detail
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: bgColor, borderRadius: BorderRadius.circular(14)),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:
                            Icon(m['icon'] as IconData, color: color, size: 26),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(m['tag'] as String,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: color)),
                            ),
                            const SizedBox(height: 5),
                            Text(m['judul'] as String,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: color)),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(Icons.access_time_rounded,
                                    size: 11,
                                    color: color.withValues(alpha: 0.6)),
                                const SizedBox(width: 3),
                                Text(m['durasi'] as String,
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: color.withValues(alpha: 0.7))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Konten scroll
              Expanded(
                child: SingleChildScrollView(
                  controller: ctrl,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                  child: Text(
                    m['konten'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textMedium,
                      height: 1.75,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── WAVE PAINTER ────────────────────────────────────────────
class _WavePainter extends CustomPainter {
  final Color color;
  const _WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height)
      ..cubicTo(size.width * 0.15, size.height * 0.2, size.width * 0.35,
          size.height * 0.05, size.width * 0.5, size.height * 0.4)
      ..cubicTo(size.width * 0.65, size.height * 0.75, size.width * 0.85,
          size.height * 0.5, size.width, size.height * 0.2)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant _WavePainter old) => old.color != color;
}
