import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/installation_screen.dart';
import 'screens/api_screen.dart';
import 'screens/prompts_screen.dart';
import 'screens/features_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/playground_screen.dart';
import 'screens/splash_screen.dart';

class AppThemes {
  static ThemeData get darkBlue => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1565C0),
          secondary: Color(0xFF64B5F6),
          surface: Color(0xFF020A18),
          onPrimary: Colors.white,
          onSurface: Color(0xFFBBDEFB),
        ),
        scaffoldBackgroundColor: const Color(0xFF030D1F),
        drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFF061228)),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF091830),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(color: Color(0xFF091830), elevation: 2),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.all(const Color(0xFF64B5F6)),
          trackColor: WidgetStateProperty.all(const Color(0xFF1565C0)),
        ),
      );

  static ThemeData get redBlue => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFC62828),
          secondary: Color(0xFF64B5F6),
          surface: Color(0xFF0A0205),
          onPrimary: Colors.white,
          onSurface: Color(0xFFFFCDD2),
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0408),
        drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFF1A0608)),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF200A0E),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(color: Color(0xFF200A0E), elevation: 2),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.all(const Color(0xFFEF5350)),
          trackColor: WidgetStateProperty.all(const Color(0xFFC62828)),
        ),
      );
}

class ThemeConfig {
  final Color primary;
  final Color accent;
  final Color drawerBg;
  final Color divider;
  final Color selectedTile;
  final Color indicator;
  final Color footerText;
  final Color titleColor;
  final List<Color> headerGradient;
  final List<NavItem> navItems;

  const ThemeConfig({
    required this.primary,
    required this.accent,
    required this.drawerBg,
    required this.divider,
    required this.selectedTile,
    required this.indicator,
    required this.footerText,
    required this.titleColor,
    required this.headerGradient,
    required this.navItems,
  });

  static const darkBlue = ThemeConfig(
    primary: Color(0xFF1565C0),
    accent: Color(0xFF64B5F6),
    drawerBg: Color(0xFF061228),
    divider: Color(0xFF0D2A5A),
    selectedTile: Color(0xFF1565C0),
    indicator: Color(0xFF64B5F6),
    footerText: Color(0xFF1976D2),
    titleColor: Colors.white,
    headerGradient: [Color(0xFF020810), Color(0xFF0A2464), Color(0xFF1565C0)],
    navItems: [
      NavItem(icon: Icons.home_outlined,         label: 'Accueil',         color: Color(0xFF64B5F6)),
      NavItem(icon: Icons.download_outlined,     label: 'Installation',    color: Color(0xFF1976D2)),
      NavItem(icon: Icons.code_outlined,         label: 'API & Code',      color: Color(0xFF64B5F6)),
      NavItem(icon: Icons.auto_awesome_outlined, label: 'Prompts',         color: Color(0xFF1976D2)),
      NavItem(icon: Icons.star_outline,          label: 'Fonctionnalités', color: Color(0xFF64B5F6)),
      NavItem(icon: Icons.chat_bubble_outline,   label: 'Chat DeepSeek',   color: Color(0xFF1976D2)),
      NavItem(icon: Icons.science_outlined,      label: 'Playground',      color: Color(0xFF64B5F6)),
    ],
  );

  static const redBlue = ThemeConfig(
    primary: Color(0xFFC62828),
    accent: Color(0xFF64B5F6),
    drawerBg: Color(0xFF1A0608),
    divider: Color(0xFF5A1A1A),
    selectedTile: Color(0xFFC62828),
    indicator: Color(0xFF64B5F6),
    footerText: Color(0xFFD32F2F),
    titleColor: Colors.white,
    headerGradient: [Color(0xFF100005), Color(0xFF6A0010), Color(0xFFC62828)],
    navItems: [
      NavItem(icon: Icons.home_outlined,         label: 'Accueil',         color: Color(0xFF64B5F6)),
      NavItem(icon: Icons.download_outlined,     label: 'Installation',    color: Color(0xFFEF5350)),
      NavItem(icon: Icons.code_outlined,         label: 'API & Code',      color: Color(0xFF64B5F6)),
      NavItem(icon: Icons.auto_awesome_outlined, label: 'Prompts',         color: Color(0xFFEF5350)),
      NavItem(icon: Icons.star_outline,          label: 'Fonctionnalités', color: Color(0xFF64B5F6)),
      NavItem(icon: Icons.chat_bubble_outline,   label: 'Chat DeepSeek',   color: Color(0xFFEF5350)),
      NavItem(icon: Icons.science_outlined,      label: 'Playground',      color: Color(0xFF64B5F6)),
    ],
  );
}

void main() {
  runApp(const DeepSeekGuideApp());
}

class DeepSeekGuideApp extends StatelessWidget {
  const DeepSeekGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, theme, _) {
        return MaterialApp(
          title: 'DeepSeek Guide',
          debugShowCheckedModeBanner: false,
          theme: theme == AppTheme.darkBlue ? AppThemes.darkBlue : AppThemes.redBlue,
          home: const SplashScreen(),
        );
      },
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});
  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  static const _screens = [
    HomeScreen(),
    InstallationScreen(),
    ApiScreen(),
    PromptsScreen(),
    FeaturesScreen(),
    ChatScreen(),
    PlaygroundScreen(),
  ];

  static const _titles = [
    'Accueil',
    'Installation',
    'API & Code',
    'Prompts',
    'Fonctionnalités',
    'Chat DeepSeek',
    'Playground',
  ];

  ThemeConfig get _cfg =>
      themeNotifier.value == AppTheme.darkBlue ? ThemeConfig.darkBlue : ThemeConfig.redBlue;

  @override
  void initState() {
    super.initState();
    deepseekNavIndex.addListener(_onNavChange);
  }

  @override
  void dispose() {
    deepseekNavIndex.removeListener(_onNavChange);
    super.dispose();
  }

  void _onNavChange() {
    if (deepseekNavIndex.value != _currentIndex) {
      setState(() => _currentIndex = deepseekNavIndex.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, _, child) => Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            _titles[_currentIndex],
            style: TextStyle(fontWeight: FontWeight.bold, color: _cfg.titleColor),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _cfg.headerGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Switch(
                value: themeNotifier.value == AppTheme.redBlue,
                onChanged: (v) => themeNotifier.value = v ? AppTheme.redBlue : AppTheme.darkBlue,
                activeThumbColor: const Color(0xFFEF5350),
                activeTrackColor: const Color(0xFFC62828),
                inactiveThumbColor: const Color(0xFF64B5F6),
                inactiveTrackColor: const Color(0xFF1565C0),
              ),
            ),
          ],
        ),
        drawer: _buildDrawer(context),
        body: _screens[_currentIndex],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final cfg = _cfg;
    return Drawer(
      backgroundColor: cfg.drawerBg,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cfg.headerGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.psychology_outlined, color: Colors.white, size: 28),
                    ),
                    const SizedBox(height: 12),
                    const Text('DeepSeek Guide',
                        style: TextStyle(
                            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('Guide complet DeepSeek AI',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: cfg.navItems.length,
              itemBuilder: (context, index) {
                final item = cfg.navItems[index];
                final isSelected = _currentIndex == index;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? cfg.selectedTile.withValues(alpha: 0.3)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: Icon(item.icon,
                        color: isSelected ? item.color : item.color.withValues(alpha: 0.5)),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        color: isSelected
                            ? item.color
                            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? Container(
                            width: 4,
                            height: 24,
                            decoration: BoxDecoration(
                              color: cfg.indicator,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          )
                        : null,
                    onTap: () {
                      setState(() => _currentIndex = index);
                      deepseekNavIndex.value = index;
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),
          Divider(color: cfg.divider, height: 1),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('v2.0 • DeepSeek AI Guide',
                  style: TextStyle(color: cfg.footerText, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;
  final Color color;
  const NavItem({required this.icon, required this.label, required this.color});
}
