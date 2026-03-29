import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../app_theme.dart';

const _playgroundModels = [
  'deepseek-chat',
  'deepseek-reasoner',
];

class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({super.key});
  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  final _messageController = TextEditingController();
  final _systemController = TextEditingController(
      text:
          'Tu es un assistant IA développé par DeepSeek. Tu réponds de façon claire, concise et utile.');
  final _scrollController = ScrollController();

  String _selectedModel = 'deepseek-chat';
  double _temperature = 0.7;
  int _maxTokens = 1024;
  double _topP = 1.0;
  bool _showRawJson = false;
  bool _showSystemPrompt = false;
  bool _showReasoning = false;

  bool _isLoading = false;
  String _response = '';
  String _reasoning = '';
  String _rawJson = '';
  int _promptTokens = 0;
  int _completionTokens = 0;
  int _totalTokens = 0;
  int _latencyMs = 0;

  static const _prefKey = 'deepseek_api_key';
  static const _storage = FlutterSecureStorage();
  String _apiKey = '';

  @override
  void initState() {
    super.initState();
    _loadKey();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _systemController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadKey() async {
    final saved = await _storage.read(key: _prefKey) ?? '';
    if (mounted) setState(() => _apiKey = saved);
  }

  Future<void> _send() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isLoading) return;
    if (_apiKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Clé API manquante — configurez-la dans Chat DeepSeek'),
        backgroundColor: context.accentMid,
      ));
      return;
    }

    setState(() {
      _isLoading = true;
      _response = '';
      _reasoning = '';
      _rawJson = '';
      _promptTokens = 0;
      _completionTokens = 0;
      _totalTokens = 0;
      _latencyMs = 0;
    });

    final start = DateTime.now();

    try {
      final body = {
        'model': _selectedModel,
        'max_tokens': _maxTokens,
        'temperature': _temperature,
        'top_p': _topP,
        'messages': [
          {'role': 'system', 'content': _systemController.text.trim()},
          {'role': 'user', 'content': text},
        ],
      };

      final response = await http
          .post(
            Uri.parse('https://api.deepseek.com/v1/chat/completions'),
            headers: {
              'Authorization': 'Bearer $_apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 90));

      final elapsed = DateTime.now().difference(start).inMilliseconds;

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final message = data['choices'][0]['message'];
        final reply = message['content'] as String;
        final reasoningContent = message['reasoning_content'] as String? ?? '';
        final usage = data['usage'] as Map<String, dynamic>?;

        setState(() {
          _response = reply;
          _reasoning = reasoningContent;
          _rawJson = const JsonEncoder.withIndent('  ').convert(data);
          _promptTokens = usage?['prompt_tokens'] as int? ?? 0;
          _completionTokens = usage?['completion_tokens'] as int? ?? 0;
          _totalTokens = usage?['total_tokens'] as int? ?? 0;
          _latencyMs = elapsed;
          _isLoading = false;
        });
      } else {
        final err = jsonDecode(response.body);
        final msg = err['error']?['message'] ?? 'Erreur ${response.statusCode}';
        setState(() {
          _response = 'Erreur : $msg';
          _rawJson = const JsonEncoder.withIndent('  ')
              .convert(jsonDecode(response.body));
          _latencyMs = elapsed;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _response = 'Erreur réseau : $e';
        _isLoading = false;
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, _, child) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      children: [
        const _InfoCard(),
        const SizedBox(height: 20),

        // Model selector
        _SectionLabel(label: 'Modèle'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _playgroundModels
              .map((m) => ChoiceChip(
                    label: Text(m,
                        style: const TextStyle(
                            fontSize: 11, fontFamily: 'monospace')),
                    selected: _selectedModel == m,
                    onSelected: (_) => setState(() => _selectedModel = m),
                    selectedColor: context.accentMid.withValues(alpha: 0.3),
                    labelStyle: TextStyle(
                        color: _selectedModel == m
                            ? context.accentLight
                            : context.onSurface.withValues(alpha: 0.6)),
                    side: BorderSide(
                        color: _selectedModel == m
                            ? context.accentLight
                            : context.codeBorder),
                  ))
              .toList(),
        ),
        const SizedBox(height: 16),

        // Parameters
        _SectionLabel(label: 'Paramètres'),
        _SliderRow(
          label: 'Temperature',
          value: _temperature,
          displayValue: _temperature.toStringAsFixed(2),
          min: 0.0,
          max: 2.0,
          divisions: 20,
          onChanged: (v) => setState(() => _temperature = v),
          accentLight: context.accentLight,
          accentMid: context.accentMid,
          onSurface: context.onSurface,
        ),
        _SliderRow(
          label: 'Top P',
          value: _topP,
          displayValue: _topP.toStringAsFixed(2),
          min: 0.0,
          max: 1.0,
          divisions: 20,
          onChanged: (v) => setState(() => _topP = v),
          accentLight: context.accentLight,
          accentMid: context.accentMid,
          onSurface: context.onSurface,
        ),
        _SliderRow(
          label: 'Max Tokens',
          value: _maxTokens.toDouble(),
          displayValue: '$_maxTokens',
          min: 128,
          max: 8192,
          divisions: 32,
          onChanged: (v) => setState(() => _maxTokens = v.round()),
          accentLight: context.accentLight,
          accentMid: context.accentMid,
          onSurface: context.onSurface,
        ),
        const SizedBox(height: 16),

        // System prompt (collapsible)
        GestureDetector(
          onTap: () => setState(() => _showSystemPrompt = !_showSystemPrompt),
          child: Row(
            children: [
              Text('Prompt système',
                  style: TextStyle(
                      color: context.accentLight,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
              const SizedBox(width: 6),
              Icon(
                  _showSystemPrompt ? Icons.expand_less : Icons.expand_more,
                  color: context.accentMid,
                  size: 18),
            ],
          ),
        ),
        if (_showSystemPrompt) ...[
          const SizedBox(height: 8),
          TextField(
            controller: _systemController,
            maxLines: 4,
            style: TextStyle(
                color: context.onSurface,
                fontSize: 13,
                fontFamily: 'monospace'),
            decoration: InputDecoration(
              filled: true,
              fillColor: context.codeBg,
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: context.codeBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: context.codeBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: context.accentLight),
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),

        // Message input
        _SectionLabel(label: 'Message'),
        TextField(
          controller: _messageController,
          maxLines: 5,
          minLines: 3,
          style: TextStyle(color: context.onSurface, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Écrivez votre message ici...',
            hintStyle:
                TextStyle(color: context.onSurface.withValues(alpha: 0.4)),
            filled: true,
            fillColor: context.cardBg,
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.codeBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.codeBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.accentLight),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Send button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _send,
            icon: _isLoading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white.withValues(alpha: 0.7)),
                  )
                : const Icon(Icons.send_rounded, size: 18),
            label: Text(_isLoading ? 'En cours...' : 'Envoyer',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.accentMid,
              foregroundColor: Colors.white,
              disabledBackgroundColor:
                  context.accentMid.withValues(alpha: 0.4),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Response
        if (_response.isNotEmpty) ...[
          // Reasoning section (only for deepseek-reasoner)
          if (_reasoning.isNotEmpty) ...[
            GestureDetector(
              onTap: () => setState(() => _showReasoning = !_showReasoning),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.surfaceBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: context.codeBorder),
                ),
                child: Row(
                  children: [
                    Icon(Icons.psychology_outlined,
                        color: context.accentMid, size: 16),
                    const SizedBox(width: 8),
                    Text('Raisonnement (Chain-of-Thought)',
                        style: TextStyle(
                            color: context.onSurface.withValues(alpha: 0.6),
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Icon(
                        _showReasoning
                            ? Icons.expand_less
                            : Icons.expand_more,
                        color: context.onSurface.withValues(alpha: 0.4),
                        size: 16),
                  ],
                ),
              ),
            ),
            if (_showReasoning) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.surfaceBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: context.codeBorder),
                ),
                child: SelectableText(
                  _reasoning,
                  style: TextStyle(
                    color: context.onSurface.withValues(alpha: 0.5),
                    fontSize: 12,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Text('Réponse',
                  style: TextStyle(
                      color: context.accentLight,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
              const Spacer(),
              if (_totalTokens > 0)
                Text('$_totalTokens tokens · ${_latencyMs}ms',
                    style: TextStyle(
                        color: context.accentMid,
                        fontSize: 11,
                        fontFamily: 'monospace')),
            ],
          ),
          if (_totalTokens > 0) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                _TokenBadge(
                    label: 'prompt',
                    value: _promptTokens,
                    color: context.accentMid),
                const SizedBox(width: 8),
                _TokenBadge(
                    label: 'completion',
                    value: _completionTokens,
                    color: context.accentLight),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.codeBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('JSON brut',
                            style: TextStyle(
                                color: context.onSurface.withValues(alpha: 0.5),
                                fontSize: 11)),
                        const SizedBox(width: 6),
                        Switch(
                          value: _showRawJson,
                          onChanged: (v) => setState(() => _showRawJson = v),
                          activeThumbColor: context.accentLight,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.copy,
                          size: 16, color: context.accentMid),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(
                            text: _showRawJson ? _rawJson : _response));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Copié !'),
                              duration: Duration(seconds: 1)),
                        );
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SelectableText(
                  _showRawJson ? _rawJson : _response,
                  style: TextStyle(
                    color: context.onSurface,
                    fontSize: _showRawJson ? 11 : 14,
                    fontFamily: _showRawJson ? 'monospace' : null,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label,
          style: TextStyle(
              color: context.accentLight,
              fontWeight: FontWeight.w600,
              fontSize: 13)),
    );
  }
}

class _SliderRow extends StatelessWidget {
  final String label;
  final double value;
  final String displayValue;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;
  final Color accentLight;
  final Color accentMid;
  final Color onSurface;

  const _SliderRow({
    required this.label,
    required this.value,
    required this.displayValue,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
    required this.accentLight,
    required this.accentMid,
    required this.onSurface,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(label,
              style: TextStyle(
                  color: onSurface.withValues(alpha: 0.7), fontSize: 12)),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
            activeColor: accentLight,
          ),
        ),
        SizedBox(
          width: 48,
          child: Text(displayValue,
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: accentMid, fontFamily: 'monospace', fontSize: 12)),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard();

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.tune, 'Ajustez les paramètres',
          'Temperature contrôle la créativité (0 = déterministe, 2 = très créatif). Top P filtre le vocabulaire utilisé. Max Tokens limite la longueur de la réponse.'),
      (Icons.model_training, 'Choisissez le bon modèle',
          'deepseek-chat (V3) pour les réponses de chat générales. deepseek-reasoner (R1) pour les problèmes complexes avec raisonnement visible (Chain-of-Thought).'),
      (Icons.bolt, 'Pourquoi ce playground ?',
          'Testez en direct l\'impact de chaque paramètre sur les réponses de l\'API DeepSeek, sans écrire de code. Idéal pour calibrer vos prompts avant intégration.'),
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
                child: Icon(Icons.science_outlined,
                    color: context.accentLight, size: 18),
              ),
              const SizedBox(width: 10),
              Text('Comment utiliser le Playground',
                  style: TextStyle(
                      color: context.accentLight,
                      fontWeight: FontWeight.w700,
                      fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(item.$1, color: context.accentMid, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.$2,
                              style: TextStyle(
                                  color: context.onSurface,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12)),
                          const SizedBox(height: 2),
                          Text(item.$3,
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

class _TokenBadge extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _TokenBadge(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text('$label: $value',
          style: TextStyle(
              color: color, fontSize: 10, fontFamily: 'monospace')),
    );
  }
}
