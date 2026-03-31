import 'package:flutter/material.dart';
import '../app_theme.dart';

class AppsScreen extends StatelessWidget {
  const AppsScreen({super.key});

  static final _apps = [
    _App(
      icon: Icons.chat_bubble_rounded,
      title: 'DeepSeek Chat — Application officielle',
      category: 'Officiel DeepSeek',
      description:
          'L\'application mobile officielle de DeepSeek pour iOS et Android. '
          'Accès à DeepSeek-V3 et DeepSeek-R1, mode "Think" pour le raisonnement '
          'étape par étape, recherche web intégrée et analyse de fichiers.',
      tips: [
        'iOS : App Store → "DeepSeek" par DeepSeek',
        'Android : Play Store → "DeepSeek"',
        'Mode Think : active DeepSeek-R1 pour le raisonnement',
        'Recherche web en temps réel intégrée',
        'Gratuit et sans limite d\'utilisation (actuellement)',
      ],
    ),
    _App(
      icon: Icons.code_rounded,
      title: 'DeepSeek-Coder — Assistant code',
      category: 'Développement',
      description:
          'Modèle spécialisé pour la génération et l\'analyse de code. '
          'Disponible via l\'API DeepSeek ou en local via Ollama. '
          'Supporte plus de 80 langages de programmation.',
      tips: [
        'API : model="deepseek-coder" ou "deepseek-chat"',
        'Local : ollama run deepseek-coder',
        '80+ langages : Python, JS, Go, Rust, C++…',
        'Contexte 128K tokens pour les grands fichiers',
        'Complète, explique et débogue le code',
      ],
    ),
    _App(
      icon: Icons.terminal_rounded,
      title: 'Ollama — DeepSeek en local',
      category: 'Local / Open source',
      description:
          'Exécutez DeepSeek entièrement sur votre machine sans envoyer de données '
          'à un serveur externe. Ollama gère le téléchargement et l\'exécution '
          'des modèles DeepSeek localement.',
      tips: [
        'Installation : ollama.com → télécharger',
        'Lancer : ollama run deepseek-r1:7b',
        'Modèles : 1.5b, 7b, 8b, 14b, 32b, 70b',
        'API locale compatible OpenAI sur port 11434',
        'Fonctionne hors connexion, 100% privé',
      ],
    ),
    _App(
      icon: Icons.window_rounded,
      title: 'LM Studio — Interface locale',
      category: 'Local / Interface graphique',
      description:
          'Application desktop pour exécuter DeepSeek et d\'autres LLMs en local '
          'avec une interface graphique. Idéal pour les utilisateurs qui préfèrent '
          'éviter la ligne de commande.',
      tips: [
        'Téléchargement : lmstudio.ai',
        'Windows, macOS, Linux',
        'Téléchargement des modèles DeepSeek intégré',
        'Serveur API local compatible OpenAI',
        'Interface de chat incluse',
      ],
    ),
    _App(
      icon: Icons.edit_outlined,
      title: 'Cursor — Éditeur avec DeepSeek',
      category: 'Développement',
      description:
          'Fork de VS Code avec IA intégrée. Peut être configuré pour utiliser '
          'l\'API DeepSeek à la place d\'OpenAI, réduisant drastiquement '
          'le coût tout en maintenant des performances élevées.',
      tips: [
        'Téléchargement : cursor.sh',
        'Settings → Models → ajouter deepseek-chat',
        'Coût ~20x moins cher qu\'avec GPT-4o',
        'Compatible avec le contexte complet du projet',
        'Ctrl+K édition inline, Ctrl+L chat projet',
      ],
    ),
    _App(
      icon: Icons.extension_outlined,
      title: 'Continue.dev — VS Code + DeepSeek',
      category: 'Développement',
      description:
          'Extension VS Code et JetBrains open source pour l\'assistance au code IA. '
          'Se configure facilement avec l\'API DeepSeek pour un assistant '
          'de code puissant et économique.',
      tips: [
        'Extension VS Code : "Continue"',
        'config.json : provider "deepseek"',
        'Autocomplétion, chat, édition inline',
        'Open source : github.com/continuedev/continue',
        'Gratuit avec votre propre clé API DeepSeek',
      ],
    ),
    _App(
      icon: Icons.dns_outlined,
      title: 'Open WebUI — Interface self-hosted',
      category: 'Self-hosted',
      description:
          'Interface web open source style ChatGPT pour vos modèles locaux '
          'ou l\'API DeepSeek. S\'installe via Docker et offre un historique, '
          'des personas et une gestion multi-modèles.',
      tips: [
        'docker run -d -p 3000:8080 ghcr.io/open-webui/open-webui',
        'Connexion à Ollama ou API DeepSeek directe',
        'Historique des conversations persistant',
        'Multi-utilisateurs, personas, RAG intégré',
        'Interface identique à ChatGPT',
      ],
    ),
    _App(
      icon: Icons.hub_outlined,
      title: 'Jan AI — Desktop all-in-one',
      category: 'Local / Interface graphique',
      description:
          'Application desktop open source qui regroupe modèles locaux et API cloud. '
          'Supporte DeepSeek via l\'API ou en local avec une interface '
          'simple et soignée.',
      tips: [
        'Téléchargement : jan.ai',
        'Windows, macOS, Linux',
        'Supporte Ollama + API DeepSeek',
        'Gestion de threads et modèles intégrée',
        'Open source : github.com/janhq/jan',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, theme, child) => ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _apps.length,
        itemBuilder: (context, i) => _AppCard(
          app: _apps[i],
          color: context.palette[i % context.palette.length],
        ),
      ),
    );
  }
}

class _AppCard extends StatefulWidget {
  final _App app;
  final Color color;
  const _AppCard({required this.app, required this.color});

  @override
  State<_AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<_AppCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.color;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: c.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(widget.app.icon, color: c, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.app.title,
                            style: TextStyle(
                                color: c,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: c.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(widget.app.category,
                              style: TextStyle(
                                  color: c,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      color: c,
                      size: 20),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: c.withValues(alpha: 0.2)),
                  Text(widget.app.description,
                      style: TextStyle(
                          color: context.onSurface.withValues(alpha: 0.8),
                          fontSize: 13,
                          height: 1.5)),
                  const SizedBox(height: 10),
                  ...widget.app.tips.map((tip) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.arrow_right, color: c, size: 18),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(tip,
                                  style: TextStyle(
                                      color: context.onSurface
                                          .withValues(alpha: 0.7),
                                      fontSize: 13)),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _App {
  final IconData icon;
  final String title;
  final String category;
  final String description;
  final List<String> tips;

  const _App({
    required this.icon,
    required this.title,
    required this.category,
    required this.description,
    required this.tips,
  });
}
