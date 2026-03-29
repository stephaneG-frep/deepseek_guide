import 'package:flutter/material.dart';
import '../app_theme.dart';

class InstallationScreen extends StatefulWidget {
  const InstallationScreen({super.key});
  @override
  State<InstallationScreen> createState() => _InstallationScreenState();
}

class _InstallationScreenState extends State<InstallationScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, _, child) => Column(
        children: [
          Container(
            color: context.cardBg,
            child: TabBar(
              controller: _tabController,
              indicatorColor: context.accentLight,
              labelColor: context.accentLight,
              unselectedLabelColor: context.onSurface.withValues(alpha: 0.4),
              tabs: const [Tab(text: 'Python'), Tab(text: 'Node.js')],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_PythonTab(), _NodeTab()],
            ),
          ),
        ],
      ),
    );
  }
}

class _PythonTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        sectionTitle('Prérequis', context),
        _StepCard(
          step: '0',
          title: 'Python 3.8+',
          content: 'python --version\n# Python 3.8 ou supérieur requis',
          color: context.palette[0],
        ),
        sectionTitle('Installation', context),
        _StepCard(
          step: '1',
          title: 'Installer le SDK OpenAI',
          content: 'pip install openai',
          color: context.palette[1],
        ),
        sectionTitle('Configuration', context),
        _StepCard(
          step: '2',
          title: 'Configurer le client DeepSeek',
          content: '''from openai import OpenAI

client = OpenAI(
    api_key="sk-...",
    base_url="https://api.deepseek.com"
)''',
          color: context.palette[2],
        ),
        sectionTitle('Test rapide', context),
        _StepCard(
          step: '3',
          title: 'Premier appel API',
          content: '''response = client.chat.completions.create(
    model="deepseek-chat",
    messages=[
        {"role": "system", "content": "Tu es un assistant IA DeepSeek."},
        {"role": "user", "content": "Explique l'IA en 3 lignes"},
    ],
    max_tokens=2048,
)
print(response.choices[0].message.content)''',
          color: context.palette[3],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: context.tipBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.tipBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lightbulb_outline, color: context.accentLight, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'L\'API DeepSeek est compatible OpenAI : utilisez le SDK openai en changeant simplement la base_url vers https://api.deepseek.com.',
                  style: TextStyle(color: context.tipText, height: 1.5),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _NodeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        sectionTitle('Prérequis', context),
        _StepCard(
          step: '0',
          title: 'Node.js 18+',
          content: 'node --version\n# v18 ou supérieur requis',
          color: context.palette[0],
        ),
        sectionTitle('Installation', context),
        _StepCard(
          step: '1',
          title: 'Installer le SDK OpenAI JS',
          content: 'npm install openai',
          color: context.palette[1],
        ),
        sectionTitle('Configuration', context),
        _StepCard(
          step: '2',
          title: 'Configurer le client DeepSeek',
          content: '''import OpenAI from 'openai';

const client = new OpenAI({
  apiKey: 'sk-...',
  baseURL: 'https://api.deepseek.com'
});''',
          color: context.palette[2],
        ),
        sectionTitle('Test rapide', context),
        _StepCard(
          step: '3',
          title: 'Premier appel API',
          content: '''const response = await client.chat.completions.create({
  model: 'deepseek-chat',
  messages: [
    { role: 'system', content: 'Tu es un assistant IA DeepSeek.' },
    { role: 'user', content: "Explique l'IA en 3 lignes" },
  ],
  max_tokens: 2048,
});
console.log(response.choices[0].message.content);''',
          color: context.palette[3],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: context.tipBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.tipBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lightbulb_outline, color: context.accentLight, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'La compatibilité OpenAI permet de migrer facilement un projet existant vers DeepSeek en modifiant uniquement la baseURL et la clé API.',
                  style: TextStyle(color: context.tipText, height: 1.5),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _StepCard extends StatelessWidget {
  final String step;
  final String title;
  final String content;
  final Color color;
  const _StepCard(
      {required this.step, required this.title, required this.content, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Center(
                  child: Text(step,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title,
                    style: TextStyle(
                        color: color, fontWeight: FontWeight.w600, fontSize: 15)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          CodeBlock(code: content),
        ],
      ),
    );
  }
}
