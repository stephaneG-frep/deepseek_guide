import 'package:flutter/material.dart';
import '../app_theme.dart';

class ApiScreen extends StatefulWidget {
  const ApiScreen({super.key});
  @override
  State<ApiScreen> createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> with SingleTickerProviderStateMixin {
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
              tabs: const [Tab(text: 'Python'), Tab(text: 'cURL')],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_PythonExamples(), _CurlExamples()],
            ),
          ),
        ],
      ),
    );
  }
}

class _PythonExamples extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _sectionLabel('Appel simple (deepseek-chat)', context),
        const CodeBlock(
          title: 'Python — deepseek-chat',
          code: '''from openai import OpenAI

client = OpenAI(
    api_key="sk-...",
    base_url="https://api.deepseek.com"
)

response = client.chat.completions.create(
    model="deepseek-chat",
    messages=[{"role": "user", "content": "Explique le machine learning"}],
)
print(response.choices[0].message.content)''',
        ),
        _sectionLabel('Raisonnement (deepseek-reasoner)', context),
        const CodeBlock(
          title: 'Python — deepseek-reasoner (R1)',
          code: '''response = client.chat.completions.create(
    model="deepseek-reasoner",
    messages=[{"role": "user", "content": "Résous : si 2x + 5 = 13, trouve x"}],
)

# Le modèle R1 retourne un raisonnement step-by-step
reasoning = response.choices[0].message.reasoning_content
answer = response.choices[0].message.content

print("=== Raisonnement ===")
print(reasoning)
print("=== Réponse finale ===")
print(answer)''',
        ),
        _sectionLabel('Streaming', context),
        const CodeBlock(
          title: 'Python — Streaming',
          code: r'''stream = client.chat.completions.create(
    model="deepseek-chat",
    messages=[{"role": "user", "content": "Écris un poème sur l'espace"}],
    stream=True,
)

for chunk in stream:
    if chunk.choices[0].delta.content:
        print(chunk.choices[0].delta.content, end="", flush=True)''',
        ),
        _sectionLabel('Accès aux tokens de raisonnement', context),
        const CodeBlock(
          title: 'Python — Tokens de raisonnement R1',
          code: '''response = client.chat.completions.create(
    model="deepseek-reasoner",
    messages=[
        {"role": "system", "content": "Tu es un expert en mathématiques."},
        {"role": "user", "content": "Prouve que sqrt(2) est irrationnel"},
    ],
)

msg = response.choices[0].message

# reasoning_content contient la chaîne de pensée (CoT)
if hasattr(msg, "reasoning_content") and msg.reasoning_content:
    print("Raisonnement:", msg.reasoning_content[:500], "...")

# content contient la réponse finale condensée
print("Réponse:", msg.content)

# Tokens utilisés (inclut les tokens de raisonnement)
usage = response.usage
print(f"Tokens: prompt={usage.prompt_tokens}, "
      f"completion={usage.completion_tokens}, "
      f"total={usage.total_tokens}")''',
        ),
      ],
    );
  }
}

class _CurlExamples extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _sectionLabel('Appel simple (deepseek-chat)', context),
        const CodeBlock(
          title: 'cURL — deepseek-chat',
          code: r'''curl -X POST https://api.deepseek.com/v1/chat/completions \
  -H "Authorization: Bearer sk-..." \
  -H "Content-Type: application/json" \
  -d '{
    "model": "deepseek-chat",
    "messages": [
      {"role": "user", "content": "Explique le machine learning"}
    ],
    "max_tokens": 2048
  }'
''',
        ),
        _sectionLabel('Raisonnement (deepseek-reasoner)', context),
        const CodeBlock(
          title: 'cURL — deepseek-reasoner (R1)',
          code: r'''curl -X POST https://api.deepseek.com/v1/chat/completions \
  -H "Authorization: Bearer sk-..." \
  -H "Content-Type: application/json" \
  -d '{
    "model": "deepseek-reasoner",
    "messages": [
      {"role": "user", "content": "Résous: si 2x + 5 = 13, trouve x"}
    ]
  }'

# La réponse contient :
# choices[0].message.reasoning_content -> chaîne de pensée
# choices[0].message.content           -> réponse finale
''',
        ),
        _sectionLabel('Streaming', context),
        const CodeBlock(
          title: 'cURL — Streaming',
          code: r'''curl -X POST https://api.deepseek.com/v1/chat/completions \
  -H "Authorization: Bearer sk-..." \
  -H "Content-Type: application/json" \
  -d '{
    "model": "deepseek-chat",
    "messages": [
      {"role": "user", "content": "Explique les réseaux de neurones"}
    ],
    "stream": true
  }'
''',
        ),
        _sectionLabel('Avec prompt système', context),
        const CodeBlock(
          title: 'cURL — System prompt',
          code: r'''curl -X POST https://api.deepseek.com/v1/chat/completions \
  -H "Authorization: Bearer sk-..." \
  -H "Content-Type: application/json" \
  -d '{
    "model": "deepseek-chat",
    "messages": [
      {
        "role": "system",
        "content": "Tu es un expert Python. Réponds avec des exemples de code."
      },
      {
        "role": "user",
        "content": "Comment lire un fichier CSV ?"
      }
    ],
    "temperature": 0.7,
    "max_tokens": 1024
  }'
''',
        ),
      ],
    );
  }
}

Widget _sectionLabel(String text, BuildContext context) => Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(text,
          style: TextStyle(
              color: context.accentLight, fontSize: 14, fontWeight: FontWeight.w600)),
    );
