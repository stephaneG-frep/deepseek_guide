import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_theme.dart';

void _sendToChat(BuildContext context, String promptText) {
  pendingPromptNotifier.value = promptText;
  deepseekNavIndex.value = 5;
}

class PromptsScreen extends StatefulWidget {
  const PromptsScreen({super.key});
  @override
  State<PromptsScreen> createState() => _PromptsScreenState();
}

class _PromptsScreenState extends State<PromptsScreen> {
  String? _selectedCategory;

  static final _categories = [
    _PromptCategory(
      name: 'Code',
      icon: Icons.code,
      prompts: [
        _Prompt('Revue de code',
            'Analyse ce code et identifie les bugs, problèmes de performance et améliorations possibles :\n\n[COLLER LE CODE ICI]'),
        _Prompt('Refactoring',
            'Refactorise ce code pour le rendre plus lisible, maintenable et performant :\n\n[COLLER LE CODE ICI]'),
        _Prompt('Générer des tests',
            'Génère des tests unitaires complets pour cette fonction avec des cas limites :\n\n[COLLER LE CODE ICI]'),
        _Prompt('Documentation',
            'Génère une documentation complète avec exemples d\'utilisation pour ce code :\n\n[COLLER LE CODE ICI]'),
      ],
    ),
    _PromptCategory(
      name: 'Écriture',
      icon: Icons.edit_outlined,
      prompts: [
        _Prompt('Amélioration de texte',
            'Améliore ce texte en termes de clarté, style et grammaire :\n\n[TEXTE ICI]'),
        _Prompt('Résumé', 'Résume ce texte en 3-5 points clés :\n\n[TEXTE ICI]'),
        _Prompt('Email professionnel',
            'Rédige un email professionnel pour la situation suivante : [DÉCRIRE LA SITUATION]'),
      ],
    ),
    _PromptCategory(
      name: 'Analyse',
      icon: Icons.analytics_outlined,
      prompts: [
        _Prompt('Analyse critique',
            'Effectue une analyse critique de ce contenu :\n\n[CONTENU ICI]'),
        _Prompt('Comparaison',
            'Compare et contraste ces deux éléments :\nÉlément 1 : [X]\nÉlément 2 : [Y]'),
        _Prompt('Débogage',
            'Analyse cette erreur et propose des solutions :\n\nErreur : [MESSAGE]\nContexte : [CONTEXTE]'),
      ],
    ),
    _PromptCategory(
      name: 'Créativité',
      icon: Icons.lightbulb_outline,
      prompts: [
        _Prompt('Brainstorming', 'Génère 10 idées créatives pour : [SUJET]'),
        _Prompt('Storytelling',
            'Écris une courte histoire avec :\nPersonnage : [X]\nSetting : [Y]\nProblème : [Z]'),
        _Prompt('Nommage', 'Propose 10 noms créatifs pour : [PROJET]'),
      ],
    ),
    _PromptCategory(
      name: 'Productivité',
      icon: Icons.rocket_launch_outlined,
      prompts: [
        _Prompt('Plan d\'action', 'Crée un plan d\'action détaillé pour : [OBJECTIF]'),
        _Prompt('Apprentissage',
            'Crée un plan d\'apprentissage 30 jours pour maîtriser : [SUJET]'),
        _Prompt('Prompt système',
            'Crée un prompt système pour un assistant spécialisé dans : [DOMAINE]'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, _, child) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final filtered = _selectedCategory == null
        ? _categories
        : _categories.where((c) => c.name == _selectedCategory).toList();

    return Column(
      children: [
        SizedBox(
          height: 56,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            itemCount: _categories.length + 1,
            separatorBuilder: (_, i) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == 0) {
                return FilterChip(
                  label: const Text('Tous'),
                  selected: _selectedCategory == null,
                  onSelected: (_) => setState(() => _selectedCategory = null),
                  selectedColor: context.accentMid.withValues(alpha: 0.3),
                  checkmarkColor: context.accentLight,
                  labelStyle: TextStyle(color: context.accentLight),
                  side: BorderSide(color: context.accentMid.withValues(alpha: 0.5)),
                );
              }
              final cat = _categories[index - 1];
              final color = context.palette[index - 1];
              return FilterChip(
                label: Text(cat.name),
                selected: _selectedCategory == cat.name,
                onSelected: (_) => setState(() =>
                    _selectedCategory = _selectedCategory == cat.name ? null : cat.name),
                selectedColor: color.withValues(alpha: 0.2),
                checkmarkColor: color,
                labelStyle: TextStyle(color: color),
                side: BorderSide(color: color.withValues(alpha: 0.4)),
              );
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: filtered.length + 1,
            itemBuilder: (context, i) {
              if (i == 0) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: _PromptsInfoCard(),
                );
              }
              final cat = filtered[i - 1];
              final colorIndex = _categories.indexOf(cat);
              final color = context.palette[colorIndex % context.palette.length];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Row(
                      children: [
                        Icon(cat.icon, color: color, size: 20),
                        const SizedBox(width: 8),
                        Text(cat.name,
                            style: TextStyle(
                                color: color, fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                  ...cat.prompts.map((p) => _PromptCard(prompt: p, color: color)),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PromptCard extends StatefulWidget {
  final _Prompt prompt;
  final Color color;
  const _PromptCard({required this.prompt, required this.color});
  @override
  State<_PromptCard> createState() => _PromptCardState();
}

class _PromptCardState extends State<_PromptCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: widget.color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(widget.prompt.title,
                        style: TextStyle(
                            color: widget.color, fontWeight: FontWeight.w600)),
                  ),
                  Icon(_expanded ? Icons.expand_less : Icons.expand_more,
                      color: widget.color, size: 20),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: widget.color.withValues(alpha: 0.2)),
                  Text(widget.prompt.text,
                      style: TextStyle(
                          color: context.onSurface.withValues(alpha: 0.8),
                          fontSize: 13,
                          height: 1.5)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: widget.prompt.text));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('Prompt copié !'),
                            backgroundColor: widget.color,
                            duration: const Duration(seconds: 2),
                          ));
                        },
                        icon: Icon(Icons.copy, size: 14, color: widget.color),
                        label: Text('Copier',
                            style: TextStyle(color: widget.color, fontSize: 12)),
                      ),
                      TextButton.icon(
                        onPressed: () => _sendToChat(context, widget.prompt.text),
                        icon: Icon(Icons.chat_bubble_outline, size: 14, color: widget.color),
                        label: Text('Envoyer au Chat',
                            style: TextStyle(color: widget.color, fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PromptCategory {
  final String name;
  final IconData icon;
  final List<_Prompt> prompts;
  const _PromptCategory({required this.name, required this.icon, required this.prompts});
}

class _Prompt {
  final String title;
  final String text;
  const _Prompt(this.title, this.text);
}

class _PromptsInfoCard extends StatelessWidget {
  const _PromptsInfoCard();

  @override
  Widget build(BuildContext context) {
    final tips = [
      (Icons.center_focus_strong, 'Soyez précis et contextuel',
          'Décrivez votre rôle, le contexte et le format souhaité. Ex : "En tant que dev Flutter, explique X pour un débutant en 5 points."'),
      (Icons.format_list_bulleted, 'Utilisez des placeholders',
          'Les prompts avec [TEXTE ICI] sont des templates réutilisables. Remplacez les crochets par votre contenu avant d\'envoyer.'),
      (Icons.send, 'Envoyez directement au Chat',
          'Le bouton "Envoyer au Chat" transfère le prompt dans l\'écran Chat DeepSeek pour tester immédiatement avec l\'API.'),
      (Icons.repeat, 'Itérez et affinez',
          'Un bon prompt est rarement parfait du premier coup. Testez, observez la réponse, ajustez le niveau de détail ou le ton.'),
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.tipBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.tipBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: context.accentLight.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.auto_awesome, color: context.accentLight, size: 18),
              ),
              const SizedBox(width: 10),
              Text('Comment faire un bon prompt ?',
                  style: TextStyle(
                      color: context.accentLight,
                      fontWeight: FontWeight.w700,
                      fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          ...tips.map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(tip.$1, color: context.accentMid, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tip.$2,
                              style: TextStyle(
                                  color: context.onSurface,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12)),
                          const SizedBox(height: 2),
                          Text(tip.$3,
                              style: TextStyle(
                                  color: context.onSurface.withValues(alpha: 0.65),
                                  fontSize: 11,
                                  height: 1.4)),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
