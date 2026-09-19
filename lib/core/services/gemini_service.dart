import 'package:google_generative_ai/google_generative_ai.dart';
import 'fitness_ai_engine.dart';

class GeminiService {
  GenerativeModel? _model;
  String _currentApiKey = '';
  String _activeModelName = 'gemini-3.6-flash';
  bool _useBuiltInCoach = false;

  static const List<String> candidateModels = [
    'gemini-3.6-flash',
    'gemini-3.5-flash',
    'gemini-3.7-flash',
    'gemini-2.5-flash',
    'gemini-1.5-flash',
    'gemini-1.5-flash-latest',
    'gemini-2.5-pro',
    'gemini-1.5-pro',
    'gemini-pro',
  ];

  String get currentApiKey => _currentApiKey;
  bool get isInitialized => true;
  String get activeModelName => _useBuiltInCoach || _currentApiKey.isEmpty ? 'Smart FitCoach' : _activeModelName;
  bool get isBuiltInActive => _useBuiltInCoach || _currentApiKey.isEmpty;
  GenerativeModel? get currentModel => _model;

  void initialize(String apiKey) {
    _currentApiKey = apiKey.trim();
    if (_currentApiKey.isEmpty || _currentApiKey.toLowerCase() == 'builtin' || _currentApiKey.toLowerCase() == 'free') {
      _useBuiltInCoach = true;
      _model = null;
      return;
    }

    _useBuiltInCoach = false;
    _model = _createModel(_activeModelName, _currentApiKey);
  }

  void enableBuiltInCoach() {
    _useBuiltInCoach = true;
  }

  GenerativeModel _createModel(String modelName, String apiKey) {
    return GenerativeModel(
      model: modelName,
      apiKey: apiKey,
      systemInstruction: modelName.startsWith('gemini-pro')
          ? null
          : Content.system(
              "You are 'FitTrack AI Coach', a highly professional, motivating, and friendly personal fitness trainer and nutrition coach. "
              "Your goal is to guide the user to achieve their fitness goals (weight loss, muscle gain, general health, calorie targets, etc.). "
              "Keep your advice practical, safe, and tailored. Keep your responses concise, using clear formatting and bullet points where helpful. "
              "You are fluent in English, Urdu, and Roman Urdu. Always respond in the same language or style that the user uses to chat with you (e.g., if they ask in Roman Urdu, reply in Roman Urdu). "
              "Do not offer clinical medical advice; remind users to consult a doctor or healthcare provider for any injury or medical issues."
            ),
    );
  }

  Future<String> getChatResponse(List<Content> history, String userMessage) async {
    // If using built-in coach or empty key, return smart engine response immediately
    if (_useBuiltInCoach || _currentApiKey.isEmpty || _currentApiKey.toLowerCase() == 'builtin' || _currentApiKey.toLowerCase() == 'free') {
      return FitnessAiEngine.getResponse(userMessage);
    }

    // Build list of models to try, starting with the active one
    final modelsToTry = [
      _activeModelName,
      ...candidateModels.where((m) => m != _activeModelName),
    ];

    for (final modelName in modelsToTry) {
      try {
        final model = _createModel(modelName, _currentApiKey);
        final chat = model.startChat(history: history);
        final response = await chat.sendMessage(Content.text(userMessage));

        if (response.text != null && response.text!.trim().isNotEmpty) {
          // Success! Remember this working model for future requests
          _activeModelName = modelName;
          _model = model;
          return response.text!;
        }
      } catch (e) {
        // Model failure, try next candidate model
        continue;
      }
    }

    // If all cloud API calls failed (deprecation, quota limit, network down, model sunset),
    // NEVER fail to answer! Seamlessly deliver expert guidance using the Built-in Fitness AI Engine!
    return FitnessAiEngine.getResponse(userMessage);
  }
}
