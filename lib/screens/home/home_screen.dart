// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dashboard/dashboard_screen.dart';
import '../monitoring/monitoring_screen.dart';
import '../activities/activities_screen.dart';
import '../education/education_screen.dart';
import '../reports/reports_screen.dart';
import '../../utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _userRole = '';
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _userRole = prefs.getString('user_role') ?? 'viewer';
      _userName = prefs.getString('user_name') ?? '';
    });
  }

  List<Widget> get _screens => [
        DashboardScreen(userRole: _userRole, userName: _userName),
        MonitoringScreen(userRole: _userRole),
        ActivitiesScreen(userRole: _userRole),
        const EducationScreen(),
        const ReportsScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens.isNotEmpty && _userRole.isNotEmpty
          ? _screens[_currentIndex]
          : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(0, Icons.dashboard_rounded, Icons.dashboard_outlined,
                  'Beranda'),
              _navItem(1, Icons.water_drop_rounded, Icons.water_drop_outlined,
                  'Monitoring'),
              _navItem(2, Icons.event_note_rounded, Icons.event_note_outlined,
                  'Kegiatan'),
              _navItem(3, Icons.menu_book_rounded, Icons.menu_book_outlined,
                  'Edukasi'),
              _navItem(4, Icons.bar_chart_rounded, Icons.bar_chart_outlined,
                  'Laporan'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
      int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primarySurface : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              size: 22,
              color: isActive ? AppColors.primary : AppColors.textLight,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColors.primary : AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
