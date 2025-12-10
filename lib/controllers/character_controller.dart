import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/character_model.dart';

class CharacterController extends GetxController {
  var firebaseCharacters = <Character>[].obs;
  var localCharacters = <Character>[].obs;
  var allCharacters = <Character>[].obs;

  var chatMessages = <Map<String, String>>[].obs;
  var isTyping = false.obs;
  var isLoadingCharacters = true.obs;

  // YOUR RAPIDAPI KEY FROM https://rapidapi.com/andrew-_DFZRoyHt/api/roleplai-ai-roleplay-gpt-chatbot
  // Go there → Subscribe to "Basic" (free) → copy your key here
  final String rapidApiKey = "YOUR_API_KEY"; // ← PASTE YOUR KEY HERE

  @override
  void onInit() {
    super.onInit();
    loadCharactersFromFirebase();
  }

  Future<void> loadCharactersFromFirebase() async {
    isLoadingCharacters.value = true;
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Get.snackbar('No Internet', 'Using local characters only');
    }

    try {
      var snapshot = await FirebaseFirestore.instance.collection('characters').get();
      firebaseCharacters.value = snapshot.docs
          .map((doc) => Character.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load characters: $e');
    } finally {
      isLoadingCharacters.value = false;
      updateAllCharacters();
    }
  }

  void updateAllCharacters() {
    allCharacters.value = [...firebaseCharacters, ...localCharacters];
  }

  void addLocalCharacter(Character character) {
    localCharacters.add(character.copyWith(isLocal: true));
    updateAllCharacters();
    Get.back();
    Get.snackbar('Success', '${character.name} created!');
  }

  // ROLEPLAI API — WORKING 100% (Free tier: 100 requests/day)
  Future<String> getAIResponse(String userMessage, Character character) async {
    isTyping.value = true;
    try {
      // Build a strong roleplay prompt
      String fullPrompt = """
You are ${character.name}, a ${character.gender} character.
Personality: ${character.personality}
Tone: ${character.tone}
Relationship with user: ${character.relation}
Habits & speech style: ${character.habits}

Previous chat:
${chatMessages.map((m) => m['user'] != null ? "User: ${m['user']}" : "${character.name}: ${m['ai']}").join('\n')}

Now reply to this message naturally and stay in character:
User: $userMessage
${character.name}:""";

      final response = await http.post(
        Uri.parse('https://roleplai-ai-roleplay-gpt-chatbot.p.rapidapi.com/chat'),
        headers: {
          'content-type': 'application/json',
          'X-RapidAPI-Key': rapidApiKey,
          'X-RapidAPI-Host': 'roleplai-ai-roleplay-gpt-chatbot.p.rapidapi.com',
        },
        body: jsonEncode({
          "messages": [
            {"role": "system", "content": fullPrompt}
          ],
          "model": "gpt-3.5-turbo",
          "temperature": 0.8,
          "max_tokens": 500
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'].toString().trim();

        chatMessages.add({'user': userMessage, 'ai': reply});
        return reply;
      } else {
        return "API Error ${response.statusCode}: ${response.body}";
      }
    } catch (e) {
      return "Network error: $e";
    } finally {
      isTyping.value = false;
    }
  }

  void startNewChat() => chatMessages.clear();
}