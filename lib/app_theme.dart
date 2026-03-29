import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final themeNotifier = ValueNotifier<AppTheme>(AppTheme.darkBlue);
final deepseekNavIndex = ValueNotifier<int>(0);
final pendingPromptNotifier = ValueNotifier<String?>(null);
enum AppTheme { darkBlue, redBlue }

extension AppThemeExt on BuildContext {
  bool get isRed => themeNotifier.value == AppTheme.redBlue;

  Color get primary => isRed ? const Color(0xFFC62828) : const Color(0xFF1565C0);
  Color get secondary => isRed ? const Color(0xFFD32F2F) : const Color(0xFF1976D2);

  Color get cardBg => isRed ? const Color(0xFF200A0E) : const Color(0xFF091830);
  Color get codeBg => isRed ? const Color(0xFF15030A) : const Color(0xFF010610);
  Color get codeHeader => isRed ? const Color(0xFF200A0E) : const Color(0xFF091830);
  Color get accentLight => isRed ? const Color(0xFF64B5F6) : const Color(0xFF64B5F6);
  Color get accentMid => isRed ? const Color(0xFFD32F2F) : const Color(0xFF1976D2);
  Color get surfaceBg => isRed ? const Color(0xFF0A0205) : const Color(0xFF020A18);
  Color get codeText => isRed ? const Color(0xFFEF9A9A) : const Color(0xFF90CAF9);
  Color get codeBorder => isRed ? const Color(0xFF5A1A1A) : const Color(0xFF0D2A5A);
  Color get tipBg => isRed ? const Color(0xFF180508) : const Color(0xFF071528);
  Color get tipBorder => isRed ? const Color(0xFFC62828) : const Color(0xFF1565C0);
  Color get tipText => isRed ? const Color(0xFFFF8A80) : const Color(0xFF82B1FF);
  Color get drawerDivider => isRed ? const Color(0xFF5A1A1A) : const Color(0xFF0D2A5A);
  Color get onSurface => isRed ? const Color(0xFFFFCDD2) : const Color(0xFFBBDEFB);

  List<Color> get heroGradient => isRed
      ? [const Color(0xFF100005), const Color(0xFF6A0010), const Color(0xFFC62828)]
      : [const Color(0xFF020810), const Color(0xFF0A2464), const Color(0xFF1565C0)];

  List<Color> get palette => isRed
      ? [
          const Color(0xFFC62828),
          const Color(0xFFD32F2F),
          const Color(0xFFB71C1C),
          const Color(0xFFE53935),
          const Color(0xFFEF5350),
          const Color(0xFFC62828),
        ]
      : [
          const Color(0xFF1565C0),
          const Color(0xFF1976D2),
          const Color(0xFF0D47A1),
          const Color(0xFF1E88E5),
          const Color(0xFF0288D1),
          const Color(0xFF1565C0),
        ];
}

Widget sectionTitle(String text, BuildContext context) => Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: context.accentLight,
        ),
      ),
    );

class CodeBlock extends StatelessWidget {
  final String code;
  final String? title;
  const CodeBlock({super.key, required this.code, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: context.codeBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.codeBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: context.codeHeader,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title!,
                      style: TextStyle(
                          color: context.accentLight,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                  IconButton(
                    icon: Icon(Icons.copy, size: 16, color: context.accentLight),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: code));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Code copié !'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SelectableText(
              code,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: context.codeText,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
