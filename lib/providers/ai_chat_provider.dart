import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../core/services/storage_service.dart';
import '../core/services/gemini_service.dart';
import '../models/chat_message.dart';

import '../core/services/fitness_ai_engine.dart';

class AiChatProvider extends ChangeNotifier {
  final StorageService _storageService;
  final GeminiService _geminiService = GeminiService();
  
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String _apiKey = '';

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String get apiKey => _apiKey;
  bool get isInitialized => _geminiService.isInitialized;
  String get activeModelName => _geminiService.activeModelName;
  bool get isBuiltInActive => _geminiService.isBuiltInActive;

  AiChatProvider(this._storageService) {
    _apiKey = _storageService.getGeminiApiKey();
    _geminiService.initialize(_apiKey);
    _loadMessages();
  }

  void _loadMessages() {
    final raw = _storageService.getChatHistoryJson();
    try {
      final List list = json.decode(raw);
      _messages = list
          .map((e) => ChatMessage.fromMap(e))
          .where((m) =>
              !m.text.startsWith('Failed to get response:') &&
              !m.text.contains('is no longer available') &&
              !m.text.startsWith('Sorry, response generate karne me error aaya'))
          .toList();
    } catch (_) {
      _messages = [];
    }

    if (_messages.isEmpty) {
      _addWelcomeMessage();
    }
  }

  void _addWelcomeMessage() {
    _messages.add(
      ChatMessage(
        text: "Hi! I am your **FitTrack AI Coach** 🤖. "
            "Aap mujhse workout suggestions, meal plans, calorie information, ya koi bhi fitness related sawal pooch sakte hain.\n\n"
            "Chaliye shuru karte hain! Aaj aap kya seekhna chahte hain?",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  Future<void> updateApiKey(String newKey) async {
    _apiKey = newKey.trim();
    await _storageService.saveGeminiApiKey(_apiKey);
    _geminiService.initialize(_apiKey);
    notifyListeners();
  }

  Future<void> enableBuiltInCoach() async {
    await updateApiKey('builtin');
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );

    _messages.add(userMessage);
    _isLoading = true;
    notifyListeners();
    _saveMessages();

    // Prepare API history (excluding the current user message, max last 20 messages for context)
    List<ChatMessage> historyToUse = _messages.sublist(0, _messages.length - 1);
    if (historyToUse.length > 20) {
      historyToUse = historyToUse.sublist(historyToUse.length - 20);
    }
    
    final apiHistory = historyToUse.map((msg) {
      return Content(
        msg.isUser ? 'user' : 'model',
        [TextPart(msg.text)],
      );
    }).toList();

    try {
      final aiResponseText = await _geminiService.getChatResponse(apiHistory, text.trim());
      
      _messages.add(
        ChatMessage(
          text: aiResponseText,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    } catch (e) {
      // Guaranteed smart fallback — never leave user with an error
      final fallbackResponse = FitnessAiEngine.getResponse(text.trim());
      _messages.add(
        ChatMessage(
          text: fallbackResponse,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
      _saveMessages();
    }
  }

  Future<void> clearChat() async {
    _messages.clear();
    _addWelcomeMessage();
    notifyListeners();
    _saveMessages();
  }

  void _saveMessages() {
    final list = _messages.map((m) => m.toMap()).toList();
    _storageService.saveChatHistoryJson(json.encode(list));
  }
}
