import 'package:flutter/material.dart';
import '../app_theme.dart';

class FeaturesScreen extends StatelessWidget {
  const FeaturesScreen({super.key});

  static final _features = [
    _Feature(
      icon: Icons.memory,
      title: 'DeepSeek-V3',
      description:
          'Architecture MoE (Mixture of Experts) avec 671B paramètres totaux. Performances état de l\'art sur le code, les mathématiques et le raisonnement général.',
      tips: [
        'Architecture MoE : 37B paramètres actifs sur 671B',
        'Performances comparables aux meilleurs modèles frontier',
        'Excellent sur la génération et l\'analyse de code',
        'Très efficace sur les benchmarks mathématiques',
      ],
    ),
    _Feature(
      icon: Icons.psychology_outlined,
      title: 'DeepSeek-R1 Raisonnement',
      description:
          'Modèle de raisonnement avec Chain-of-Thought visible. Conçu pour la résolution de problèmes complexes en mathématiques, logique et code.',
      tips: [
        'Chain-of-Thought visible dans reasoning_content',
        'Résolution étape par étape des problèmes',
        'Performances de niveau expert en mathématiques',
        'Excellent pour la programmation compétitive',
      ],
    ),
    _Feature(
      icon: Icons.api,
      title: 'Compatible OpenAI',
      description:
          'L\'API DeepSeek utilise exactement le même format que l\'API OpenAI, permettant une intégration facile via les SDKs existants.',
      tips: [
        'SDK openai Python/JS compatible directement',
        'Migration facile depuis GPT en changeant base_url',
        'Même format de requêtes et réponses JSON',
        'Support du streaming identique (SSE)',
      ],
    ),
    _Feature(
      icon: Icons.open_in_new,
      title: 'Open Source',
      description:
          'Les modèles DeepSeek sont disponibles en open source sur Hugging Face et GitHub, permettant le déploiement local et la personnalisation.',
      tips: [
        'Modèles disponibles sur Hugging Face',
        'Code source sur github.com/deepseek-ai',
        'Licences permissives pour usage commercial',
        'Déploiement local possible avec ollama/vLLM',
      ],
    ),
    _Feature(
      icon: Icons.straighten,
      title: 'Contexte 128K',
      description:
          'Fenêtre de contexte de 128 000 tokens permettant de traiter de très longs documents, bases de code entières et conversations étendues.',
      tips: [
        'Jusqu\'à 128 000 tokens d\'entrée',
        'Analyse de bases de code complètes',
        'Traitement de documents très longs',
        'Conversations sans perte de contexte',
      ],
    ),
    _Feature(
      icon: Icons.attach_money,
      title: 'Prix compétitif',
      description:
          'Tarification très compétitive par rapport aux concurrents, avec un excellent rapport qualité-prix pour les applications en production.',
      tips: [
        'Coût inférieur aux modèles comparables',
        'Facturation à l\'usage (tokens)',
        'Idéal pour les applications à fort volume',
        'Plan gratuit disponible pour les tests',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, _, child) => ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _features.length,
        itemBuilder: (context, i) => _FeatureCard(
          feature: _features[i],
          color: context.palette[i % context.palette.length],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final _Feature feature;
  final Color color;
  const _FeatureCard({required this.feature, required this.color});
  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.color.withValues(alpha: 0.3)),
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
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(widget.feature.icon, color: widget.color, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(widget.feature.title,
                        style: TextStyle(
                            color: widget.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                  ),
                  Icon(_expanded ? Icons.expand_less : Icons.expand_more,
                      color: widget.color, size: 20),
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
                  Divider(color: widget.color.withValues(alpha: 0.2)),
                  Text(widget.feature.description,
                      style: TextStyle(
                          color: context.onSurface.withValues(alpha: 0.8),
                          fontSize: 13,
                          height: 1.5)),
                  const SizedBox(height: 10),
                  ...widget.feature.tips.map((tip) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.arrow_right, color: widget.color, size: 18),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(tip,
                                  style: TextStyle(
                                      color: context.onSurface.withValues(alpha: 0.7),
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

class _Feature {
  final IconData icon;
  final String title;
  final String description;
  final List<String> tips;
  const _Feature(
      {required this.icon,
      required this.title,
      required this.description,
      required this.tips});
}
