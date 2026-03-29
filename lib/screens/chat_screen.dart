import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_theme.dart';

const _deepseekModels = [
  'deepseek-chat',
  'deepseek-reasoner',
];

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _inputController = TextEditingController();
  final _keyController = TextEditingController();
  final _scrollController = ScrollController();

  String _apiKey = '';
  bool _isLoading = false;
  bool _showKeySetup = true;
  String _selectedModel = 'deepseek-chat';
  double _temperature = 0.7;
  int _maxTokens = 2048;

  final List<_Msg> _display = [];
  final List<Map<String, dynamic>> _history = [];

  List<_SavedConversation> _savedConversations = [];

  static const _prefKey = 'deepseek_api_key';
  static const _convKey = 'deepseek_conversations';
  static const _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadKey();
    _loadConversations();
    pendingPromptNotifier.addListener(_onPendingPrompt);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _keyController.dispose();
    _scrollController.dispose();
    pendingPromptNotifier.removeListener(_onPendingPrompt);
    super.dispose();
  }

  void _onPendingPrompt() {
    final prompt = pendingPromptNotifier.value;
    if (prompt != null) {
      _inputController.text = prompt;
      pendingPromptNotifier.value = null;
    }
  }

  Future<void> _loadKey() async {
    final saved = await _storage.read(key: _prefKey) ?? '';
    if (saved.isNotEmpty) {
      setState(() {
        _apiKey = saved;
        _showKeySetup = false;
      });
    }
  }

  Future<void> _saveKey(String key) async {
    await _storage.write(key: _prefKey, value: key.trim());
    setState(() {
      _apiKey = key.trim();
      _showKeySetup = false;
    });
  }

  Future<void> _loadConversations() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_convKey);
    if (json != null) {
      final list = jsonDecode(json) as List;
      if (mounted) {
        setState(() {
          _savedConversations =
              list.map((e) => _SavedConversation.fromJson(e as Map<String, dynamic>)).toList();
        });
      }
    }
  }

  Future<void> _saveCurrentConversation() async {
    if (_history.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();

    final textMessages = _history.map((m) {
      final content = m['content'];
      String textContent;
      if (content is List) {
        final texts = content
            .whereType<Map>()
            .where((c) => c['type'] == 'text')
            .map((c) => c['text'] as String)
            .join('');
        textContent = texts.isEmpty ? '[Message]' : texts;
      } else {
        textContent = content as String;
      }
      return {'role': m['role'] as String, 'content': textContent};
    }).toList();

    final firstMsg = textMessages.first['content'] ?? '';
    final title = firstMsg.length > 45 ? '${firstMsg.substring(0, 45)}...' : firstMsg;

    final conv = _SavedConversation(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      model: _selectedModel,
      timestamp: DateTime.now().toIso8601String(),
      messages: textMessages,
    );

    final updated = [conv, ..._savedConversations.take(19)];
    if (mounted) setState(() => _savedConversations = updated);
    await prefs.setString(_convKey, jsonEncode(updated.map((c) => c.toJson()).toList()));
  }

  void _scrollToBottom() {
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

  Future<void> _sendMessage() async {
    final text = _inputController.text.trim();
    if (text.isEmpty || _isLoading) return;
    _inputController.clear();

    _history.add({'role': 'user', 'content': text});

    setState(() {
      _display.add(_Msg(role: 'user', content: text));
      _display.add(_Msg(role: 'assistant', content: '', isTyping: true));
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final response = await http
          .post(
            Uri.parse('https://api.deepseek.com/v1/chat/completions'),
            headers: {
              'Authorization': 'Bearer $_apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'model': _selectedModel,
              'max_tokens': _maxTokens,
              'temperature': _temperature,
              'messages': [
                {
                  'role': 'system',
                  'content':
                      'Tu es un assistant IA développé par DeepSeek. Tu réponds de façon claire, concise et utile.',
                },
                ..._history,
              ],
            }),
          )
          .timeout(const Duration(seconds: 90));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final message = data['choices'][0]['message'];
        final reply = message['content'] as String;
        final reasoningContent = message['reasoning_content'] as String?;

        _history.add({'role': 'assistant', 'content': reply});
        setState(() {
          _display.removeLast();
          _display.add(_Msg(
            role: 'assistant',
            content: reply,
            reasoningContent: reasoningContent,
          ));
          _isLoading = false;
        });
        _saveCurrentConversation();
      } else {
        final err = jsonDecode(response.body);
        final msg = err['error']?['message'] ?? 'Erreur ${response.statusCode}';
        _history.removeLast();
        setState(() {
          _display.removeLast();
          _display.add(_Msg(role: 'error', content: msg));
          _isLoading = false;
        });
      }
    } catch (e) {
      _history.removeLast();
      setState(() {
        _display.removeLast();
        _display.add(_Msg(role: 'error', content: 'Erreur réseau : $e'));
        _isLoading = false;
      });
    }
    _scrollToBottom();
  }

  void _exportConversation() {
    if (_display.isEmpty) return;
    final sb = StringBuffer();
    sb.writeln('Conversation DeepSeek ($_selectedModel)');
    sb.writeln('Exportée le ${DateTime.now().toString().substring(0, 16)}');
    sb.writeln('─' * 40);
    for (final msg in _display) {
      if (msg.isTyping) continue;
      final role = msg.role == 'user'
          ? 'Vous'
          : msg.role == 'assistant'
              ? 'DeepSeek'
              : 'Erreur';
      sb.writeln('\n[$role]');
      if (msg.content.isNotEmpty) sb.writeln(msg.content);
    }
    Share.share(sb.toString(), subject: 'Conversation DeepSeek');
  }

  void _showHistorySheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 8, 12),
            child: Row(
              children: [
                Text('Historique',
                    style: TextStyle(
                        color: ctx.accentLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                const Spacer(),
                if (_savedConversations.isNotEmpty)
                  TextButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove(_convKey);
                      if (mounted) setState(() => _savedConversations = []);
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                    child: Text('Tout effacer',
                        style:
                            TextStyle(color: Colors.red.withValues(alpha: 0.7), fontSize: 12)),
                  ),
              ],
            ),
          ),
          Divider(height: 1, color: ctx.drawerDivider),
          if (_savedConversations.isEmpty)
            Expanded(
              child: Center(
                child: Text('Aucune conversation sauvegardée',
                    style: TextStyle(color: ctx.onSurface.withValues(alpha: 0.4))),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _savedConversations.length,
                itemBuilder: (ctx2, i) {
                  final conv = _savedConversations[i];
                  return ListTile(
                    leading:
                        Icon(Icons.chat_bubble_outline, color: ctx2.accentMid, size: 20),
                    title: Text(conv.title,
                        style: TextStyle(color: ctx2.onSurface, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    subtitle: Text(
                        '${conv.model} · ${conv.timestamp.substring(0, 10)}',
                        style: TextStyle(
                            color: ctx2.onSurface.withValues(alpha: 0.5), fontSize: 11)),
                    onTap: () {
                      Navigator.pop(ctx2);
                      _loadConversation(conv);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void _loadConversation(_SavedConversation conv) {
    setState(() {
      _display.clear();
      _history.clear();
      _selectedModel = conv.model;
      for (final m in conv.messages) {
        _display.add(_Msg(role: m['role']!, content: m['content']!));
        _history.add({'role': m['role']!, 'content': m['content']!});
      }
    });
    _scrollToBottom();
  }

  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Paramètres',
                  style: TextStyle(
                      color: ctx.accentLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              const SizedBox(height: 20),
              Text('Modèle',
                  style: TextStyle(
                      color: ctx.accentLight,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _deepseekModels
                    .map((m) => ChoiceChip(
                          label: Text(m,
                              style: const TextStyle(
                                  fontSize: 11, fontFamily: 'monospace')),
                          selected: _selectedModel == m,
                          onSelected: (_) {
                            setSheet(() {});
                            setState(() => _selectedModel = m);
                          },
                          selectedColor: ctx.accentMid.withValues(alpha: 0.3),
                          labelStyle: TextStyle(
                              color: _selectedModel == m
                                  ? ctx.accentLight
                                  : ctx.onSurface.withValues(alpha: 0.6)),
                          side: BorderSide(
                              color: _selectedModel == m
                                  ? ctx.accentLight
                                  : ctx.codeBorder),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Temperature',
                      style: TextStyle(
                          color: ctx.accentLight,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                  Text(_temperature.toStringAsFixed(2),
                      style: TextStyle(
                          color: ctx.accentMid,
                          fontFamily: 'monospace',
                          fontSize: 13)),
                ],
              ),
              Slider(
                value: _temperature,
                min: 0.0,
                max: 2.0,
                divisions: 20,
                onChanged: (v) {
                  setSheet(() {});
                  setState(() => _temperature = v);
                },
                activeColor: ctx.accentLight,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Max Tokens',
                      style: TextStyle(
                          color: ctx.accentLight,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                  Text('$_maxTokens',
                      style: TextStyle(
                          color: ctx.accentMid,
                          fontFamily: 'monospace',
                          fontSize: 13)),
                ],
              ),
              Slider(
                value: _maxTokens.toDouble(),
                min: 128,
                max: 8192,
                divisions: 32,
                onChanged: (v) {
                  setSheet(() {});
                  setState(() => _maxTokens = v.round());
                },
                activeColor: ctx.accentLight,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, _, child) {
        if (_showKeySetup) return _buildKeySetup(context);
        return _buildChat(context);
      },
    );
  }

  Widget _buildKeySetup(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: context.heroGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.chat_bubble_outline, color: Colors.white, size: 36),
                SizedBox(height: 12),
                Text('Chat DeepSeek',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(
                  'Discutez directement avec DeepSeek via l\'API. Supporte les modèles chat et raisonnement (R1 avec Chain-of-Thought visible).',
                  style: TextStyle(color: Colors.white70, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Clé API DeepSeek',
              style: TextStyle(
                  color: context.accentLight,
                  fontWeight: FontWeight.w600,
                  fontSize: 15)),
          const SizedBox(height: 8),
          TextField(
            controller: _keyController,
            obscureText: true,
            style: TextStyle(
                fontFamily: 'monospace', fontSize: 13, color: context.onSurface),
            decoration: InputDecoration(
              hintText: 'sk-...',
              hintStyle: TextStyle(color: context.onSurface.withValues(alpha: 0.3)),
              filled: true,
              fillColor: context.cardBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: context.accentMid.withValues(alpha: 0.4)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: context.accentMid.withValues(alpha: 0.4)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: context.accentLight),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_keyController.text.trim().isNotEmpty) {
                  _saveKey(_keyController.text.trim());
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.accentMid,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Valider',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.tipBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.tipBorder),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lock_outline, color: context.accentLight, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Votre clé est stockée localement (Android Keystore / iOS Keychain). Elle n\'est jamais envoyée à un serveur tiers.',
                    style: TextStyle(
                        color: context.tipText, fontSize: 12, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChat(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          color: context.cardBg,
          child: Row(
            children: [
              GestureDetector(
                onTap: _showSettingsSheet,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.accentMid.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_selectedModel,
                          style: TextStyle(
                              color: context.accentLight,
                              fontSize: 11,
                              fontFamily: 'monospace')),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_drop_down,
                          color: context.accentLight, size: 16),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              if (_display.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.share_outlined,
                      color: context.accentLight, size: 20),
                  onPressed: _exportConversation,
                  tooltip: 'Exporter',
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(),
                ),
              const SizedBox(width: 4),
              IconButton(
                icon: Icon(Icons.history, color: context.accentLight, size: 20),
                onPressed: _showHistorySheet,
                tooltip: 'Historique',
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: Icon(Icons.add_comment_outlined,
                    color: context.accentLight, size: 20),
                onPressed: () => setState(() {
                  _display.clear();
                  _history.clear();
                }),
                tooltip: 'Nouvelle conversation',
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: Icon(Icons.key_outlined,
                    color: context.accentLight, size: 20),
                onPressed: () => setState(() => _showKeySetup = true),
                tooltip: 'Changer la clé API',
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
        // Messages
        Expanded(
          child: _display.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: _display.length,
                  itemBuilder: (context, i) => _buildMessage(context, _display[i]),
                ),
        ),
        // Input
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.cardBg,
            border: Border(top: BorderSide(color: context.drawerDivider)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _inputController,
                  maxLines: 4,
                  minLines: 1,
                  style: TextStyle(color: context.onSurface),
                  decoration: InputDecoration(
                    hintText: 'Message à DeepSeek...',
                    hintStyle: TextStyle(
                        color: context.onSurface.withValues(alpha: 0.4)),
                    filled: true,
                    fillColor: context.surfaceBg,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _isLoading ? null : _sendMessage,
                icon: Icon(
                  Icons.send_rounded,
                  color: _isLoading
                      ? context.accentMid.withValues(alpha: 0.3)
                      : context.accentLight,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: context.accentMid.withValues(alpha: 0.2),
                  padding: const EdgeInsets.all(10),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.psychology_outlined,
              color: context.accentMid.withValues(alpha: 0.3), size: 60),
          const SizedBox(height: 12),
          Text('Commencez la conversation',
              style: TextStyle(color: context.onSurface.withValues(alpha: 0.3))),
          const SizedBox(height: 6),
          Text(_selectedModel,
              style: TextStyle(
                  color: context.accentMid.withValues(alpha: 0.4),
                  fontSize: 11,
                  fontFamily: 'monospace')),
        ],
      ),
    );
  }

  Widget _buildMessage(BuildContext context, _Msg msg) {
    if (msg.isTyping) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8, right: 60),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: context.cardBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const _TypingIndicator(),
        ),
      );
    }

    if (msg.role == 'error') {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 16),
            const SizedBox(width: 8),
            Expanded(
                child: Text(msg.content,
                    style: const TextStyle(color: Colors.red, fontSize: 13))),
          ],
        ),
      );
    }

    final isUser = msg.role == 'user';

    if (!isUser && msg.reasoningContent != null && msg.reasoningContent!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ReasoningPanel(reasoning: msg.reasoningContent!),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: msg.content));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Message copié'),
                  duration: Duration(seconds: 1),
                ));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 8, right: 60),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: context.cardBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SelectableText(
                  msg.content,
                  style: TextStyle(
                    color: context.onSurface,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () {
          Clipboard.setData(ClipboardData(text: msg.content));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Message copié'),
            duration: Duration(seconds: 1),
          ));
        },
        child: Container(
          margin: EdgeInsets.only(
              bottom: 8, left: isUser ? 60 : 0, right: isUser ? 0 : 60),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient: isUser
                ? LinearGradient(
                    colors: context.heroGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isUser ? null : context.cardBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SelectableText(
            msg.content,
            style: TextStyle(
              color: isUser ? Colors.white : context.onSurface,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _ReasoningPanel extends StatefulWidget {
  final String reasoning;
  const _ReasoningPanel({required this.reasoning});
  @override
  State<_ReasoningPanel> createState() => _ReasoningPanelState();
}

class _ReasoningPanelState extends State<_ReasoningPanel> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6, right: 60),
      decoration: BoxDecoration(
        color: context.surfaceBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.codeBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.psychology_outlined,
                      color: context.accentMid, size: 16),
                  const SizedBox(width: 8),
                  Text('Raisonnement',
                      style: TextStyle(
                          color: context.onSurface.withValues(alpha: 0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      color: context.onSurface.withValues(alpha: 0.4),
                      size: 16),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: SelectableText(
                widget.reasoning,
                style: TextStyle(
                  color: context.onSurface.withValues(alpha: 0.5),
                  fontSize: 12,
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Msg {
  final String role;
  final String content;
  final bool isTyping;
  final String? reasoningContent;
  const _Msg({
    required this.role,
    required this.content,
    this.isTyping = false,
    this.reasoningContent,
  });
}

class _SavedConversation {
  final int id;
  final String title;
  final String model;
  final String timestamp;
  final List<Map<String, String>> messages;

  const _SavedConversation({
    required this.id,
    required this.title,
    required this.model,
    required this.timestamp,
    required this.messages,
  });

  factory _SavedConversation.fromJson(Map<String, dynamic> json) =>
      _SavedConversation(
        id: json['id'] as int,
        title: json['title'] as String,
        model: json['model'] as String,
        timestamp: json['timestamp'] as String,
        messages: (json['messages'] as List)
            .map((m) => Map<String, String>.from(m as Map))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'model': model,
        'timestamp': timestamp,
        'messages': messages,
      };
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final phase = (_ctrl.value - i * 0.15).clamp(0.0, 1.0);
            final opacity =
                (phase < 0.5 ? phase * 2 : (1 - phase) * 2).clamp(0.3, 1.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: context.accentLight.withValues(alpha: opacity),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
