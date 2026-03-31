import 'package:flutter/material.dart';
import '../app_theme.dart';

class AiAgentsScreen extends StatelessWidget {
  const AiAgentsScreen({super.key});

  static final _sections = [
    _Section(
      icon: Icons.auto_awesome,
      title: "Qu'est-ce que l'IA générative ?",
      intro:
          "L'intelligence artificielle générative est une technologie capable de comprendre le langage humain et de produire du contenu — texte, code, images, audio — à partir de simples instructions. Elle ne suit pas des règles programmées : elle a appris à raisonner en analysant des milliards de documents.",
      blocks: [
        _Block(
          label: 'Comprendre et raisonner',
          icon: Icons.psychology,
          description:
              "L'IA lit, résume et analyse n'importe quel texte. Elle peut répondre à des questions complexes, extraire des informations clés, comparer des documents et en déduire des conclusions — comme un expert humain, mais en quelques secondes.",
          examples: [
            'Résumer un rapport de 50 pages en 5 points',
            'Répondre à des questions sur un contrat juridique',
            'Comparer deux offres commerciales et identifier les différences',
            'Expliquer un concept technique à un non-spécialiste',
          ],
        ),
        _Block(
          label: 'Générer du contenu',
          icon: Icons.edit_note,
          description:
              "L'IA rédige des textes professionnels, créatifs ou techniques sur demande. Elle s'adapte au ton, au format et au niveau de langage souhaités : email formel, article de blog, fiche produit, script vidéo…",
          examples: [
            'Rédiger un email de prospection commerciale',
            'Écrire une description produit pour un e-commerce',
            'Créer un script pour une vidéo YouTube',
            'Générer des variantes A/B pour une accroche publicitaire',
          ],
        ),
        _Block(
          label: 'Coder et développer',
          icon: Icons.code,
          description:
              "L'IA écrit, explique, corrige et optimise du code dans tous les langages. Elle peut générer des fonctions complètes, déboguer des erreurs, convertir du code d'un langage à un autre ou expliquer comment fonctionne un programme existant.",
          examples: [
            'Générer une API REST en Python ou Node.js',
            'Corriger un bug et expliquer la cause',
            'Convertir du code Python en JavaScript',
            'Écrire des tests unitaires automatiquement',
          ],
        ),
      ],
    ),
    _Section(
      icon: Icons.smart_toy_outlined,
      title: "Les Agents IA : l'IA qui agit",
      intro:
          "Un agent IA est une IA à qui l'on confie un objectif, et qui planifie et exécute elle-même les étapes pour l'atteindre. Là où un simple chatbot répond à une question, un agent accomplit une mission : il navigue sur le web, utilise des outils, écrit du code, l'exécute, corrige ses erreurs… en autonomie.",
      blocks: [
        _Block(
          label: 'Automatiser des flux de travail',
          icon: Icons.account_tree_outlined,
          description:
              "Un agent peut enchaîner des actions complexes sans intervention humaine : chercher des données en ligne, les traiter, générer un rapport, l'envoyer par email. Ce qui prenait des heures peut être délégué entièrement.",
          examples: [
            'Surveiller des concurrents et envoyer un rapport quotidien',
            'Extraire des données d\'un site web et les mettre en tableau',
            'Générer et envoyer des newsletters personnalisées',
            'Mettre à jour automatiquement une base de données CRM',
          ],
        ),
        _Block(
          label: 'Recherche et veille intelligente',
          icon: Icons.travel_explore,
          description:
              "Avec l'accès à Internet (comme les modèles Sonar de Perplexity), un agent fait de la veille en temps réel. Il parcourt des dizaines de sources, synthétise l'information et la présente sous forme structurée.",
          examples: [
            'Veille concurrentielle quotidienne dans son secteur',
            'Synthèse des dernières publications scientifiques',
            'Suivi des tendances d\'un marché en temps réel',
            'Fact-checking automatisé d\'un article',
          ],
        ),
        _Block(
          label: 'Agents de développement logiciel',
          icon: Icons.terminal,
          description:
              "Des agents comme Claude Code ou Cursor peuvent lire une base de code entière, comprendre l'architecture, implémenter de nouvelles fonctionnalités, écrire des tests et corriger des bugs — de manière autonome ou en collaboration avec le développeur.",
          examples: [
            'Implémenter une feature à partir d\'un ticket Jira',
            'Refactoriser du code legacy pour le moderniser',
            'Générer une documentation technique complète',
            'Déboguer une application en analysant les logs',
          ],
        ),
        _Block(
          label: 'Agents multimodaux',
          icon: Icons.image_search,
          description:
              "Les agents récents comprennent aussi les images, les PDFs et les tableaux. Ils peuvent analyser une capture d'écran, lire un document scanné, interpréter un graphique ou remplir des formulaires automatiquement.",
          examples: [
            'Analyser une facture PDF et extraire les montants',
            'Interpréter un graphique et en tirer des conclusions',
            'Remplir automatiquement des formulaires administratifs',
            'Décrire et catégoriser des photos produits',
          ],
        ),
      ],
    ),
    _Section(
      icon: Icons.category_outlined,
      title: 'Les domaines d\'application',
      intro:
          "L'IA et ses agents transforment progressivement chaque secteur d'activité. Voici les principaux domaines où l'impact est déjà mesurable aujourd'hui.",
      blocks: [
        _Block(
          label: 'Entreprises & Productivité',
          icon: Icons.business_center_outlined,
          description:
              "Les équipes utilisent l'IA pour automatiser les tâches répétitives, accélérer la prise de décision et produire plus en moins de temps. L'IA ne remplace pas les employés : elle amplifie leur capacité d'action.",
          examples: [
            'Rédaction automatique de comptes-rendus de réunion',
            'Analyse de données commerciales et tableaux de bord',
            'Support client automatisé 24h/24',
            'Génération de propositions commerciales personnalisées',
          ],
        ),
        _Block(
          label: 'Développeurs & Tech',
          icon: Icons.developer_mode_outlined,
          description:
              "Les développeurs sont parmi les premiers bénéficiaires : génération de code, revue de code, documentation, tests automatiques. Des études montrent un gain de productivité de 30 à 55% sur les tâches de développement.",
          examples: [
            'Complétion de code en temps réel (Copilot, Cursor)',
            'Génération automatique de tests unitaires',
            'Explication de code et documentation',
            'Migrations de bases de données et refactorisation',
          ],
        ),
        _Block(
          label: 'Créatifs & Communication',
          icon: Icons.brush_outlined,
          description:
              "Rédacteurs, marketeurs, designers et créateurs de contenu utilisent l'IA comme assistant créatif. Elle génère des idées, des brouillons, des variantes et libère du temps pour le travail à haute valeur ajoutée.",
          examples: [
            'Idéation et brainstorming créatif',
            'Rédaction de contenu SEO à grande échelle',
            'Traduction et adaptation culturelle de contenus',
            'Génération de visuels avec Midjourney, DALL·E…',
          ],
        ),
        _Block(
          label: 'Éducation & Formation',
          icon: Icons.school_outlined,
          description:
              "L'IA permet un apprentissage personnalisé : tutorat adaptatif, génération d'exercices, explication sur mesure selon le niveau de l'apprenant. Elle aide aussi les formateurs à créer des supports pédagogiques rapidement.",
          examples: [
            'Tuteur personnalisé qui s\'adapte au rythme de l\'élève',
            'Génération d\'exercices et de QCM sur n\'importe quel sujet',
            'Correction automatique avec explications détaillées',
            'Création de plans de cours et supports de formation',
          ],
        ),
        _Block(
          label: 'Recherche & Sciences',
          icon: Icons.science_outlined,
          description:
              "Les chercheurs utilisent l'IA pour explorer des corpus de littérature scientifique, générer des hypothèses, analyser des données expérimentales et accélérer le cycle de publication.",
          examples: [
            'Revue de littérature automatisée sur un sujet',
            'Analyse statistique et visualisation de données',
            'Aide à la rédaction d\'articles scientifiques',
            'Génération d\'hypothèses à partir de données',
          ],
        ),
        _Block(
          label: 'Santé & Médical',
          icon: Icons.health_and_safety_outlined,
          description:
              "Dans un cadre réglementé, l'IA assiste les professionnels de santé : aide au diagnostic, analyse d'imagerie médicale, résumé de dossiers patients, recherche bibliographique médicale.",
          examples: [
            'Résumé automatique de dossiers médicaux',
            'Aide à l\'interprétation d\'examens d\'imagerie',
            'Recherche de protocoles thérapeutiques',
            'Chatbot d\'orientation médicale de premier niveau',
          ],
        ),
      ],
    ),
    _Section(
      icon: Icons.people_outlined,
      title: 'Qui est concerné ?',
      intro:
          "L'IA n'est pas réservée aux experts en informatique. Aujourd'hui, elle est accessible à toute personne ayant un ordinateur et une connexion internet. Voici les profils qui en bénéficient le plus.",
      blocks: [
        _Block(
          label: 'Les particuliers',
          icon: Icons.person_outlined,
          description:
              "Rédiger un email difficile, préparer un voyage, comprendre un document juridique, apprendre une nouvelle compétence… L'IA est un assistant personnel disponible en permanence, pour toutes les tâches du quotidien.",
          examples: [
            'Aide à la rédaction de CV et lettres de motivation',
            'Planification de voyages personnalisée',
            'Explication de documents administratifs complexes',
            'Apprentissage d\'une langue étrangère',
          ],
        ),
        _Block(
          label: 'Les TPE / PME',
          icon: Icons.store_outlined,
          description:
              "Les petites structures n'ont pas les moyens de grandes équipes. L'IA leur permet d'automatiser leur communication, leur marketing et leur support client avec des ressources limitées.",
          examples: [
            'Gestion des réseaux sociaux automatisée',
            'Réponse aux avis clients et FAQ automatique',
            'Création de contenus marketing à moindre coût',
            'Analyse de la concurrence locale',
          ],
        ),
        _Block(
          label: 'Les grandes entreprises',
          icon: Icons.corporate_fare_outlined,
          description:
              "À grande échelle, l'IA est déployée via des APIs et des agents intégrés dans les systèmes existants (CRM, ERP, outils internes). Elle traite des volumes d'information impossibles à gérer manuellement.",
          examples: [
            'Analyse de milliers de contrats en parallèle',
            'Personnalisation à grande échelle des communications clients',
            'Automatisation des processus RH (tri de CV, onboarding)',
            'Détection de fraude et anomalies en temps réel',
          ],
        ),
        _Block(
          label: 'Les développeurs & startups',
          icon: Icons.rocket_launch_outlined,
          description:
              "Les développeurs construisent des produits entiers en s'appuyant sur des APIs d'IA. Ce qui demandait une équipe de 10 personnes peut être réalisé par 1 ou 2 développeurs grâce aux agents et aux LLMs.",
          examples: [
            'Construire un chatbot personnalisé sur ses propres données',
            'Intégrer la recherche IA dans une application existante',
            'Créer des pipelines d\'automatisation intelligents',
            'Développer des outils SaaS basés sur l\'IA',
          ],
        ),
      ],
    ),
    _Section(
      icon: Icons.warning_amber_outlined,
      title: 'Limites et points de vigilance',
      intro:
          "L'IA est un outil puissant, mais pas infaillible. Comprendre ses limites est essentiel pour l'utiliser de façon responsable et efficace.",
      blocks: [
        _Block(
          label: 'Hallucinations',
          icon: Icons.blur_on,
          description:
              "L'IA peut inventer des informations avec assurance : citations inexistantes, chiffres erronés, faits incorrects. Il est indispensable de vérifier les informations critiques auprès de sources fiables.",
          examples: [
            'Toujours vérifier les chiffres et statistiques cités',
            'Ne pas faire confiance aveuglément aux références bibliographiques',
            'Croiser les informations importantes avec d\'autres sources',
            'Utiliser des modèles avec accès web (comme Sonar) pour les faits récents',
          ],
        ),
        _Block(
          label: 'Confidentialité des données',
          icon: Icons.lock_outlined,
          description:
              "Les données envoyées à une IA peuvent être utilisées pour l'entraînement ou stockées sur des serveurs tiers. Ne jamais partager d'informations sensibles (données personnelles, secrets commerciaux, données médicales) sans vérifier les politiques de confidentialité.",
          examples: [
            'Anonymiser les données avant de les soumettre à l\'IA',
            'Utiliser des solutions on-premise pour les données sensibles',
            'Vérifier les CGU et politiques de rétention de données',
            'Mettre en place des politiques d\'usage en entreprise',
          ],
        ),
        _Block(
          label: 'Biais et équité',
          icon: Icons.balance_outlined,
          description:
              "Les modèles d'IA reproduisent les biais présents dans leurs données d'entraînement. Dans des contextes sensibles (recrutement, médical, juridique), il faut auditer les résultats pour éviter des discriminations involontaires.",
          examples: [
            'Auditer régulièrement les décisions assistées par IA',
            'Maintenir un regard humain sur les décisions critiques',
            'Tester les modèles sur des données diversifiées',
            'Former les équipes aux biais algorithmiques',
          ],
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, _, _) => ListView(
        padding: EdgeInsets.zero,
        children: [
          _HeroBanner(),
          const SizedBox(height: 8),
          ..._sections.asMap().entries.map(
                (e) => _SectionWidget(
                  section: e.value,
                  baseColor: context.palette[e.key % context.palette.length],
                ),
              ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Hero Banner ────────────────────────────────────────────────────────────────

class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: context.heroGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.hub_outlined, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'IA & Agents IA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      'Comprendre les possibilités, les usages et les acteurs',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: const Text(
              'L\'intelligence artificielle entre dans une nouvelle ère : celle des agents autonomes. '
              'Ces systèmes ne se contentent plus de répondre à des questions — ils planifient, '
              'exécutent des actions, utilisent des outils et accomplissent des missions complexes. '
              'Ce guide vous explique ce qui est possible, pour qui, et comment en tirer parti.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _Badge(icon: Icons.bolt, label: 'Agents autonomes'),
              _Badge(icon: Icons.search, label: 'Recherche en temps réel'),
              _Badge(icon: Icons.code, label: 'Génération de code'),
              _Badge(icon: Icons.auto_fix_high, label: 'Automatisation'),
              _Badge(icon: Icons.groups, label: 'Tous secteurs'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Badge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 13),
          const SizedBox(width: 5),
          Text(label,
              style: const TextStyle(
                  color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ── Section ────────────────────────────────────────────────────────────────────

class _SectionWidget extends StatelessWidget {
  final _Section section;
  final Color baseColor;
  const _SectionWidget({required this.section, required this.baseColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Icon(section.icon, color: baseColor, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  section.title,
                  style: TextStyle(
                    color: baseColor,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Intro text
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: baseColor.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: baseColor.withValues(alpha: 0.2)),
            ),
            child: Text(
              section.intro,
              style: TextStyle(
                color: context.onSurface.withValues(alpha: 0.85),
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Blocks
          ...section.blocks.asMap().entries.map(
                (e) => _BlockCard(
                  block: e.value,
                  color: context.palette[e.key % context.palette.length],
                ),
              ),
        ],
      ),
    );
  }
}

// ── Block Card ─────────────────────────────────────────────────────────────────

class _BlockCard extends StatefulWidget {
  final _Block block;
  final Color color;
  const _BlockCard({required this.block, required this.color});

  @override
  State<_BlockCard> createState() => _BlockCardState();
}

class _BlockCardState extends State<_BlockCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: widget.color.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(widget.block.icon, color: widget.color, size: 19),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      widget.block.label,
                      style: TextStyle(
                        color: widget.color,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: widget.color,
                    size: 20,
                  ),
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
                  Divider(color: widget.color.withValues(alpha: 0.15), height: 1),
                  const SizedBox(height: 10),
                  Text(
                    widget.block.description,
                    style: TextStyle(
                      color: context.onSurface.withValues(alpha: 0.8),
                      fontSize: 13,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lightbulb_outline,
                                size: 13, color: widget.color),
                            const SizedBox(width: 5),
                            Text(
                              'Exemples concrets',
                              style: TextStyle(
                                color: widget.color,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ...widget.block.examples.map(
                          (ex) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.check_circle_outline,
                                    size: 14, color: widget.color),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    ex,
                                    style: TextStyle(
                                      color:
                                          context.onSurface.withValues(alpha: 0.7),
                                      fontSize: 12,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ── Data models ────────────────────────────────────────────────────────────────

class _Section {
  final IconData icon;
  final String title;
  final String intro;
  final List<_Block> blocks;
  const _Section(
      {required this.icon,
      required this.title,
      required this.intro,
      required this.blocks});
}

class _Block {
  final String label;
  final IconData icon;
  final String description;
  final List<String> examples;
  const _Block(
      {required this.label,
      required this.icon,
      required this.description,
      required this.examples});
}
