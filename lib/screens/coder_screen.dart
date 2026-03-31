import 'package:flutter/material.dart';
import '../app_theme.dart';

class CoderScreen extends StatefulWidget {
  const CoderScreen({super.key});
  @override
  State<CoderScreen> createState() => _CoderScreenState();
}

class _CoderScreenState extends State<CoderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, theme, child) => Column(
        children: [
          Container(
            color: context.cardBg,
            child: TabBar(
              controller: _tab,
              labelColor: context.primary,
              unselectedLabelColor: context.onSurface.withValues(alpha: 0.5),
              indicatorColor: context.primary,
              tabs: const [
                Tab(text: 'DeepSeek-Coder'),
                Tab(text: 'Ollama Local'),
                Tab(text: 'Continue.dev'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _DeepSeekCoderTab(),
                _OllamaTab(),
                _ContinueTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tab 1 : DeepSeek-Coder ──────────────────────────────────────────────────

class _DeepSeekCoderTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.primary;
    final c2 = context.secondary;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        sectionTitle('Qu\'est-ce que DeepSeek-Coder ?', context),
        _InfoCard(
          icon: Icons.code,
          color: c,
          title: 'Modèle spécialisé pour le code',
          body: 'DeepSeek-Coder est une famille de modèles entraînés spécifiquement '
              'sur du code. Il supporte plus de 80 langages de programmation, '
              'une fenêtre de contexte de 128K tokens et surpasse GPT-4 '
              'sur certains benchmarks de code (HumanEval, MBPP).',
        ),
        const SizedBox(height: 4),
        sectionTitle('Modèles disponibles', context),
        _ModelCard(color: c, name: 'deepseek-coder-v2',      ctx: '128K', note: 'Recommandé — meilleur rapport qualité/prix'),
        _ModelCard(color: c2, name: 'deepseek-coder-v2-lite', ctx: '128K', note: 'Rapide et économique'),
        _ModelCard(color: c, name: 'deepseek-chat',           ctx: '128K', note: 'V3 — aussi excellent en code'),
        const SizedBox(height: 8),
        sectionTitle('Utilisation via l\'API', context),
        _StepCard(
          step: 1,
          color: c,
          title: 'Python — Génération de code',
          child: const CodeBlock(
            code: 'from openai import OpenAI\n\n'
                'client = OpenAI(\n'
                '  api_key="votre_cle_deepseek",\n'
                '  base_url="https://api.deepseek.com"\n'
                ')\n\n'
                'response = client.chat.completions.create(\n'
                '  model="deepseek-chat",\n'
                '  messages=[\n'
                '    {"role": "system", "content": "Tu es un expert Python."},\n'
                '    {"role": "user", "content": "Écris une fonction de tri rapide"}\n'
                '  ]\n'
                ')\n'
                'print(response.choices[0].message.content)',
          ),
        ),
        _StepCard(
          step: 2,
          color: c,
          title: 'Fill-in-the-Middle (FIM)',
          child: const CodeBlock(
            code: '# Complétion de code au milieu d\'un fichier\n'
                'response = client.chat.completions.create(\n'
                '  model="deepseek-chat",\n'
                '  messages=[{"role": "user",\n'
                '    "content": "<|fim_prefix|>def trier(lst):\\n'
                '    <|fim_suffix|>\\n    return lst<|fim_middle|>"}]\n'
                ')',
          ),
        ),
        _InfoCard(
          icon: Icons.bar_chart_outlined,
          color: c2,
          title: 'Langages supportés',
          body: null,
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              'Python', 'JavaScript', 'TypeScript', 'Go', 'Rust',
              'C++', 'Java', 'Swift', 'Kotlin', 'SQL',
              'Dart', 'Ruby', 'PHP', 'Bash', '80+ autres',
            ].map((lang) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: c2.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: c2.withValues(alpha: 0.3)),
              ),
              child: Text(lang,
                  style: TextStyle(color: c2, fontSize: 12,
                      fontWeight: FontWeight.w500)),
            )).toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ── Tab 2 : Ollama Local ────────────────────────────────────────────────────

class _OllamaTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.primary;
    final c2 = context.secondary;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        sectionTitle('DeepSeek en local avec Ollama', context),
        _InfoCard(
          icon: Icons.computer_outlined,
          color: c,
          title: 'Pourquoi utiliser Ollama ?',
          body: 'Ollama vous permet d\'exécuter DeepSeek entièrement sur votre '
              'machine. Vos données ne quittent jamais votre ordinateur, '
              'l\'utilisation est gratuite et illimitée (limité par votre RAM/GPU).',
        ),
        const SizedBox(height: 8),
        sectionTitle('Installation', context),
        _StepCard(
          step: 1,
          color: c,
          title: 'Installer Ollama',
          child: const CodeBlock(
            code: '# macOS / Linux\ncurl -fsSL https://ollama.com/install.sh | sh\n\n'
                '# Windows\n# Télécharger l\'installeur sur ollama.com',
          ),
        ),
        _StepCard(
          step: 2,
          color: c,
          title: 'Télécharger DeepSeek',
          child: const CodeBlock(
            code: '# DeepSeek-R1 (raisonnement) — plusieurs tailles\n'
                'ollama pull deepseek-r1:1.5b   # ~1 GB — CPU suffisant\n'
                'ollama pull deepseek-r1:7b     # ~4 GB\n'
                'ollama pull deepseek-r1:14b    # ~8 GB\n'
                'ollama pull deepseek-r1:32b    # ~19 GB\n\n'
                '# DeepSeek-Coder\n'
                'ollama pull deepseek-coder-v2',
          ),
        ),
        _StepCard(
          step: 3,
          color: c,
          title: 'Lancer et utiliser',
          child: const CodeBlock(
            code: '# Mode interactif dans le terminal\nollama run deepseek-r1:7b\n\n'
                '# API locale (compatible OpenAI)\ncurl http://localhost:11434/v1/chat/completions \\\n'
                '  -H "Content-Type: application/json" \\\n'
                '  -d \'{"model":"deepseek-r1:7b","messages":[{"role":"user","content":"Bonjour"}]}\'',
          ),
        ),
        const SizedBox(height: 8),
        sectionTitle('Recommandations RAM', context),
        _InfoCard(
          icon: Icons.memory_outlined,
          color: c2,
          title: 'Quelle taille choisir ?',
          body: null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ramRow(context, c2, '1.5b', '4 Go RAM', 'Tests rapides, CPU uniquement'),
              _ramRow(context, c2, '7b',   '8 Go RAM', 'Usage quotidien, bon équilibre'),
              _ramRow(context, c2, '14b',  '16 Go RAM', 'Très bonnes performances'),
              _ramRow(context, c2, '32b',  '32 Go RAM', 'Proche du niveau API'),
              _ramRow(context, c2, '70b',  '64 Go RAM', 'Performances maximales'),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _ramRow(BuildContext ctx, Color c, String model, String ram, String note) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          children: [
            Container(
              width: 44,
              padding: const EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                color: c.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(model,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: c, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 72,
              child: Text(ram,
                  style: TextStyle(
                      color: ctx.onSurface.withValues(alpha: 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
            ),
            Expanded(
              child: Text(note,
                  style: TextStyle(
                      color: ctx.onSurface.withValues(alpha: 0.6),
                      fontSize: 12)),
            ),
          ],
        ),
      );
}

// ── Tab 3 : Continue.dev ────────────────────────────────────────────────────

class _ContinueTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.primary;
    final c2 = context.secondary;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        sectionTitle('Continue.dev avec DeepSeek', context),
        _InfoCard(
          icon: Icons.extension_outlined,
          color: c,
          title: 'Assistant de code open source',
          body: 'Continue.dev est une extension VS Code / JetBrains open source '
              'qui s\'intègre avec DeepSeek via l\'API ou via Ollama en local. '
              'Autocomplétion, chat, édition inline — sans coût d\'abonnement.',
        ),
        const SizedBox(height: 8),
        sectionTitle('Installation', context),
        _StepCard(
          step: 1,
          color: c,
          title: 'Installer l\'extension VS Code',
          child: const CodeBlock(
            code: 'code --install-extension Continue.continue',
          ),
        ),
        _StepCard(
          step: 2,
          color: c,
          title: 'Configurer avec l\'API DeepSeek',
          child: const CodeBlock(
            code: '// ~/.continue/config.json\n{\n'
                '  "models": [{\n'
                '    "title": "DeepSeek Chat",\n'
                '    "provider": "openai",\n'
                '    "model": "deepseek-chat",\n'
                '    "apiKey": "votre_cle_deepseek",\n'
                '    "apiBase": "https://api.deepseek.com"\n'
                '  }],\n'
                '  "tabAutocompleteModel": {\n'
                '    "title": "DeepSeek Coder",\n'
                '    "provider": "openai",\n'
                '    "model": "deepseek-chat",\n'
                '    "apiKey": "votre_cle_deepseek",\n'
                '    "apiBase": "https://api.deepseek.com"\n'
                '  }\n'
                '}',
          ),
        ),
        _StepCard(
          step: 3,
          color: c,
          title: 'Configurer avec Ollama (local)',
          child: const CodeBlock(
            code: '// ~/.continue/config.json — version locale\n{\n'
                '  "models": [{\n'
                '    "title": "DeepSeek R1 local",\n'
                '    "provider": "ollama",\n'
                '    "model": "deepseek-r1:7b"\n'
                '  }]\n'
                '}',
          ),
        ),
        const SizedBox(height: 8),
        sectionTitle('Raccourcis', context),
        _InfoCard(
          icon: Icons.keyboard_outlined,
          color: c2,
          title: 'Raccourcis VS Code',
          body: null,
          child: const CodeBlock(
            code: 'Tab          → accepter l\'autocomplétion\n'
                'Ctrl+L       → ouvrir le chat\n'
                'Ctrl+I       → édition inline\n'
                'Ctrl+Shift+R → refactoriser la sélection\n'
                'Ctrl+Shift+E → expliquer le code sélectionné',
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ── Shared widgets ──────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String? body;
  final Widget? child;

  const _InfoCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ),
            ],
          ),
          if (body != null) ...[
            const SizedBox(height: 10),
            Text(body!,
                style: TextStyle(
                    color: context.onSurface.withValues(alpha: 0.8),
                    fontSize: 13,
                    height: 1.5)),
          ],
          if (child != null) ...[
            const SizedBox(height: 10),
            child!,
          ],
        ],
      ),
    );
  }
}

class _ModelCard extends StatelessWidget {
  final Color color;
  final String name;
  final String ctx;
  final String note;

  const _ModelCard({
    required this.color,
    required this.name,
    required this.ctx,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(name,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    fontFamily: 'monospace')),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(ctx,
                style: TextStyle(color: color, fontSize: 11)),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(note,
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: context.onSurface.withValues(alpha: 0.6),
                    fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final int step;
  final Color color;
  final String title;
  final Widget child;

  const _StepCard({
    required this.step,
    required this.color,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('$step',
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
                const SizedBox(height: 8),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
