import 'package:flutter/material.dart';
import '../app_theme.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  static final _questions = [
    // ── Modèles & architecture ───────────────────────────────────────────
    _Question(
      question: 'Quel modèle DeepSeek est spécialisé dans le raisonnement mathématique et logique ?',
      options: ['DeepSeek-V3', 'DeepSeek-R1', 'DeepSeek-Coder', 'DeepSeek-VL'],
      correct: 1,
      explanation: 'DeepSeek-R1 est le modèle de raisonnement avec Chain-of-Thought interne. '
          'Il est comparable à o1 d\'OpenAI pour les maths, la logique et le code compétitif.',
    ),
    _Question(
      question: 'Quelle architecture DeepSeek utilise-t-il pour être plus efficace que les modèles dense ?',
      options: [
        'Transformer classique (dense)',
        'Mixture of Experts (MoE)',
        'Recurrent Neural Network (RNN)',
        'Convolutional Network (CNN)',
      ],
      correct: 1,
      explanation: 'DeepSeek utilise Mixture of Experts (MoE) : seule une fraction des paramètres '
          'est activée à chaque inférence, ce qui réduit les coûts de calcul tout en '
          'maintenant de très hautes performances.',
    ),
    _Question(
      question: 'Quelle est la taille de la fenêtre de contexte de DeepSeek-V3 ?',
      options: ['32 000 tokens', '64 000 tokens', '128 000 tokens', '1 000 000 tokens'],
      correct: 2,
      explanation: 'DeepSeek-V3 et DeepSeek-R1 disposent d\'une fenêtre de contexte '
          'de 128 000 tokens, soit environ 300 pages de texte.',
    ),
    _Question(
      question: 'Combien de paramètres total possède DeepSeek-V3 (architecture MoE) ?',
      options: ['70 milliards', '236 milliards', '671 milliards', '1 000 milliards'],
      correct: 2,
      explanation: 'DeepSeek-V3 a 671 milliards de paramètres au total, mais seulement '
          '37 milliards sont activés par token grâce à l\'architecture MoE.',
    ),
    // ── API & technique ──────────────────────────────────────────────────
    _Question(
      question: 'Quel est le base URL de l\'API DeepSeek ?',
      options: [
        'https://api.deepseek.ai',
        'https://deepseek.com/api',
        'https://api.deepseek.com',
        'https://api.deepseek.io/v1',
      ],
      correct: 2,
      explanation: 'Le base URL officiel est https://api.deepseek.com. '
          'L\'API est compatible OpenAI, donc vous utilisez le SDK openai '
          'avec base_url="https://api.deepseek.com".',
    ),
    _Question(
      question: 'Avec quelle bibliothèque Python peut-on utiliser l\'API DeepSeek sans package supplémentaire ?',
      options: [
        'pip install deepseek',
        'pip install openai (compatible API)',
        'pip install anthropic',
        'pip install deepseek-sdk',
      ],
      correct: 1,
      explanation: 'L\'API DeepSeek est compatible avec l\'API OpenAI. '
          'On utilise le SDK OpenAI avec base_url="https://api.deepseek.com" '
          'et la clé API DeepSeek — aucun package supplémentaire nécessaire.',
    ),
    _Question(
      question: 'Quel paramètre est spécifique à l\'API DeepSeek pour voir le raisonnement de R1 ?',
      options: [
        'show_thinking: true',
        'reasoning_effort: "high"',
        'Le contenu reasoning_content dans la réponse',
        'chain_of_thought: true',
      ],
      correct: 2,
      explanation: 'Avec DeepSeek-R1, la réponse contient un champ reasoning_content '
          'qui expose le processus de réflexion interne du modèle avant la réponse finale.',
    ),
    _Question(
      question: 'Quel est l\'avantage principal de l\'API DeepSeek par rapport à OpenAI ?',
      options: [
        'Interface plus simple',
        'Coût environ 20 à 30 fois moins cher',
        'Meilleure qualité sur tous les benchmarks',
        'Plus de modèles disponibles',
      ],
      correct: 1,
      explanation: 'DeepSeek est environ 20 à 30x moins cher qu\'OpenAI GPT-4o. '
          'Exemple : deepseek-chat coûte ~0,07\$/1M tokens en entrée '
          'contre ~2,5\$/1M pour GPT-4o.',
    ),
    // ── Utilisation locale ───────────────────────────────────────────────
    _Question(
      question: 'Quelle commande Ollama lance DeepSeek-R1 en mode interactif ?',
      options: [
        'ollama start deepseek-r1',
        'ollama run deepseek-r1',
        'ollama serve deepseek-r1',
        'ollama chat deepseek-r1',
      ],
      correct: 1,
      explanation: '"ollama run deepseek-r1" télécharge (si absent) et lance '
          'le modèle en mode interactif dans le terminal. '
          'Ajoutez ":7b", ":14b" etc. pour choisir la taille.',
    ),
    _Question(
      question: 'Sur quel port Ollama expose-t-il son API locale ?',
      options: ['3000', '8080', '11434', '5000'],
      correct: 2,
      explanation: 'Ollama écoute par défaut sur le port 11434. '
          'L\'API est accessible à http://localhost:11434/v1 '
          'et est compatible avec le SDK OpenAI.',
    ),
    // ── Bonnes pratiques des prompts ─────────────────────────────────────
    _Question(
      question: 'Quelle est la meilleure façon de structurer un prompt pour DeepSeek ?',
      options: [
        'Écrire le plus court possible sans contexte',
        'Donner un rôle clair, le contexte et la tâche précise',
        'Utiliser uniquement des mots-clés',
        'Poser une question vague pour laisser le modèle interpréter',
      ],
      correct: 1,
      explanation: 'Un bon prompt précise le rôle ("tu es un expert en..."), '
          'le contexte et la tâche exacte avec les contraintes de format. '
          'Plus le prompt est structuré, plus la réponse est pertinente.',
    ),
    _Question(
      question: 'Que signifie "few-shot prompting" ?',
      options: [
        'Utiliser le moins de tokens possible',
        'Fournir des exemples entrée/sortie dans le prompt',
        'Envoyer plusieurs requêtes en parallèle',
        'Limiter le modèle à trois réponses maximum',
      ],
      correct: 1,
      explanation: 'Le few-shot prompting consiste à inclure 2 à 5 exemples '
          'dans le prompt pour montrer au modèle le format attendu. '
          'Très efficace pour des tâches avec un format de sortie précis.',
    ),
    _Question(
      question: 'Quelle technique aide DeepSeek-R1 à résoudre des problèmes complexes ?',
      options: [
        'Prompt stuffing',
        'Demander "Raisonne étape par étape" (Chain-of-Thought)',
        'Token pruning',
        'Augmenter max_tokens à 8000',
      ],
      correct: 1,
      explanation: 'Ajouter "Raisonne étape par étape" active le Chain-of-Thought. '
          'DeepSeek-R1 l\'utilise nativement en interne, mais l\'expliciter '
          'dans le prompt améliore encore la précision.',
    ),
    _Question(
      question: 'Comment obtenir une sortie JSON fiable avec DeepSeek ?',
      options: [
        'Écrire "JSON please" à la fin du prompt',
        'Utiliser response_format: {"type": "json_object"} + le mentionner dans le prompt',
        'Réduire temperature à 0 uniquement',
        'DeepSeek ne supporte pas le JSON structuré',
      ],
      correct: 1,
      explanation: 'Pour garantir du JSON valide, combinez : '
          'response_format={"type": "json_object"} dans les paramètres API '
          'ET précisez "réponds en JSON" dans le message system ou user.',
    ),
    _Question(
      question: 'Que faire pour réduire les hallucinations de DeepSeek ?',
      options: [
        'Augmenter temperature pour plus de créativité',
        'Fournir les données dans le contexte et demander de citer ses sources',
        'Passer à un modèle plus petit',
        'Les hallucinations sont inévitables, il faut les accepter',
      ],
      correct: 1,
      explanation: 'Pour réduire les hallucinations, fournissez les faits directement '
          'dans le prompt ("Voici le document : {...}") et demandez de ne répondre '
          'que sur cette base. Baisser temperature vers 0 aide aussi.',
    ),
    _Question(
      question: 'Quel est l\'avantage d\'utiliser des délimiteurs (```, """) dans un prompt ?',
      options: [
        'Ils accélèrent la génération',
        'Ils réduisent le coût en tokens',
        'Ils séparent clairement les instructions du contenu à traiter',
        'Ils sont obligatoires pour l\'API DeepSeek',
      ],
      correct: 2,
      explanation: 'Les délimiteurs permettent de séparer les instructions '
          'du contenu à analyser, évitant la confusion. '
          'Exemple : "Résume ce texte : ```{texte}```".',
    ),
  ];

  int _index = 0;
  int _score = 0;
  int? _selected;
  bool _answered = false;
  bool _finished = false;

  void _answer(int choice) {
    if (_answered) return;
    setState(() {
      _selected = choice;
      _answered = true;
      if (_questions[_index].correct == choice) _score++;
    });
  }

  void _next() {
    if (_index < _questions.length - 1) {
      setState(() {
        _index++;
        _selected = null;
        _answered = false;
      });
    } else {
      setState(() => _finished = true);
    }
  }

  void _restart() {
    setState(() {
      _index = 0;
      _score = 0;
      _selected = null;
      _answered = false;
      _finished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, theme, child) {
        if (_finished) {
          return _ResultPage(score: _score, total: _questions.length, onRestart: _restart);
        }
        final q = _questions[_index];
        final c = context.primary;
        final c2 = context.secondary;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress
              Row(
                children: [
                  Text('${_index + 1} / ${_questions.length}',
                      style: TextStyle(
                          color: context.onSurface.withValues(alpha: 0.6),
                          fontSize: 13)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (_index + 1) / _questions.length,
                        backgroundColor: c.withValues(alpha: 0.15),
                        color: c,
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    children: [
                      Icon(Icons.star, color: c2, size: 16),
                      const SizedBox(width: 4),
                      Text('$_score',
                          style: TextStyle(
                              color: c2,
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Question
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: context.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: c.withValues(alpha: 0.3)),
                ),
                child: Text(q.question,
                    style: TextStyle(
                        color: context.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.4)),
              ),
              const SizedBox(height: 16),
              // Options
              ...List.generate(q.options.length, (i) {
                Color borderColor = c.withValues(alpha: 0.2);
                Color bgColor = context.cardBg;
                Color textColor = context.onSurface.withValues(alpha: 0.85);
                IconData? trailingIcon;

                if (_answered) {
                  if (i == q.correct) {
                    borderColor = Colors.green;
                    bgColor = Colors.green.withValues(alpha: 0.12);
                    textColor = Colors.green;
                    trailingIcon = Icons.check_circle_outline;
                  } else if (i == _selected && i != q.correct) {
                    borderColor = Colors.red;
                    bgColor = Colors.red.withValues(alpha: 0.1);
                    textColor = Colors.red.shade300;
                    trailingIcon = Icons.cancel_outlined;
                  }
                }

                return GestureDetector(
                  onTap: () => _answer(i),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: (_answered && i == q.correct)
                                ? Colors.green.withValues(alpha: 0.2)
                                : c.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(String.fromCharCode(65 + i),
                                style: TextStyle(
                                    color: (_answered && i == q.correct)
                                        ? Colors.green
                                        : c,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(q.options[i],
                              style: TextStyle(color: textColor, fontSize: 14)),
                        ),
                        if (trailingIcon != null)
                          Icon(trailingIcon,
                              color: i == q.correct
                                  ? Colors.green
                                  : Colors.red.shade300,
                              size: 20),
                      ],
                    ),
                  ),
                );
              }),
              // Explanation
              if (_answered) ...[
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: c.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: c.withValues(alpha: 0.25)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: c, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(q.explanation,
                            style: TextStyle(
                                color: context.onSurface.withValues(alpha: 0.8),
                                fontSize: 13,
                                height: 1.5)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: c,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      _index < _questions.length - 1
                          ? 'Question suivante →'
                          : 'Voir les résultats',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

class _ResultPage extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onRestart;

  const _ResultPage({
    required this.score,
    required this.total,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = score / total;
    final c = context.primary;
    final c2 = context.secondary;

    final (emoji, label, comment) = ratio >= 0.9
        ? ('🏆', 'Excellent !', 'Maîtrise parfaite de DeepSeek !')
        : ratio >= 0.7
            ? ('⭐', 'Très bien !', 'Bonne connaissance, quelques points à revoir')
            : ratio >= 0.5
                ? ('👍', 'Pas mal !', 'Continuez à explorer le guide')
                : ('📚', 'À revoir', 'Relisez les sections du guide et réessayez');

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(label,
                style: TextStyle(
                    color: c, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(comment,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: context.onSurface.withValues(alpha: 0.7),
                    fontSize: 15)),
            const SizedBox(height: 32),
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: c, width: 4),
                color: c.withValues(alpha: 0.08),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$score / $total',
                      style: TextStyle(
                          color: c,
                          fontSize: 32,
                          fontWeight: FontWeight.bold)),
                  Text('${(ratio * 100).round()}%',
                      style: TextStyle(
                          color: c2,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: ratio,
                backgroundColor: c.withValues(alpha: 0.15),
                color: c,
                minHeight: 12,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onRestart,
                icon: const Icon(Icons.refresh),
                label: const Text('Recommencer',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: c,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Question {
  final String question;
  final List<String> options;
  final int correct;
  final String explanation;

  const _Question({
    required this.question,
    required this.options,
    required this.correct,
    required this.explanation,
  });
}
