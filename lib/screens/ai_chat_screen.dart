import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../providers/ai_chat_provider.dart';
import '../widgets/neon_card.dart';
import '../widgets/custom_button.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _apiKeyController = TextEditingController();
  bool _showApiKeyVisibility = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _apiKeyController.dispose();
    super.dispose();
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

  void _showEditApiKeyDialog(BuildContext context, String currentKey) {
    _apiKeyController.text = currentKey == 'builtin' ? '' : currentKey;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? AppColors.textWhite : AppColors.lightTextPrimary;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'AI Coach Settings',
            style: TextStyle(color: primaryText, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Option 1: Google Gemini API Key',
                style: TextStyle(color: primaryText, fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _apiKeyController,
                style: TextStyle(color: primaryText),
                decoration: InputDecoration(
                  hintText: 'AIzaSy...',
                  hintStyle: const TextStyle(color: AppColors.textMuted),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.neonGreen),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Option 2: Error-Free Built-in AI Coach',
                style: TextStyle(color: primaryText, fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Bina kisi key ya account ke instant offline fitness expert coach use karein.',
                style: TextStyle(color: isDark ? AppColors.textGrey : AppColors.lightTextSecondary, fontSize: 12),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.bolt_rounded, color: AppColors.neonGreen, size: 18),
                  label: const Text('Use Free Built-in Coach', style: TextStyle(color: AppColors.neonGreen, fontSize: 12, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.neonGreen),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    context.read<AiChatProvider>().enableBuiltInCoach();
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Switched to Free Built-in AI Coach!')),
                    );
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textGrey)),
            ),
            TextButton(
              onPressed: () {
                final key = _apiKeyController.text.trim();
                if (key.isNotEmpty) {
                  context.read<AiChatProvider>().updateApiKey(key);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gemini API Key saved!')),
                  );
                }
                Navigator.pop(ctx);
              },
              child: const Text('Save Key', style: TextStyle(color: AppColors.neonGreen, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildApiKeySetup(AiChatProvider provider, bool isDark, Color primaryText, Color secondaryText) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.neonGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: AppColors.neonGreen,
              size: 48,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'FitTrack AI Coach',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryText),
          ),
          const SizedBox(height: 8),
          Text(
            'Apna personal fitness aur nutrition expert setup karein!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: secondaryText),
          ),
          const SizedBox(height: 32),
          NeonCard(
            padding: const EdgeInsets.all(20),
            hasNeonBorder: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gemini API Key Required',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryText),
                ),
                const SizedBox(height: 10),
                Text(
                  'Is app me AI capabilities add karne ke liye hum Google Gemini free API use kar rahe hain. Aap 1 minute me apni personal API key le sakte hain:',
                  style: TextStyle(fontSize: 13, color: secondaryText, height: 1.4),
                ),
                const SizedBox(height: 12),
                Text(
                  '1. AI Studio website open karein:\n   https://aistudio.google.com/\n2. Sign in karein aur "Get API Key" button par click karein.\n3. Key copy karke niche paste karein.',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.neonGreenLight : AppColors.neonGreenDark,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _apiKeyController,
                  obscureText: !_showApiKeyVisibility,
                  style: TextStyle(color: primaryText, fontSize: 14),
                  decoration: InputDecoration(
                    labelText: 'Gemini API Key',
                    labelStyle: TextStyle(color: secondaryText),
                    hintText: 'Paste key here (starts with AIza...)',
                    hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.neonGreen, width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showApiKeyVisibility ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                        color: secondaryText,
                      ),
                      onPressed: () {
                        setState(() {
                          _showApiKeyVisibility = !_showApiKeyVisibility;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: '⚡ Continue with Free AI Coach (Instant)',
                  onPressed: () {
                    provider.enableBuiltInCoach();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Free AI Coach Activated!')),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    '— OR CONNECT GEMINI API KEY —',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: secondaryText,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                CustomButton(
                  text: 'Save & Initialize Gemini Key',
                  isSecondary: true,
                  onPressed: () {
                    final key = _apiKeyController.text.trim();
                    if (key.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a valid API key or choose Free Coach')),
                      );
                      return;
                    }
                    provider.updateApiKey(key);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('AI Coach successfully initialized!')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormattedMessage(String text, TextStyle baseStyle) {
    final List<TextSpan> spans = [];
    final RegExp regex = RegExp(r'\*\*(.*?)\*\*');
    int start = 0;

    for (final Match match in regex.allMatches(text)) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));
      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: spans,
      ),
    );
  }

  Widget _buildChatInterface(AiChatProvider provider, bool isDark, Color primaryText, Color secondaryText) {
    final messages = provider.messages;

    return Column(
      children: [
        // Message list
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: messages.length + (provider.isLoading ? 1 : 0),
            itemBuilder: (ctx, index) {
              if (index == messages.length) {
                // Loading / typing indicator
                return _buildTypingIndicator(isDark);
              }

              final msg = messages[index];
              return _buildChatBubble(msg, isDark, primaryText, secondaryText);
            },
          ),
        ),

        // Quick suggestions chips (show only if history is just the welcome message)
        if (messages.length == 1) _buildSuggestions(provider),

        // Input bar
        _buildInputBar(provider, isDark),
      ],
    );
  }

  Widget _buildChatBubble(dynamic msg, bool isDark, Color primaryText, Color secondaryText) {
    final isUser = msg.isUser;
    
    // Bubble theme
    final bubbleBg = isUser 
        ? AppColors.neonGreen 
        : (isDark ? AppColors.darkCard : AppColors.lightCardSecondary);
        
    final bubbleTextColor = isUser 
        ? Colors.black 
        : primaryText;

    final align = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final margin = isUser 
        ? const EdgeInsets.only(left: 48, right: 0, bottom: 12) 
        : const EdgeInsets.only(left: 0, right: 48, bottom: 12);
        
    final borderRadius = isUser 
        ? const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(4),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(16),
          );

    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: align,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: bubbleBg,
              borderRadius: borderRadius,
              border: !isUser && isDark 
                  ? Border.all(color: AppColors.darkBorder) 
                  : null,
              boxShadow: isUser 
                  ? [
                      BoxShadow(
                        color: AppColors.neonGreen.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : [],
            ),
            child: _buildFormattedMessage(
              msg.text, 
              TextStyle(
                color: bubbleTextColor, 
                fontSize: 14, 
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              _formatTime(msg.timestamp),
              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(right: 64, bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCardSecondary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(16),
          ),
          border: isDark ? Border.all(color: AppColors.darkBorder) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.neonGreen),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'AI Coach is typing...',
              style: TextStyle(
                color: isDark ? AppColors.textGrey : AppColors.lightTextSecondary,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions(AiChatProvider provider) {
    final suggestions = [
      '🏋️ Home workout splits',
      '🍎 High protein meal ideas',
      '💧 Hydration guidance',
      '📈 Muscle gain tips'
    ];

    return Container(
      height: 38,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: suggestions.length,
        itemBuilder: (context, i) {
          final text = suggestions[i];
          final rawText = text.substring(3); // strip emoji

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              backgroundColor: Theme.of(context).brightness == Brightness.dark 
                  ? AppColors.darkCardSecondary 
                  : AppColors.lightCardSecondary,
              side: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark 
                    ? AppColors.darkBorder 
                    : AppColors.lightBorder,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              label: Text(
                text, 
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                _messageController.text = "Suggest me some $rawText";
                _handleSend(provider);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputBar(AiChatProvider provider, bool isDark) {
    final bg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border(top: BorderSide(color: border, width: 1)),
      ),
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCardSecondary,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: border),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _messageController,
                style: TextStyle(color: isDark ? AppColors.textWhite : AppColors.lightTextPrimary),
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Ask AI Coach...',
                  hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
                onSubmitted: (_) => _handleSend(provider),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _messageController,
            builder: (ctx, val, _) {
              final hasText = val.text.trim().isNotEmpty;
              final canSend = hasText && !provider.isLoading;

              return IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: canSend ? AppColors.neonGreen : AppColors.textMuted.withValues(alpha: 0.2),
                  foregroundColor: canSend ? Colors.black : AppColors.textMuted,
                ),
                onPressed: canSend ? () => _handleSend(provider) : null,
                icon: const Icon(Icons.send_rounded, size: 20),
              );
            },
          ),
        ],
      ),
    );
  }

  void _handleSend(AiChatProvider provider) {
    final text = _messageController.text;
    if (text.trim().isEmpty) return;
    
    _messageController.clear();
    provider.sendMessage(text);
    _scrollToBottom();
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final min = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$min $period';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AiChatProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final primaryText = isDark ? AppColors.textWhite : AppColors.lightTextPrimary;
    final secondaryText = isDark ? AppColors.textGrey : AppColors.lightTextSecondary;

    final isApiConfigured = provider.isInitialized;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.neonGreen.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: AppColors.neonGreen,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FitTrack AI Coach',
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.w700,
                    color: primaryText,
                  ),
                ),
                if (isApiConfigured)
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.neonGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Active • ${provider.activeModelName}',
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? AppColors.textGrey : AppColors.lightTextSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
              ],
            ),
          ],
        ),
        actions: [
          if (isApiConfigured) ...[
            IconButton(
              icon: const Icon(Icons.key_rounded, size: 20),
              tooltip: 'Edit API Key',
              onPressed: () => _showEditApiKeyDialog(context, provider.apiKey),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, size: 20),
              tooltip: 'Clear Chat',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: const Text('Clear Chat History?', style: TextStyle(fontWeight: FontWeight.bold)),
                    content: const Text('Aap is chat ko clear karna chahte hain? Ye wapas nahi aayegi.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel', style: TextStyle(color: AppColors.textGrey)),
                      ),
                      TextButton(
                        onPressed: () {
                          provider.clearChat();
                          Navigator.pop(ctx);
                        },
                        child: const Text('Clear', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ]
        ],
      ),
      body: SafeArea(
        child: isApiConfigured
            ? _buildChatInterface(provider, isDark, primaryText, secondaryText)
            : _buildApiKeySetup(provider, isDark, primaryText, secondaryText),
      ),
    );
  }
}
